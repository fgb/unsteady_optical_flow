#!/usr/bin/env python
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
# v.0.5
#
# Revisions:
#  Fernando L. Garcia Bermudez      2010-9-11   Initial release.
#  w/Stanley S. Baek                2011-3-4    Switch to ZigBee interface.
#  Humphrey Hu                      2012-2-3    Updated to newer libraries
#                                               and slight restructuring.
#  Fernando L. Garcia Bermudez      2012-8-29   Add synced Vicon streaming.
#  w/Mallory Tayson-Frederick
#
# Notes:
#  - This file is derived from xboptflow.py, by Stanley S. Baek.
#

import sys, os, time, struct, traceback
import numpy as np
from imageproc_py import radio, payload

import roslib; roslib.load_manifest('geometry_msgs')
import rospy
from geometry_msgs.msg import TransformStamped

# Global Declarations
data = {}
cmd  = {}


def main():

    # Execution flags
    do_run_robot = 1

    # Construct filename
    path     = os.path.expanduser('~/Dropbox/tunnel/')
    name     = 'run'
    datetime = time.localtime()
    dt_str   = time.strftime('%Y.%m.%d_%H.%M.%S', datetime)
    root = path + dt_str + '_' + name
    print('I: Experimental data will be saved to ' + root + '*')

    # Radio settings
    src_pan   = '0x1100'
    src_addr  = '0x1101'
    dest_addr = '\x11\x02'
    #port      = '/dev/tty.usbserial-A700ePgy'  # Basestation (osx)
    port      = '/dev/ttyUSB0'                 # Basestation (linux)
    baud      = 230400
    #port      = '/dev/tty.usbserial-A700eYvL' # XBee
    #baud      = 57600

    cmd['SET_MOTOR_SPEED']      = 0
    cmd['ERASE_MEM_CONTENTS']   = 3
    cmd['RECORD_SENSOR_DUMP']   = 4
    cmd['GET_MEM_CONTENTS']     = 5
    cmd['RUN_GYRO_CALIB']       = 0x0d
    cmd['GET_GYRO_CALIB_PARAM'] = 0x0e

    # Data
    data['fs']         = 1000. # [Hz]
    data['t']          = 6     # [s]
    data['samples']    = int(data['t'] * data['fs']) # (max is 0xFFFF, multiple of 3)
    data['packet_cnt'] = 0
    data['sample_cnt'] = 0
    data['dump']       = []
    data['id']         = np.zeros((data['samples'], 1),   dtype=np.uint16)
    data['bemf_ts']    = np.zeros((data['samples'], 1),   dtype=np.uint32)
    data['bemf']       = np.zeros((data['samples'], 1),   dtype=np.uint16)
    data['gyro_ts']    = np.zeros((data['samples'], 1),   dtype=np.uint32)
    data['gyro_calib'] = np.zeros((data['samples'], 3),   dtype=np.float32)
    data['gyro']       = np.zeros((data['samples'], 3),   dtype=np.int16)
    data['row_ts']     = np.zeros((data['samples'], 1),   dtype=np.uint32)
    data['row_num']    = np.zeros((data['samples'], 1),   dtype=np.uint8)
    data['row_valid']  = np.zeros((data['samples'], 1),   dtype=np.uint8)
    data['row']        = np.zeros((data['samples'], 152), dtype=np.uint8)
    data['dcval']      = 90.
    data['fs_v']       = 120. # [Hz]
    data['t_v']        = data['t'] + 4 # [s]
    data['samples_v']  = int(data['t_v'] * data['fs_v'])
    data['sample_v_cnt'] = 0
    data['ts_v']       = np.zeros((data['samples_v'], 2))
    data['pos_v']      = np.zeros((data['samples_v'], 3))
    data['qorn_v']     = np.zeros((data['samples_v'], 4))
    data['do_capture_vicon'] = False


    # Gyro scaling factors
    GYRO_LSB2DEG = 0.0695652174  # 14.375 LSB/(deg/s)
    GYRO_LSB2RAD = 0.00121414209

    # Subscribe to Vicon stream
    rospy.init_node('sensor_dump')
    rospy.Subscriber('/vicon/vamp/Body', TransformStamped, vicon_callback);

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

        # Erase memory contents
        print('I: Erasing memory contents...')
        wrl.send(dest_addr, 0, cmd['ERASE_MEM_CONTENTS'],                     \
                                            struct.pack('<H', data['samples']))
        time.sleep(6)

        # Update duty cycle
        raw_input('Q: To start the run, please [PRESS ANY KEY]')
        data['do_capture_vicon'] = True
        wrl.send(dest_addr, 0, cmd['SET_MOTOR_SPEED'],                      \
                                            struct.pack('<f', data['dcval']))
        print('I: Setting motor to desired duty cycle...')
        time.sleep(2)

        # Request sensor dump to memory
        print('I: Requesting a sensor dump into memory...')
        wrl.send(dest_addr, 0, cmd['RECORD_SENSOR_DUMP'],                     \
                                            struct.pack('<H', data['samples']))
        time.sleep( data['samples'] / data['fs'] + 1 )

        # Stop motor <-- done automatically halfway through sensor dump
        #print('I: Stopping motor...')
        #wrl.send(dest_addr, 0, cmd['SET_MOTOR_SPEED'], struct.pack('<f', 0))
        #time.sleep(0.5)

    # Request memory contents
    raw_input('Q: To request a memory dump, please [PRESS ANY KEY]')
    data['do_capture_vicon'] = False
    print('I: Requesting memory contents...')
    wrl.send(dest_addr, 0, cmd['GET_MEM_CONTENTS'],                          \
        struct.pack('<3H', 0x80, 0x80 + int(np.ceil(data['samples']/3.)), 44))
    time.sleep(0.5)

    raw_input('Q: When data has been received, please [PRESS ANY KEY]')
    print('I: ' + str(data['packet_cnt']) + ' packets received, including ' + \
                                         str(data['sample_cnt']) + ' samples.')

    # Save data to disk
    np.savez_compressed(root + '_data.npz', **data)
    print('I: Arrays saved.')


def received(packet):

    pld         = payload.Payload(packet.get('rf_data'))
    pkt_status  = pld.status
    pkt_type    = pld.type
    pkt_data    = pld.data

    if (pkt_type == cmd['GET_GYRO_CALIB_PARAM']):
        data['gyro_calib'] = struct.unpack('<3f', pkt_data)
    elif (pkt_type == cmd['GET_MEM_CONTENTS']):
        data['packet_cnt'] += 1
        cnt = data['sample_cnt']
        pkt_index = pkt_status % 4
        if cnt < data['samples']:
            if pkt_index == 0:
                data['id'][cnt]        = struct.unpack('<H',   pkt_data[:2])
                data['bemf_ts'][cnt]   = struct.unpack('<L',   pkt_data[2:6])
                data['bemf'][cnt]      = struct.unpack('<H',   pkt_data[6:8])
                data['gyro_ts'][cnt]   = struct.unpack('<L',   pkt_data[8:12])
                data['gyro'][cnt]      = struct.unpack('<3h',  pkt_data[12:18])
                data['row_ts'][cnt]    = struct.unpack('<L',   pkt_data[18:22])
                data['row_num'][cnt]   = struct.unpack('<B',   pkt_data[22:23])
                data['row_valid'][cnt] = struct.unpack('<B',   pkt_data[23:24])
                data['row'][cnt,:20]   = struct.unpack('<20B', pkt_data[24:])
            elif pkt_index == 1:
                data['row'][cnt,20:64] = struct.unpack('<44B', pkt_data)
            elif pkt_index == 2:
                data['row'][cnt,64:108]= struct.unpack('<44B', pkt_data)
            else:
                data['row'][cnt,108:]  = struct.unpack('<44B', pkt_data)
                data['sample_cnt']    += 1
                if data['sample_cnt'] == data['samples']:
                    print('I: All packets were received.')
        else:
            print('W: Extra packet received! Appending to data dump.')
            data['dump'].append([pkt_status, pkt_type, pkt_data])
    else:
        print('E: Invalid packet received! Appending to data dump.')
        data['dump'].append([pkt_status, pkt_type, pkt_data])

def vicon_callback(packet_v):
    cnt_v = data['sample_v_cnt']
    if data['do_capture_vicon'] and (cnt_v < data['samples_v']):
        data['ts_v'][cnt_v]   = [packet_v.header.stamp.secs, \
                                 packet_v.header.stamp.nsecs]
        data['pos_v'][cnt_v]  = [packet_v.transform.translation.x, \
                                 packet_v.transform.translation.y, \
                                 packet_v.transform.translation.z]
        data['qorn_v'][cnt_v] = [packet_v.transform.rotation.x, \
                                 packet_v.transform.rotation.y, \
                                 packet_v.transform.rotation.z, \
                                 packet_v.transform.rotation.w]
        data['sample_v_cnt'] += 1

### Exception handling

if __name__ == '__main__':
    try:
        main()
        sys.exit(0)
    except SystemExit as e:
        print('\nI: SystemExit: ' + str(e))
    except KeyboardInterrupt:
        print('\nI: KeyboardInterrupt')
    except rospy.ROSInterruptException:
        pass
    except Exception as e:
        print('\nE: Unexpected exception!\n' + str(e))
        traceback.print_exc()
