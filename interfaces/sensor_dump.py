#!/usr/bin/python
#
# Copyright (c) 2010-2012, Regents of the University of California
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# - Redistributions of source code must retain the above copyright notice,
#   this list of conditions and the following disclaimer.
# - Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the documentation
#   and/or other materials provided with the distribution.
# - Neither the name of the University of California, Berkeley nor the names
#   of its contributors may be used to endorse or promote products derived
#   from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#
#
# Request a sensor dump
#
# by Fernando L. Garcia Bermudez and Stanley S. Baek
#
# v.beta
#
# Revisions:
#  Fernando L. Garcia Bermudez      2010-9-11   Initial release
#  w/Stanley S. Baek                2011-3-4    Switch to ZigBee interface
#
# Notes:
#  - This file is derived from xboptflow.py, by Stanley S. Baek.
#

import sys, subprocess, time, struct
import numpy as np, matplotlib.pyplot as plt, Image

from ofhlib.basestation import BaseStation
from ofhlib.payload import Payload


#*** Constants ***#

# XBee
#DEFAULT_SERIAL_PORT = '/dev/tty.usbserial-A700eYvL' # Overriden by argv 1
#DEFAULT_BAUD_RATE = 57600                           # Overriden by argv 2

# Basestation
DEFAULT_SERIAL_PORT = '/dev/tty.usbserial-A700ePgy' # Overriden by argv 1
DEFAULT_BAUD_RATE = 230400                          # Overriden by argv 2

SRC_PAN   = '0x1100'
SRC_ADDR  = '0x1101'
DEST_ADDR = '\x11\x02'

# Commands
CMD_SET_MOTOR_SPEED      = 0
CMD_GET_PICTURE          = 1
CMD_GET_VIDEO            = 2
CMD_GET_LINES            = 3
CMD_RECORD_SENSOR_DUMP   = 4
CMD_GET_MEM_CONTENTS     = 5
CMD_RUN_GYRO_CALIB       = 0x0d
CMD_GET_GYRO_CALIB_PARAM = 0x0e
CMD_ECHO                 = 0x0f

# Where to place exp data
path = '/Users/fgb/Research/Data/tests/sensorDump/' # Overriden by argv 3
name = 'test'                                       # Overriden by argv 6

# Gyro scaling factors
GYRO_LSB2DEG = 0.0695652174     # 14.375 LSB/(deg/s)
GYRO_LSB2RAD = 0.00121414209

# Other parameters
dcval    = 5.0  # Overriden by argv 4
datasets = 3000 # Overriden by argv 5 (max is 0xFFFF, multiple of 3)


#*** Variables ***#
count           = 0
offset          = 0
sample          = np.zeros((datasets,1), dtype=np.uint16)
bemf            = np.zeros((datasets,1), dtype=np.uint16)
gyro            = np.zeros((datasets,3), dtype=np.int16)
gyroTimestamp   = np.zeros((datasets,1), dtype=np.uint16)
rowNum          = np.zeros((datasets,1), dtype=np.uint16)
rowTimestamp    = np.zeros((datasets,1), dtype=np.uint16)
rows            = np.zeros((datasets,160), dtype=np.uint8)
dumpster        = []
data_received   = 0
xb              = None
run_robot       = True


#*** Functions ***#

def xbee_received(packet):
    global data_received, root, count, offset, sample, timestamp, bemf, gyro, \
                                                               vsync, row, rows

    data_received += 1

    pld = Payload(packet.get('rf_data'))

    status = pld.status
    type = pld.type
    data = pld.data
    index = 0

    if (type == CMD_RECORD_SENSOR_DUMP):
        datum = struct.unpack('<L3h', data)
        print(datum[0], datum[1], datum[2], datum[3])
    elif (type == CMD_GET_GYRO_CALIB_PARAM):
        gyro_calib = np.array(struct.unpack('<3f', data))
        print gyro_calib
    elif (type == CMD_GET_MEM_CONTENTS):
        if count < datasets:
            index = status % 4
            if index == 0:
                sample[count] = struct.unpack('<H', data[:2])
                bemf[count] = struct.unpack('<H', data[2:4])
                gyro[count,:] = struct.unpack('<3h', data[4:10])
                gyroTimestamp[count] = struct.unpack('<H', data[10:12])
                rowNum[count] = struct.unpack('<H', data[12:14])
                rowTimestamp[count] = struct.unpack('<H', data[14:16])
                rows[count,:28] = np.array(struct.unpack('<28B', data[16:44]))
            elif index == 1:
                rows[count,28:72] = np.array(struct.unpack('44B', data[0:44]))
            elif index == 2:
                rows[count,72:116] = np.array(struct.unpack('44B', data[0:44]))
            elif index == 3:
                rows[count, 116:160] = np.array(struct.unpack('44B', data[0:44]))
                count += 1
        elif count == datasets:
            print("...all samples were received.")
    elif (type == CMD_ECHO):
        print status, type, data
    else:
        print "invalid"
        dumpster.append([status, type, data])

def main():
    global xb

    # Check and parse arguments
    if len(sys.argv) == 1:
        print("\nUsing default arguments...")
        ser = DEFAULT_SERIAL_PORT
        baud = DEFAULT_BAUD_RATE
    elif len(sys.argv) == 7:
        print("\nUsing command-line arguments...")
        ser = sys.argv[1]
        baud = int(sys.argv[2])
        path = sys.argv[3]
        dcval = float(sys.argv[4])
        datasets = int(sys.argv[5])
        name = sys.argv[6]
    else:
        print("Incorrect number of arguments. Need serial port, baudrate, path/, duty cycle, and experiment name.")
        sys.exit(1)

    root = path + name + '_' + str(int(time.time())) # + '_' + str(dcval)

    if run_robot:
        xb = BaseStation(ser, baud, DEST_ADDR, xbee_received)
        xb.setSrcPan(SRC_PAN)
        xb.setSrcAddr(SRC_ADDR)

        #*** Get gyro calibration data
        raw_input("Press any key to run gyro calibration")
        print("\nRunning gyro calibration...")
        xb.send(0, CMD_RUN_GYRO_CALIB, struct.pack('<H', 2000));
        time.sleep(3)
        raw_input("Press any key to request parameters...")
        xb.send(0, CMD_GET_GYRO_CALIB_PARAM, " ");
        time.sleep(1)

        #*** Duty Cycle update
        raw_input("Press any key to set motor speed")
        print("\nSet motor to desired duty cycle...")
        xb.send(0, CMD_SET_MOTOR_SPEED, struct.pack('<f', dcval))
        time.sleep(0.5)

        #*** Sensor dump to memory request
        raw_input("Press any key to begin sensor dump")
        print("\nRequesting a sensor dump into memory...")
        xb.send(0, CMD_RECORD_SENSOR_DUMP, struct.pack('<H', datasets))
        time.sleep(2.5)

        #*** Stop motor <-- done automatically when requesting mem contents
        #print("\nStopping motor...")
        #xb.send(0, CMD_SET_MOTOR_SPEED, struct.pack('<f', 0))
        #time.sleep(0.5)

    #*** Memory contents request
    raw_input("Press any key to request memory read")
    print("\nRequesting memory contents...")
    xb.send(0, CMD_GET_MEM_CONTENTS, struct.pack('<3H', 0x080, 0x080 + int(np.ceil(datasets/3.0)), 44))
    time.sleep(0.5)

    raw_input("\nPress ENTER when data has been received...")
    print("\nTotal packets received: " + str(data_received)) + " including " + str(count) + " samples."

    # Account for errors?
    print("Account for errors? Offset = " + str(offset))
    #timestamp_data = timestamp[:-offset,:]
    #gyro_data = gyro[:-offset,:]
    #bemf_data = bemf[:-offset]
    #rows_data = rows[:-offset]

    # Save all variables for easy import
    np.savez(root + '_data.npz', sample=sample,
        bemf=bemf, dcval=dcval, gyro=gyro, gyroTimestamp=gyroTimestamp,
        rowNum = rowNum, rows=rows, rowTimestamp=rowTimestamp)
    print("...arrays saved. Done.")

    # Save files
    #np.savetxt(root + '_timestamp_data.txt', timestamp_data)
    #np.savetxt(root + "_gyro_calib.txt", gyro_calib)
    #np.savetxt(root + '_gyro_data.txt', gyro_data)
    #np.savetxt(root + '_bemf_data.txt', bemf_data)
    #np.savetxt(root + '_rows_data.txt', rows_data)
    #print("\nFiles saved!")


    #*** Visualize sensor dump

    ## Timestamps
    #t = timestamp/1E6
    ##dt = t[1:] - t[:-1]
    ##fs = 1/dt
    ##print(fs)
    #
    ## Gyro
    #plt.figure()
    #plt.plot(t,gyro[:,0], t,gyro[:,1], t,gyro[:,2])
    #
    ## Back-EMF
    #V = 4.0 * np.array(1023.0 - bemf, dtype=float) / 1023.0
    #plt.figure()
    #plt.plot(t,V)
    #
    ## Rows
    #Image.fromarray(rows).show()
    #
    ## Show plots
    #plt.show()

def cleanup():
    global xb
    print "Beginning cleanup."

    print "Closing radio link..."
    xb.close()

    print "Cleanup complete."


#*** Program ***#

# Args: serial port, baud rate, path, dcval, datasets, name
if __name__ == '__main__':
    try:
        main()
    finally:
        cleanup()
