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

import sys, subprocess, time, struct, numpy as np, matplotlib.pyplot as plt, Image

from stanlib.basestation import BaseStation
from stanlib.payload import Payload


#*** Constants ***#

# ZigBee
DEFAULT_SERIAL_PORT = '/dev/tty.usbserial-A700eYvL' # Overriden by argv 1
DEFAULT_BAUD_RATE = 57600                           # Overriden by argv 2
DEST_ADDR = '\x16\x00'       

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

# Files
path = '/Users/fgb/Research/Data/tests/sensorDump/' # where to place experimental data
name = 'test' # filename prefix

# Gyro scaling factors
GYRO_LSB2DEG = 0.0695652174     # 14.375 LSB/(deg/s)
GYRO_LSB2RAD = 0.00121414209

# Other parameters
dcval = 50.00
datasets = 2000 # max is 0xFF the way it's being sent

#*** Variables ***#
count = 0
offset = 0
timestamps = np.zeros((datasets,2), dtype=np.uint32)
gyro = np.zeros((datasets,3), dtype=np.int16)
bemf = np.zeros((datasets,1), dtype=np.uint16)
row = []
rows = np.zeros((datasets,160), dtype=np.uint8)
mem = []
mem_contents = np.zeros((datasets,176), dtype=np.uint8)

data_received = 0


#*** Functions ***#

#def updateDutyCycle(dcval):
#    ser.write(chr(0))       # command
#    ser.write(chr(dcval))   # value
#    reply = ord(ser.read()) # verification
#    if reply == dcval:
#        print('\nCorrectly changed duty cycle to ' + str(dcval) + '.')
#    else:
#        print('\nTried to change duty cycle to ' + str(dcval) + ' but device verification failed (reply was ' + str(ord(ser.read())) + ').')

def xbee_received(packet):
    global data_received
    global root, count, offset, timestamps, gyro, bemf, row, rows, mem, mem_contents

    data_received += 1

    pld = Payload(packet.get('rf_data'))

    status = pld.status
    type = pld.type
    data = pld.data

    if (type == CMD_RECORD_SENSOR_DUMP):
        datum = struct.unpack('L3h', data)
        print(datum[0], datum[1], datum[2], datum[3])
    elif (type == CMD_GET_GYRO_CALIB_PARAM):
        gyro_calib = np.array(struct.unpack('3f', data))
        np.savetxt(root + "_gyro_calib.txt", gyro_calib)
        print gyro_calib
    elif (type == CMD_GET_MEM_CONTENTS):
        if count < datasets:
            if (status % 4) == 0:
                timestamps[count,:] = struct.unpack('2L', data[:8])
                gyro[count,:] = struct.unpack('3h', data[8:14])
                bemf[count] = struct.unpack('H', data[14:16])
                row = list(struct.unpack('28B', data[16:]))
                #mem = list(struct.unpack('44B', data))
            elif (status % 4) < 3:
                row.extend(list(struct.unpack('44B', data)))
                #mem.extend(list(struct.unpack('44B', data)))
            else:
                row.extend(list(struct.unpack('44B', data)))
                #mem.extend(list(struct.unpack('44B', data)))                
                #mem_contents[count] = np.array(mem)               
                if np.mean(row) != 0xFF:
                    rows[count] = np.array(row)
                else:
                    offset += 1
                count += 1                
        elif count == datasets:
            print("all samples were received.")
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

    root = path + name + '_' + str(int(time.time())) + '_' + str(dcval)
    
    #*** Memory contents request
    print("\nRequesting memory contents...") 
    xb.send(0, CMD_GET_MEM_CONTENTS, struct.pack('3H', 0x080, 0x080 + np.ceil(datasets/3.0), 44))
    time.sleep(0.5)

    raw_input("\nPress ENTER when data has been received...")
    xb.close()
    print("\nTotal packets received: " + str(data_received)) + " including " + str(count) + " samples."

    # Account for errors?
    #offset = datasets - count + 1
    timestamp_data = timestamps[:-offset,:]
    gyro_data = gyro[:-offset,:]
    bemf_data = bemf[:-offset]
    rows_data = rows[:-offset]

    # Save files
    np.savetxt(root + '_timestamp_data.txt', timestamp_data)
    np.savetxt(root + '_gyro_data.txt', gyro_data)
    np.savetxt(root + '_bemf_data.txt', bemf_data)
    np.savetxt(root + '_rows_data.txt', rows_data)
    print("\nFiles saved!")

    # Timestamps
    times = timestamp_data/1E6
    dtimes = times[1:,:] - times[:-1,:]
    freqs = 1/dtimes
    
    t = np.mean(times, 1)
    dt = t[1:] - t[:-1]
    fs = 1/dt
    
    # Gyro
    plt.figure(1)
    plt.plot(t,gyro_data[:,0],t,gyro_data[:,1],t,gyro_data[:,2])
    
    # Back-EMF
    V = 4.0 * np.array(1023.0 - bemf_data, dtype=float) / 1023.0
    plt.figure(2)
    plt.plot(t,V)
    
    # Rows
    #plt.figure(3)
    #plt.imshow(rows_data)
    #plt.gray()
    import Image
    Image.fromarray(rows_data).show()
    
    # Show plots
    #plt.show()
