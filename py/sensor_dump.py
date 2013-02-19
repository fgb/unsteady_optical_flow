#!/usr/bin/env python
#
# Copyright (c) 2010-2013, Regents of the University of California
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
# v.0.6
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

import sys, os, time, struct, traceback, logging as lg, argparse, shelve, pickle
import numpy as np
from imageproc_py import radio, payload, utils

#import roslib; roslib.load_manifest('vicon_bridge')
#import rospy
#from geometry_msgs.msg import TransformStamped

def main():
    global p, d, do_capture_vicon

    # Parse command line arguments
    parser = argparse.ArgumentParser()
    parser.add_argument('filename', metavar='f', type=str, nargs=1,
                            help='configuration file containing parameters')
    configfile = parser.parse_args().filename[0]

    # Load parameters from configuration file
    # TODO (fgb) : Do we really need params and p here, or would p just suffice?
    params = utils.load_config(configfile)
    p      = utils.Bunch(params)

    # Construct filename
    root     = os.path.expanduser(p.root)
    datetime = time.localtime()
    dt_str   = time.strftime('%Y.%m.%d_%H.%M.%S', datetime)
    datafile = root + dt_str

    # Set up logging
    datafile_log = datafile + '_session.log'
    lg.basicConfig(
        filename = datafile_log,
        level    = lg.DEBUG,
        format   = '%(asctime)s.%(msecs).03d %(name)s | %(message)s',
        datefmt  = '%Y-%m-%d %H:%M:%S',
    )
    sys.stdout = utils.PrintAndLog(lg.getLogger('STDOUT'), lg.INFO)
    sys.stderr = utils.PrintAndLog(lg.getLogger('STDERR'), lg.ERROR)

    # Log session details
    print('I: Experimental data will be saved to ' + root + \
        '\nI: Session will be logged to ' + os.path.basename(datafile_log))

    # Data
    data = {}

    data['samples']    = int(p.t * p.fs) # (max is 0xFFFF, multiple of 3)
    data['sample_cnt'] = 0
    data['packet_cnt'] = 0
    data['dump']       = []

    # TODO (fgb) : We should request capture settings from robot?
    data['id']         = np.zeros((data['samples'],   1), dtype=np.uint16)
    data['bemf_ts']    = np.zeros((data['samples'],   1), dtype=np.uint32)
    data['bemf']       = np.zeros((data['samples'],   1), dtype=np.uint16)
    data['gyro_ts']    = np.zeros((data['samples'],   1), dtype=np.uint32)
    data['gyro_calib'] = np.zeros((3),                    dtype=np.float32)
    data['gyro']       = np.zeros((data['samples'],   3), dtype=np.int16)
    data['row_ts']     = np.zeros((data['samples'],   1), dtype=np.uint32)
    data['row_num']    = np.zeros((data['samples'],   1), dtype=np.uint8)
    data['row_valid']  = np.zeros((data['samples'],   1), dtype=np.uint8)
    data['row']        = np.zeros((data['samples'], 152), dtype=np.uint8)

    data['samples_v']    = int(p.t_v * p.fs_v)
    data['sample_v_cnt'] = 0
    data['ts_v']         = np.zeros((data['samples_v'], 2))
    data['pos_v']        = np.zeros((data['samples_v'], 3))
    data['qorn_v']       = np.zeros((data['samples_v'], 4))

    d = utils.Bunch(data)

    # Subscribe to Vicon stream
    #rospy.init_node('sensor_dump')
    #rospy.Subscriber('/vicon/vamp/Body', TransformStamped, vicon_callback);
    #do_capture_vicon = False

    # Establish communication link
    wrl = radio.radio(p.port, p.baud, received)
    #wrl.setSrcPan(p.src_pan)
    #wrl.setSrcAddr(p.src_addr)

    print('I: Setting sampling period to ' + str(p.ts) + ' [us]')
    wrl.send(p.dest_addr, 0, p.cmd_set_sampling_period, struct.pack('<H', p.ts))

    print('I: Setting starting memory page to ' + str(p.mem_page_start))
    wrl.send(p.dest_addr, 0, p.cmd_set_memory_page_start,
                                        struct.pack('<H', p.mem_page_start))

    print('I: Getting capture settings...')
    wrl.send(p.dest_addr, 0, p.cmd_get_settings, ' ')

    if p.do_run_robot:

        print('I: Running gyro calibration...')
        wrl.send(p.dest_addr, 0, p.cmd_calibrate_gyro, struct.pack('<H', 2000))
        time.sleep(2)
        wrl.send(p.dest_addr, 0, p.cmd_get_gyro_calibration, ' ')

        print('I: Erasing memory contents...')
        # TODO (fgb) : Request n seconds instead of samples
        wrl.send(p.dest_addr, 0, p.cmd_erase_memory, \
                                                struct.pack('<H', d.samples))
        time.sleep(p.t + 1)

        raw_input('Q: To start the run, please [PRESS ANY KEY]')
        do_capture_vicon = True
        wrl.send(p.dest_addr, 0, p.cmd_set_motor_speed, \
                                                struct.pack('<f', p.dcval))
        print('I: Setting motor to desired duty cycle...')
        time.sleep(2)

        print('I: Requesting a sensor dump into memory...')
        # TODO (fgb) : Request n seconds instead of samples
        wrl.send(p.dest_addr, 0, p.cmd_record_sensor_dump, \
                                                struct.pack('<H', d.samples))
        time.sleep(p.t + 1)

        #raw_input('Q: To stop the run, please [PRESS ANY KEY]')
        #print('I: Stopping motor...') # automatically done halfway through dump
        #wrl.send(p.dest_addr, 0, p.cmd_set_motor_speed, struct.pack('<f', 0))
        #time.sleep(0.5)

    raw_input('Q: To request a memory dump, please [PRESS ANY KEY]')
    do_capture_vicon = False
    print('I: Requesting memory contents...')
    # TODO (fgb) : Get rid of statically allocated memory locations
    wrl.send(p.dest_addr, 0, p.cmd_read_memory, \
            struct.pack('<3H', 0x80, 0x80 + int(np.ceil(d.samples/3.)), 44))
    time.sleep(0.5)

    raw_input('Q: When data has been received, please [PRESS ANY KEY]')
    print('I: ' + str(d.packet_cnt) + ' packets received, including ' + \
                                            str(d.sample_cnt) + ' samples.')

    # Shelve session information
    datafile_shelf = datafile + '_session.shelf'
    shelf = shelve.open(datafile_shelf)
    for key in dir():
        try:
            dump = pickle.dumps(locals()[key])
            shelf[key] = locals()[key]
        except:
            print('W: ' + key + ' will not be saved!')
    shelf.close()
    print('I: Saved session to ' + os.path.basename(datafile_shelf))

    latest_symlink = root + 'latest_session.shelf'
    if os.path.exists(latest_symlink):
        os.remove(latest_symlink)
    os.symlink(datafile_shelf, latest_symlink)
    print('I: Linked session to ' + os.path.basename(latest_symlink))

def received(packet):
    global p, d

    pld        = payload.Payload(packet.get('rf_data'))
    pkt_status = pld.status
    pkt_type   = pld.type
    pkt_data   = pld.data

    if ( pkt_type == p.cmd_get_gyro_calibration ):
        d.gyro_calib = struct.unpack('<3f', pkt_data)
    elif ( pkt_type == p.cmd_read_memory ):
        d.packet_cnt += 1
        cnt = d.sample_cnt
        pkt_index = pkt_status % 4
        if cnt < d.samples:
            if pkt_index == 0:
                d.id[cnt]        = struct.unpack('<H',   pkt_data[:2])
                d.bemf_ts[cnt]   = struct.unpack('<L',   pkt_data[2:6])
                d.bemf[cnt]      = struct.unpack('<H',   pkt_data[6:8])
                d.gyro_ts[cnt]   = struct.unpack('<L',   pkt_data[8:12])
                d.gyro[cnt]      = struct.unpack('<3h',  pkt_data[12:18])
                d.row_ts[cnt]    = struct.unpack('<L',   pkt_data[18:22])
                d.row_num[cnt]   = struct.unpack('<B',   pkt_data[22:23])
                d.row_valid[cnt] = struct.unpack('<B',   pkt_data[23:24])
                d.row[cnt,:20]   = struct.unpack('<20B', pkt_data[24:])
            elif pkt_index == 1:
                d.row[cnt,20:64] = struct.unpack('<44B', pkt_data)
            elif pkt_index == 2:
                d.row[cnt,64:108]= struct.unpack('<44B', pkt_data)
            else:
                d.row[cnt,108:]  = struct.unpack('<44B', pkt_data)
                d.sample_cnt    += 1
                if d.sample_cnt == d.samples:
                    print('I: All packets were received.')
        else:
            print('W: Extra packet received! Appending to data dump.')
            d.dump.append([pkt_status, pkt_type, pkt_data])
    elif ( pkt_type == p.cmd_get_settings ):
        print(struct.unpack('<6H', pkt_data))
    else:
        print('E: Invalid packet received! Appending to data dump.')
        d.dump.append([pkt_status, pkt_type, pkt_data])

#def vicon_callback(packet_v):
#    globals d, do_capture_vicon
#
#    cnt_v = d.sample_v_cnt
#    if do_capture_vicon and (cnt_v < d.samples_v):
#        d.ts_v[cnt_v]   = [packet_v.header.stamp.secs, \
#                           packet_v.header.stamp.nsecs]
#        d.pos_v[cnt_v]  = [packet_v.transform.translation.x, \
#                           packet_v.transform.translation.y, \
#                           packet_v.transform.translation.z]
#        d.qorn_v[cnt_v] = [packet_v.transform.rotation.w, \
#                           packet_v.transform.rotation.x, \
#                           packet_v.transform.rotation.y, \
#                           packet_v.transform.rotation.z, ]
#        d.sample_v_cnt += 1

### Exception handling

if __name__ == '__main__':
    try:
        main()
        sys.exit(0)
    except SystemExit as e:
        print('\nI: SystemExit: ' + str(e))
    except KeyboardInterrupt:
        print('\nI: KeyboardInterrupt')
    #except rospy.ROSInterruptException:
    #    pass
    except Exception as e:
        print('\nE: Unexpected exception!\n' + str(e))
        traceback.print_exc()
