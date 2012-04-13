#
# ImageProc commander to request lines
# data and PWM duty cycle changes
#
# Created: 2009-2-9
# Author: fgb, amh
#

import serial, sys, time, numpy as np, matplotlib.pyplot as plt
from PIL import Image

# Functions
def updateDutyCycle(dcval):
    ser.write(chr(0))  # duty cycle command
    ser.write(chr(dcval)) # duty cycle
    reply = ord(ser.read()) # receive verification
    if reply == dcval:
        print '\nCorrectly changed duty cycle to ' + str(dcval) + '.'
    else:
        print '\nTried to change duty cycle to ' + str(dcval) + ' but device verification failed (reply was ' + str(ord(ser.read())) + ').'


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
ser.write(chr(3)) # lines command
ser.write(chr(1)) # n second delay

# Get lines data
r = 120
c = 160
f = 30
rows = Image.new("L",(c,f))
cols = Image.new("L",(f,r))
rowarray = rows.load()
colarray = cols.load()

for j in range(f):
    for i in range(c):
        rowarray[i,j] = ord(ser.read())

for j in range(f):
    for i in range(r):
        colarray[j,i] = ord(ser.read())

rows.save(root + "_rows.png", "PNG")
rows.show()

cols.save(root + "_cols.png", "PNG")
cols.show()


#*** Stop motor
updateDutyCycle(0)


#*** Get bEMF measurements
r=60
bEMF = np.zeros((f,r),np.double)
errors = 0
flag = True
save = True
i,j = 0,0
#for i in range(f):
#    for j in range(r):
#        bEMF[i,j] = (ord(ser.read()) & int('00011111', 2))
#        bEMF[i,j] = bEMF[i,j] + (ord(ser.read()) & int('00011111', 2)) << 5

while not ser.inWaiting():
    pass

while flag:
    byte1 = ord(ser.read())
    if (byte1 & int('01100000',2)) != int('01100000',2):

        if (byte1 & int('10000000', 2) == int('10000000', 2)):
            highByte = (byte1 & int('00011111', 2)) << 5
        else:
            print "\nI have received a low byte out of order at frame " + str(i) + " row " + str(j)
            errors = errors + 1
            save = False
        
        while not ser.inWaiting():
            pass

        byte2 = ord(ser.read())
        if (byte2 & int('10000000', 2)) == int('00000000', 2):
            lowByte = (byte2 & int('00011111', 2))
            if save:
                j = j + 1
                if j >= r:
                    i = i + 1
                    if i >= f:
                        break
                    j = 0
                bEMF[i,j] = highByte + lowByte
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

print "\n" + str(errors) + " errors in " + str(i) + " frames (last with " + str(j) + " rows)."

# Save bEMF data
np.savetxt(root + '_bEMFdata.txt', bEMF)


## Plot bEMF data
#t = 0.0
#tfs = 0.0
#dtf = 0.0398848 # 1/fps
#dt1meas = 0.0007616 # delay till first row has been captured and we get first meas
#trs = 0.0
#dtr = 0.0001216 # delay until next row has been captured
#
#plt.figure(1)
#plt.clf()
#
#bEMFtime = []
#for i in range(f):
#    #plt.vlines(tfs,-30,30, color='0.4', linewidth=2)
#    t = tfs + dt1meas
#    for j in range(r):
#        bEMFtime.append([t,(1023-bEMF[i,j])/1023])
#        t = t + dtr
#    tfs = tfs + dtf
#bEMFtime = np.array(bEMFtime)
#
#plt.plot(bEMFtime[:,0], bEMFtime[:,1], '.', color='0.8')
#plt.xlabel('time [s]')
#plt.ylabel('bEMF [\% of max V]')
#
#plt.show()
