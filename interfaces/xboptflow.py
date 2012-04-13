#!/usr/bin/env python
"""
authors: stanbaek
Modification on 2010-07-20:

"""

import sys, time, math, struct
import numpy as np, matplotlib.pyplot as plt, Image as im

from stanlib.basestation import BaseStation
from stanlib.payload import Payload


DEST_ADDR = '\x16\x00'
DEFAULT_SERIAL_PORT = '/dev/tty.usbserial-A700eYvL'
DEFAULT_BAUD_RATE = 57600

GYRO_LSB2DEG = 0.0695652174     # 14.375 LSB/(deg/s)
GYRO_LSB2RAD = 0.00121414209          
XL_DEFAULT_SCALE = 0.03832      # = 9.81/256

CMD_SET_MOTOR_SPEED     = 0
CMD_GET_PICTURE         = 1
CMD_GET_VIDEO           = 2
CMD_GET_LINES           = 3
CMD_RECORD_SENSOR_DUMP  = 4
CMD_GET_MEM_CONTENTS    = 5

CMD_RUN_GYRO_CALIB       = 0x0d
CMD_GET_GYRO_CALIB_PARAM = 0x0e
CMD_ECHO                = 0x0f

statedata_file_name = 'statedata.txt'
dump_file_name = 'dumster.txt'
gyro_calib_file_name = 'gyrocalib.txt'

statedata = []
dumster = []
gyro_calib = []

images = []
image = []

data_received = 0
state_data_received = 0
null_data_received = 0


def xbee_received(packet):

    global gyro_calib
    global data_received
    global state_data_received
    global null_data_received
    global images
    global image

    data_received += 1

    pld = Payload(packet.get('rf_data'))
    #rssi = ord(packet.get('rssi'))
    #(src_addr, ) = struct.unpack('H', packet.get('source_addr'))
    #id = packet.get('id')
    #options = ord(packet.get('options'))

    status = pld.status
    type = pld.type
    data = pld.data

    if (type == CMD_RECORD_SENSOR_DUMP):
        datum = struct.unpack('L3h', data)
        print datum[0], datum[1], datum[2], datum[3]
    elif (type == CMD_GET_GYRO_CALIB_PARAM):
        gyro_calib = struct.unpack('3f', data)
        f = open(gyro_calib_file_name, 'w')
        f.write(','.join(str(data) for data in gyro_calib))
        f.close()
        print gyro_calib
    elif (type == CMD_GET_MEM_CONTENTS):
        if (status % 4) == 0:
            datum = struct.unpack('2L4h', data[:16])
            image = list(struct.unpack('28B', data[16:]))
        elif (status % 4) == 3:
            image.extend(list(struct.unpack('44B', data)))
            images.append(image)
        else:
            image.extend(list(struct.unpack('44B', data)))
    elif (type == CMD_ECHO):
        print status, type, data
    else: 
        print "invalid"
        dumster.append([status, type, data]) 
            

if __name__ == '__main__':

    if len(sys.argv) == 1:
        xb = BaseStation(DEFAULT_SERIAL_PORT, DEFAULT_BAUD_RATE, DEST_ADDR, xbee_received)
    elif len(sys.argv) == 3:
        port = sys.argv[1]
        baud = int(sys.argv[2])
        xb = BaseStation(port, baud, DEST_ADDR, xbee_received)
    else:
        print "Invalid number of arguments"
        sys.exit(0)

    print "Sending RUN_GYRO_CALIB"
    xb.send(0, CMD_RUN_GYRO_CALIB, struct.pack('H', 2000));
    time.sleep(3)
    xb.send(0, CMD_GET_GYRO_CALIB_PARAM, " ");
    time.sleep(1)

    print "Reading gyro data"  
    xb.send(0, CMD_RECORD_SENSOR_DUMP, struct.pack('H', 100))
    time.sleep(2.5)

    print "Reading saved data from DataFlash"  # start_page, end_page, data_block_size
    xb.send(0, CMD_GET_MEM_CONTENTS, struct.pack('3H', 0x100, 0x150, 44))
    time.sleep(0.5)

    print "TX is done"

    while True:
        try:
            time.sleep(1)
        except KeyboardInterrupt:
            break
    
    xb.close()

    print str(data_received) + " total data were received." 
    print str(state_data_received) + " state data were received from flash."
    print str(null_data_received) + " null data were received from flash."

    #state_array = np.array(statedata)
    #fmt = '%d,%f,%f,%f,%f,%f,%f, %d,%d,%d,%d,%d,%d, %d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d'
    #np.savetxt(statedata_file_name, state_array, fmt)

    imarr = np.array(images[0:100])
    img = im.fromarray(imarr)
    img.show()
    #img.save("test.bmp")

    print "Files Saved"
