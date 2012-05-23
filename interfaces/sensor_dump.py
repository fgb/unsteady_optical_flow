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
# v.0.3
#
# Revisions:
#  Fernando L. Garcia Bermudez      2010-9-11   Initial release.
#  w/Stanley S. Baek                2011-3-4    Switch to ZigBee interface.
#  Humphrey Hu                      2012-2-3    Updated to newer libraries
#                                               and slight restructuring.
#
# Notes:
#  - This file is derived from xboptflow.py, by Stanley S. Baek.
#

import sys, os, time, struct, traceback
import numpy as np, matplotlib.pyplot as plt, Image
from pymageproc import radio, payload

# Global Declarations
cmd  = {}


def main():
    global datasets, data_rx, count, dump, sample, bemf, gyro, gyro_ts,   \
                                                    rows, rows_num, rows_ts
    # Execution flags
    do_run_robot = 1

    # Construct filename
    path     = os.path.expanduser('~/Research/Data/tests/sensorDump/')
    name     = 'test'
    datetime = time.localtime()
    dt_str   = time.strftime('%Y.%m.%d_%H.%M.%S', datetime)
    root = path + dt_str + '_' + name
    print('I: Experimental data will be saved to ' + root + '*')

    # Radio settings
    src_pan   = '0x1100'
    src_addr  = '0x1101'
    dest_addr = '\x11\x02'
    port      = '/dev/tty.usbserial-A700ePgy'  # Basestation
    baud      = 230400
    #port      = '/dev/tty.usbserial-A700eYvL' # XBee
    #baud      = 57600

    cmd['SET_MOTOR_SPEED']      = 0
    cmd['RECORD_SENSOR_DUMP']   = 4
    cmd['GET_MEM_CONTENTS']     = 5
    cmd['RUN_GYRO_CALIB']       = 0x0d
    cmd['GET_GYRO_CALIB_PARAM'] = 0x0e

    # Data
    datasets = 3000 # (max is 0xFFFF, multiple of 3)
    data_rx  = 0
    count    = 0
    dump     = []
    sample   = np.zeros((datasets,1), dtype=np.uint16)
    bemf     = np.zeros((datasets,1), dtype=np.uint16)
    gyro     = np.zeros((datasets,3), dtype=np.int16)
    gyro_ts  = np.zeros((datasets,1), dtype=np.uint16)
    rows     = np.zeros((datasets,160), dtype=np.uint8)
    rows_num = np.zeros((datasets,1), dtype=np.uint16)
    rows_ts  = np.zeros((datasets,1), dtype=np.uint16)

    # Gyro scaling factors
    GYRO_LSB2DEG = 0.0695652174  # 14.375 LSB/(deg/s)
    GYRO_LSB2RAD = 0.00121414209

    # Motor
    dcval = 0.0

    # Establish communication link
    wrl = radio.radio(port, baud, received)
    #wrl.setSrcPan(src_pan)
    #wrl.setSrcAddr(src_addr)

    # Run robot
    if do_run_robot:
        # Get gyro calibration data
        wrl.send(dest_addr, 0, cmd['RUN_GYRO_CALIB'], struct.pack('<H', 2000));
        print('I: Running gyro calibration...')
        time.sleep(2)
        wrl.send(dest_addr, 0, cmd['GET_GYRO_CALIB_PARAM'], ' ');

        # Update duty cycle
        wrl.send(dest_addr, 0, cmd['SET_MOTOR_SPEED'],                      \
        print('I: Setting motor to desired duty cycle...')

        # Request sensor dump to memory
        print('I: Requesting a sensor dump into memory...')
        wrl.send(dest_addr, 0, cmd['RECORD_SENSOR_DUMP'],                     \
        time.sleep(3)

        # Stop motor <-- done automatically halfway through sensor dump
        #print('I: Stopping motor...')
        #wrl.send(dest_addr, 0, cmd['SET_MOTOR_SPEED'], struct.pack('<f', 0))
        #time.sleep(0.5)

    # Request memory contents
    raw_input('Press any key to request memory read')
    print('I: Requesting memory contents...')
    wrl.send(dest_addr, 0, cmd['GET_MEM_CONTENTS'],
    time.sleep(0.5)

    raw_input('I: Press ENTER when data has been received...')
    print('I: Total packets received: ' + str(data_rx) + ' including ' + str(count) + ' samples.')

    # Save all variables for easy import
    np.savez(root + '_data.npz', dcval=dcval, sample=sample, bemf=bemf, \
             gyro=gyro, gyro_ts=gyro_ts, rows=rows, rows_num=rows_num,  \
                                                         rows_ts=rows_ts)
    print('I: Arrays saved.')

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

def received(packet):
    global data_rx, count, dump, sample, bemf, gyro, gyro_ts, rows, rows_num, \
                                                                        rows_ts
    data_rx += 1

    pld = payload.Payload(packet.get('rf_data'))

    pkt_status = pld.status
    pkt_type   = pld.type
    pkt_data   = pld.data
    index      = 0

    if (pkt_type == cmd['GET_GYRO_CALIB_PARAM']):
        gyro_calib = np.array(struct.unpack('<3f', pkt_data))
        print(gyro_calib)
    elif (type == CMD_GET_MEM_CONTENTS):
        if count < datasets:
            index = pkt_status % 4
            if index == 0:
                sample[count]       = struct.unpack('<H',  data[:2])     # (2)
                bemf[count]         = struct.unpack('<H',  data[2:4])    # (2)
                gyro[count,:]       = struct.unpack('<3h', data[4:10])   # (6)
                gyro_ts[count]      = struct.unpack('<H',  data[10:12])  # (2)
                rows_num[count]     = struct.unpack('<H',  data[12:14])  # (2)
                rows_ts[count]      = struct.unpack('<H',  data[14:16])  # (2)
                rows[count,:28]     = np.array(struct.unpack('<28B', \
                                                           data[16:44])) # (160)
            elif index == 1:
                rows[count,28:72]   = np.array(struct.unpack('<44B', \
                                                           data[:44]))
            elif index == 2:
                rows[count,72:116]  = np.array(struct.unpack('<44B', \
                                                            data[:44]))
            elif index == 3:
                rows[count,116:160] = np.array(struct.unpack('<44B', \
                                                            data[:44]))
                count += 1
        elif count == datasets:
            print('...all samples were received.')
    else:
        print('invalid')
        dump.append([status, type, data])


### Exception handling

if __name__ == '__main__':
    try:
        main()
        sys.exit(0)
    except SystemExit as e:
        print('\nI: SystemExit: ' + str(e))
    except KeyboardInterrupt:
        print('\nI: KeyboardInterrupt')
    except Exception as e:
        print('\nE: Unexpected exception!\n' + str(e))
        traceback.print_exc()
