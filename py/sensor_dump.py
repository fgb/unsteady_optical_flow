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

import sys, os, time, traceback, logging as lg, argparse, shelve, pickle
import struct as st, numpy as np
from imageproc_py import radio, payload, utils


def main():

    global p, s, d, do_save_vicon_stream

    # Parse command line arguments
    parser = argparse.ArgumentParser()
    parser.add_argument('filename', metavar='f', type=str, nargs=1,
                            help='configuration file containing parameters')
    configfile = parser.parse_args().filename[0]

    # Load parameters from configuration file
    p = utils.Bunch(utils.load_config(configfile))

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

    # Establish communication link
    wrl = radio.radio(p.port, p.baud, received)
    #wrl.setSrcPan(p.src_pan)
    #wrl.setSrcAddr(p.src_addr)

    print('I: Resetting sensor capture board...')
    wrl.send(p.dest_addr, 0, p.cmd_reset)
    time.sleep(3)

    # Capture settings
    settings = {}

    settings['sampling_period']  = 0
    settings['mem_page_start']   = 0
    settings['motor_duty_cycle'] = 0
    settings['samples']          = 0
    settings['sample_motor_on']  = 0
    settings['sample_motor_off'] = 0
    settings['vicon_samples']    = int(p.vicon_t * p.vicon_fs)

    s = utils.Bunch(settings)

    print('I: Getting capture settings...')
    wrl.send(p.dest_addr, 0, p.cmd_get_settings)
    time.sleep(1)

    s.samples          = int(p.t * p.t_factor / s.sampling_period)
    s.sample_motor_on  = int(p.motor_on  * p.t * p.t_factor / s.sampling_period)
    s.sample_motor_off = int(p.motor_off * p.t * p.t_factor / s.sampling_period)

    # Data
    data = {}

    data['packet_cnt'] = 0
    data['sample_cnt'] = 0

    data['id']         = np.zeros((s.samples,   1), dtype=np.uint16)
    data['bemf_ts']    = np.zeros((s.samples,   1), dtype=np.uint32)
    data['bemf']       = np.zeros((s.samples,   1), dtype=np.uint16)
    data['gyro_ts']    = np.zeros((s.samples,   1), dtype=np.uint32)
    data['gyro_calib'] = np.zeros(             (3), dtype=np.float32)
    data['gyro']       = np.zeros((s.samples,   3), dtype=np.int16)
    data['row_ts']     = np.zeros((s.samples,   1), dtype=np.uint32)
    data['row_num']    = np.zeros((s.samples,   1), dtype=np.uint8)
    data['row_valid']  = np.zeros((s.samples,   1), dtype=np.uint8)
    data['row']        = np.zeros((s.samples, 152), dtype=np.uint8)

    if p.do_stream_vicon:

        data['vicon_sample_cnt'] = 0

        data['vicon_ts']   = np.zeros((s.vicon_samples, 2))
        data['vicon_pos']  = np.zeros((s.vicon_samples, 3))
        data['vicon_qorn'] = np.zeros((s.vicon_samples, 4))

    data['dump'] = []

    d = utils.Bunch(data)

    if p.do_stream_vicon:

        import roslib, rospy
        from geometry_msgs.msg import TransformStamped
        roslib.load_manifest('vicon_bridge')

        # Subscribe to Vicon stream
        do_save_vicon_stream = False
        rospy.init_node('sensor_dump')
        rospy.Subscriber('/vicon/vamp/Body', TransformStamped, vicon_callback)

    if p.do_capture_sensors:

        print('I: Running gyro calibration...')
        wrl.send(p.dest_addr, 0, p.cmd_calibrate_gyro)
        time.sleep(2)

        print('I: Erasing memory contents...')
        wrl.send(p.dest_addr, 0, p.cmd_erase_memory, st.pack('<H', s.samples))
        time.sleep(p.t * 2)

        print('I: Setting desired motor duty cycle...')
        wrl.send(p.dest_addr, 0, p.cmd_set_motor_speed, \
                                            st.pack('<f', p.motor_duty_cycle))

        raw_input('\nQ: To start the run, please [PRESS ENTER]')
        time.sleep(2)
        do_save_vicon_stream = True
        print('I: Requesting a sensor dump into memory...')
        wrl.send(p.dest_addr, 0, p.cmd_record_sensor_dump, \
            st.pack('<3H', s.samples, s.sample_motor_on, s.sample_motor_off))
        time.sleep(p.t + 1)

    # TODO (fgb) : Why not get an ACK that triggers this?
    raw_input('\nQ: To request a memory dump, please [PRESS ENTER]')
    do_save_vicon_stream = False
    print('I: Requesting memory contents...')
    wrl.send(p.dest_addr, 0, p.cmd_read_memory, st.pack('<2H', s.samples, 44))
    raw_input('\nQ: When data has been received, please [PRESS ENTER]')
    print('I: Received ' + str(d.sample_cnt) + ' samples (' + \
                                            str(d.packet_cnt) + ' packets)')

    # Shelve session information
    datafile_shelf = datafile + '_session.shelf'
    shelf       = shelve.open(datafile_shelf)
    not_shelved = []
    for key in dir():
        try:
            dump = pickle.dumps(locals()[key])
            shelf[key] = locals()[key]
        except:
            not_shelved += [key]
    if not_shelved != '':
        print('W: Did not shelve: ' + ', '.join(not_shelved))
    shelf['p'] = globals()['p']
    shelf['s'] = globals()['s']
    shelf['d'] = globals()['d']
    shelf.close()

    latest_symlink = root + 'latest_session.shelf'
    if os.path.lexists(latest_symlink):
        os.remove(latest_symlink)
    os.symlink(datafile_shelf, latest_symlink)

    print('I: Saved session to ' + os.path.basename(datafile_shelf) + \
                    ' (symlink at ' + os.path.basename(latest_symlink) + ')')


def received(packet):

    global p, s, d

    pld        = payload.Payload(packet.get('rf_data'))
    pkt_status = pld.status
    pkt_type   = pld.type
    pkt_data   = pld.data

    if ( pkt_type == p.cmd_read_memory ):

        # TODO (fgb) : Ensure packets received are contiguously saved!!!
        cnt = d.sample_cnt

        if cnt < s.samples:

            if pkt_status != (d.packet_cnt % 256):
                print('W: Received packet status (' + str(pkt_status) + \
                ') does not match expectations (' + str(d.packet_cnt%256) + ')')

            pkt_index = pkt_status % 4

            if pkt_index == 0:

                d.id[cnt]        = st.unpack('<H',   pkt_data[:2]   )
                d.bemf_ts[cnt]   = st.unpack('<L',   pkt_data[2:6]  )
                d.bemf[cnt]      = st.unpack('<H',   pkt_data[6:8]  )
                d.gyro_ts[cnt]   = st.unpack('<L',   pkt_data[8:12] )
                d.gyro[cnt]      = st.unpack('<3h',  pkt_data[12:18])
                d.row_ts[cnt]    = st.unpack('<L',   pkt_data[18:22])
                d.row_num[cnt]   = st.unpack('<B',   pkt_data[22:23])
                d.row_valid[cnt] = st.unpack('<B',   pkt_data[23:24])
                d.row[cnt,:20]   = st.unpack('<20B', pkt_data[24:]  )

                if cnt != d.id[cnt]:
                    print( str(cnt) + ' - ' + str(d.id[cnt]) )
                    #print('W: Received sample id (' + str(d.id[cnt][0]) + \
                    #        ') does not match sample count (' + str(cnt) + ')')

            elif pkt_index == 1:

                d.row[cnt,20:64] = st.unpack('<44B', pkt_data)

            elif pkt_index == 2:

                d.row[cnt,64:108]= st.unpack('<44B', pkt_data)

            else:

                d.row[cnt,108:]  = st.unpack('<44B', pkt_data)
                d.sample_cnt    += 1
                if d.sample_cnt == s.samples:
                    print('I: All packets were received.')

        else:
            print('W: Extra packet received! Appending to data dump.')
            d.dump.append([pkt_status, pkt_type, pkt_data])
            print([pkt_status, pkt_type, pkt_data])

        d.packet_cnt += 1

    elif ( pkt_type == p.cmd_get_settings ):
        s.sampling_period  = st.unpack('<H', pkt_data[:2])[0]
        s.mem_page_start   = st.unpack('<H', pkt_data[2:4])[0]
        s.motor_duty_cycle = st.unpack('<f', pkt_data[4:])[0]
    elif ( pkt_type == p.cmd_calibrate_gyro ):
        d.gyro_calib = st.unpack('<3f', pkt_data)
    else:
        print('E: Invalid packet received! Appending to data dump.')
        d.dump.append([pkt_status, pkt_type, pkt_data])
        print([pkt_status, pkt_type, pkt_data])


def vicon_callback(packet_v):

    global s, d, do_save_vicon_stream

    cnt_v = d.vicon_sample_cnt

    if p.do_stream_vicon and do_save_vicon_stream and (cnt_v < s.vicon_samples):

        d.vicon_ts[cnt_v]   = [packet_v.header.stamp.secs, \
                               packet_v.header.stamp.nsecs]
        d.vicon_pos[cnt_v]  = [packet_v.transform.translation.x, \
                               packet_v.transform.translation.y, \
                               packet_v.transform.translation.z]
        d.vicon_qorn[cnt_v] = [packet_v.transform.rotation.w, \
                               packet_v.transform.rotation.x, \
                               packet_v.transform.rotation.y, \
                               packet_v.transform.rotation.z, ]
        d.vicon_sample_cnt += 1


if __name__ == '__main__':
    try:
        main()
        sys.exit(0)
    except SystemExit as e:
        print('\nI: SystemExit: ' + str(e))
    except KeyboardInterrupt:
        print('\nI: KeyboardInterrupt')
    # TODO (fgb) : If we're just passing on this, is it necessary at all?
    #except rospy.ROSInterruptException:
    #    pass
    except Exception as e:
        print('\nE: Unexpected exception!\n' + str(e))
        traceback.print_exc()
