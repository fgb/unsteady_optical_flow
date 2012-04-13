#
# Interface ImageProc for Height Regulation
#
# Created on 2009-2-9 by fgb, amh
#

import serial, sys, time, numpy as np #, matplotlib.pyplot as plt
from PIL import Image

# TODO: Need to save used configuration in a dictionary which I can then export to a config
# file for documenting the dataset instead of including some parameters in the filename.

#*** Functions ***#

def updateDutyCycle(dcval):
    ser.write(chr(0))       # command
    ser.write(chr(dcval))   # value
    reply = ord(ser.read()) # verification
    if reply == dcval:
        print '\nCorrectly changed duty cycle to ' + str(dcval) + '.'
    else:
        print '\nTried to change duty cycle to ' + str(dcval) + ' but device verification failed (reply was ' + str(ord(ser.read())) + ').'


#*** Program ***#

# Check and parse arguments
if len(sys.argv) < 5:
    print "Not enough arguments given. Need serial port, path/, duty cycle, and experiment name."
    sys.exit()

port = sys.argv[1] # serial port for the current bluetooth module
path = sys.argv[2] # path to the place where all experimental data resides ending in /.
dcval = int(sys.argv[3]) # duty cycle to run the motor at. 
name = sys.argv[4] # name of the experiment, also the prefix of the filename.

root = path + name + '_' + str(dcval)

# Open serial port
ser = serial.Serial('/dev/tty.' + port, 230400, timeout=15, rtscts=1)
ser.flushInput()
ser.flushOutput()

time.sleep(1)


#*** Duty Cycle update
updateDutyCycle(dcval)


#*** Lines request
print "\nRequesting a set of lines..."
ser.write(chr(4)) # height regulation command
ser.write(chr(1)) # velocity threshold to maintain

# Get lines data
r = 120
c = 160
f = 85
rows = Image.new("L",(c,f))
rowarray = rows.load()

for j in range(f):
    for i in range(c):
        rowarray[i,j] = ord(ser.read())

rows.save(root + ".png", "PNG")
rows.show()


#*** Stop motor
updateDutyCycle(0)


#*** Get bEMF measurements
l = 1024
bEMF = np.zeros((l))
errors = 0
flag = True
save = True
i = 0

while flag:
    # Read first byte
    while not ser.inWaiting():
        pass
    byte1 = ord(ser.read())

    if (byte1 & int('01100000',2)) != int('01100000',2):

        if (byte1 & int('10000000', 2) == int('10000000', 2)):
            highByte = (byte1 & int('00011111', 2)) << 5
        else:
            print "\nI have received a low byte out of order at frame " + str(i) + " row " + str(j)
            errors = errors + 1
            save = False
        
        # Read second byte
        while not ser.inWaiting():
            pass
        byte2 = ord(ser.read())
        
        if (byte2 & int('10000000', 2)) == int('00000000', 2):
            lowByte = (byte2 & int('00011111', 2))
            # Save, keeping track of position
            if save:
                i = i + 1
                if i >= l:
                    break
                bEMF[i] = highByte + lowByte
        else:
            print "Received out-of-order high byte as expected."
            recoveryByte = ord(ser.read())
            if (recoveryByte & int('10000000', 2)) == int('0000000', 2):
                print "Recovering..."
                save = True
            else:
                print "This process will probably not recover."
                flag = False
                break
    else:
        flag = False
        break

print "\n" + str(errors) + " errors in " + str(i) + " bEMF values."

# Save bEMF data
np.savetxt(root + '_bEMFdata.txt', bEMF)


#*** Get sync signal between bEMF measurements and lines
p = 4
sync = np.zeros((f,p))

for j in range(f):
    for i in range(p):
        highByte = ord(ser.read()) << 8
        lowByte = ord(ser.read())
        sync[j,i] = highByte + lowByte

# Save sync signal
np.savetxt(root + '_sync.txt', sync)
