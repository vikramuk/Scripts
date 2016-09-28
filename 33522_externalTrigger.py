#!/usr/bin/python

import sys
import time
import usb.core
import visa
import os 

AGILENT_33522A ="USB0::0x0957::0x2307::MY50003961::0::INSTR"
def Init():
    # Check for Device Availability
    try:
        rm = visa.ResourceManager()
        rm.list_resources()
        inst_33220A = rm.open_resource(AGILENT_33522A, read_termination="\r")
        inst_33220A.timeout = 125  
        print ("Resetting the Device")
        print(inst_33220A.write("*RST"))     
        print("Setting Frequency")
        print(inst_33220A.write(":SOUR:FREQ:CW 1.1512 MHZ"))        
        print("Setting Amplitude")
        time.sleep(0.05)
        print(inst_33220A.write(":SOUR:VOLT:LEV:IMM:AMPL 0.1 VPP"))        #:SOUR:VOLT:LEV:IMM:AMPL 0.1
        print ("Setting Cycle Phase")
        time.sleep(0.05)
        print (inst_33220A.write(":SOUR:BURS:PHAS 0 "))
        print ("Enable Burst State")
        time.sleep(0.05)
        print(inst_33220A.write(":SOUR:BURS:STAT 1"))  
        print ("Setting Burst Cycles")
        time.sleep(0.05)        
        print (inst_33220A.write(":SOUR:BURS:NCYC 50000"))
        time.sleep(0.05)
        print(inst_33220A.write(":SOUR:BURS:MODE TRIG"))          
        time.sleep(0.05)
        print(inst_33220A.write(":TRIG:SEQ:SOUR EXT"))          
        time.sleep(0.05)
        print(inst_33220A.write(":SOUR:BURS:STAT 1"))          
        time.sleep(0.05)
        print(inst_33220A.write(":TRIG:SEQ:SOUR BUS"))          
        time.sleep(0.05) 
    #Fail Gracefully
    except IOError:
        print 'cannot Connect to Device: '+ AGILENT_33522A
    except Exception as e:
        print 'cannot Find the Device: '+ AGILENT_33522A
    else:
        print "Connection has been Closed"

        
def set_Values_USB(period):
    # Check for Device Availability
    try:
        rm = visa.ResourceManager()
        rm.list_resources()
        inst_33220A = rm.open_resource(AGILENT_33522A, read_termination="\r")
        print (inst_33220A.write(":SOUR:BURS:INT:PER %f S" %float(period)))        
        print ("Enable the Output")
        time.sleep(0.05)        
    #Fail Gracefully
    except IOError:
        print 'cannot Connect to Device: '+ AGILENT_33522A
    except Exception as e:
        print e
    else:
        print "Connection has been Closed"       

def trigger():
    # Check for Device Availability
    try:
        rm = visa.ResourceManager()
        rm.list_resources()
        inst_33220A = rm.open_resource(AGILENT_33522A, read_termination="\r")
        print(inst_33220A.write("*TRG"))                
        time.sleep(0.05)        
    #Fail Gracefully
    except IOError:
        print 'cannot Connect to Device: '+ AGILENT_33522A
    except Exception as e:
        print e
    else:
        print "Connection has been Closed"

if __name__ == "__main__":
    list=[120,126]
    Init()
    set_Values_USB(60.0/120)
    for i in range(0,100,1):
        trigger()
        time.sleep(0.5)  #  triggering Now
        
    
