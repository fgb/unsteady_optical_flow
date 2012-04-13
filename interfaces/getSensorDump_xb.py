#!/usr/bin/python
#
# Copyright (c) 2010-2011, Regents of the University of California
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

from stanlib.basestation import BaseStation
from stanlib.payload import Payload


#*** Constants ***#

# ZigBee
#DEFAULT_SERIAL_PORT = '/dev/tty.usbserial-A700eYvL' # Overriden by argv 1
#DEFAULT_BAUD_RATE = 57600                           # Overriden by argv 2

# Basestation
DEFAULT_SERIAL_PORT = '/dev/tty.usbserial-A700ePgy' # Overriden by argv 1
DEFAULT_BAUD_RATE = 230400                          # Overriden by argv 2

DEST_ADDR = '\x20\x22'

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
count     = 0
sample    = np.zeros((datasets,1), dtype=np.uint16)
timestamp = np.zeros((datasets,1), dtype=np.uint32)
bemf      = np.zeros((datasets,1), dtype=np.uint16)
gyro      = np.zeros((datasets,3), dtype=np.int16)
vsync     = np.zeros((datasets,2), dtype=np.uint8)
row       = []
rows      = np.zeros((datasets,160), dtype=np.uint8)

offset = 0

data_received = 0


#*** Functions ***#

def xbee_received(packet):
    global  data_received, root, count, offset, \
            sample, timestamp, bemf, gyro, vsync, row, rows

    data_received += 1

    pld = Payload(packet.get('rf_data'))

    status = pld.status
    type = pld.type
    data = pld.data

    if (type == CMD_RECORD_SENSOR_DUMP):
        datum = struct.unpack('<L3h', data)
        print(datum[0], datum[1], datum[2], datum[3])
    elif (type == CMD_GET_GYRO_CALIB_PARAM):
        gyro_calib = np.array(struct.unpack('<3f', data))
        print gyro_calib
    elif (type == CMD_GET_MEM_CONTENTS):
        if count < datasets:
            if (status % 4) == 0:
                sample[count] = struct.unpack('<H', data[:2])
                timestamp[count] = struct.unpack('<I', data[2:6])
                bemf[count] = struct.unpack('<H', data[6:8])
                gyro[count,:] = struct.unpack('<3h', data[8:14])
                vsync[count,:] = struct.unpack('<2B', data[14:16])
                rows[count,:28] = np.array(struct.unpack('<28B', data[16:]))
                #row = list(struct.unpack('<28B', data[16:]))
            elif (status % 4) < 3:
                rows[count,28:72] = np.array(struct.unpack('<44B', data))
                #row.extend(list(struct.unpack('<44B', data)))
            else:
                rows[count,72:116] = np.array(struct.unpack('<44B', data))
                #row.extend(list(struct.unpack('<44B', data)))
                #rows[count] = np.array(row)                
                if np.mean(rows[count]) == 0xFF:
                    offset += 1
                count += 1
        elif count == datasets:
            print("...all samples were received.")
            count += 1         
    elif (type == CMD_ECHO):
        print status, type, data
    else: 
        print "invalid"
        dumpster.append([status, type, data])


#*** Program ***#

if __name__ == '__main__':

    # Check and parse arguments
    if len(sys.argv) == 1:
        print("\nUsing default arguments...")
        xb = BaseStation(DEFAULT_SERIAL_PORT, DEFAULT_BAUD_RATE, DEST_ADDR, xbee_received)
    elif len(sys.argv) == 7:
        print("\nUsing command-line arguments...")
        xb = BaseStation(sys.argv[1], int(sys.argv[2]), DEST_ADDR, xbee_received)
        path = sys.argv[3]
        dcval = float(sys.argv[4])
        datasets = int(sys.argv[5])
        name = sys.argv[6]
    else:
        print("Incorrect number of arguments. Need serial port, baudrate, path/, duty cycle, and experiment name.")
        sys.exit(1)

    root = path + name + '_' + str(int(time.time())) #+ '_' + str(dcval)    

    #*** Get gyro calibration data    
    print("\nRunning gyro calibration...")
    xb.send(0, CMD_RUN_GYRO_CALIB, struct.pack('<H', 2000));
    time.sleep(3)
    xb.send(0, CMD_GET_GYRO_CALIB_PARAM, " ");
    time.sleep(1)

    #*** Duty Cycle update
    print("\nSet motor to desired duty cycle...")
    xb.send(0, CMD_SET_MOTOR_SPEED, struct.pack('<f', dcval))
    time.sleep(0.5)    

    #*** Sensor dump to memory request    
    print("\nRequesting a sensor dump into memory...")
    xb.send(0, CMD_RECORD_SENSOR_DUMP, struct.pack('<H', datasets))
    time.sleep(2.5)

    #*** Stop motor <-- done automatically when requesting mem contents
    #print("\nStopping motor...")
    #xb.send(0, CMD_SET_MOTOR_SPEED, struct.pack('<f', 0))
    #time.sleep(0.5)

    #*** Memory contents request
    print("\nRequesting memory contents...") 
    xb.send(0, CMD_GET_MEM_CONTENTS, struct.pack('<3H', 0x080, 0x080 + int(np.ceil(datasets/3.0)), 44))
    time.sleep(0.5)

    raw_input("\nPress ENTER when data has been received...")
    xb.close()
    print("\nTotal packets received: " + str(data_received)) + " including " + str(count) + " samples."

    # Account for errors?
    print("Account for errors? Offset = " + str(offset))
    #timestamp_data = timestamp[:-offset,:]
    #gyro_data = gyro[:-offset,:]
    #bemf_data = bemf[:-offset]
    #rows_data = rows[:-offset]

    # Save all variables for easy import
    np.savez(root + '_data.npz', sample=sample, timestamp=timestamp, \
        bemf=bemf, dcval=dcval, gyro=gyro, vsync=vsync, rows=rows)
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
