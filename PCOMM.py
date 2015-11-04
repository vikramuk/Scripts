import time
import sys
import time
import usb.core
import serial
import visa
#from HTMLReport import HTMLTestRunner

AGILENT_33220A= "USB0::0x0957::0x0407::MY44021621::0::INSTR" # - for 33220A
AGILENT_33522A= "USB0::0x0957::0x2307::MY50003961::0::INSTR" # - for 33522A


def setUpCOMPort():
    ser = serial.Serial(4,115200, parity='N',bytesize=8, stopbits=1, timeout=None, xonxoff=False,rtscts=False, dsrdtr=False)  
    print ser.name      # check which port was really used
    ser.write("US 1 1 110\n")      
    time.sleep(5)
    ser.write("US 2 1 66\n")
    ser.close()           
    print("Disconnecting")


def test_List_Vendor():        
    dev = usb.core.find(find_all=True)
    # loop through devices, printing vendor and product ids in decimal and hex
    for cfg in dev:
        sys.stdout.write('Decimal VendorID=' + str(cfg.idVendor) +' & ProductID=' + str(cfg.idProduct) + '\n')
        sys.stdout.write('Hexadecimal: VendorID=' + hex(cfg.idVendor) + ' & ProductID=' + hex(cfg.idProduct) + '\n\n')

def test_Values_USB():
    # Check for Device Availability
    try:
        rm = visa.ResourceManager()
        rm.list_resources()
        inst_33220A = rm.open_resource(AGILENT_33220A, read_termination="\r")
        inst_33220A.timeout = 25        
        print ("Checking Device Number: ")
        print(inst_33220A.query("*IDN?", delay=1))        
        print ("Checking Frequency Value")
        print(inst_33220A.query(":SOUR:FREQ?"))    
        print ("Checking Phase Value")    
        print(inst_33220A.query(":SOUR:BURS:PHAS?", delay=1))        
        print ("Checking Burst Value")    
        print(inst_33220A.write(":SOUR:BURS:NCYC?"))
        print(inst_33220A.read_raw())        
        print("Getting Values for Frequency")
        # print(inst_33220A.write_ascii_values(":SOUR1:FREQ:CW 1.1512 MHZ",termination=None, encoding=None))
        time.sleep(1)
        freqy = float((inst_33220A.query(":SOUR1:FREQ?")))      
        print "Frequency is Set to:    ", freqy
        sample_amp = float(inst_33220A.query(':SOUR:VOLT:LEV:IMM:AMPL?'))
        print "Sample Rate:    ", sample_amp
        bursttime = float(inst_33220A.query(":SOUR:BURS:NCYC?"))
        print "Burst Cycle:    ", bursttime
    #Fail Gracefully
    except IOError:
        print 'cannot Connect to Device: '+ AGILENT_33220A
    except Exception as e:
        print 'cannot Find the Device: '+ AGILENT_33220A
    else:
        print "Connection has been Closed"

def set_Values_USB():
    # Check for Device Availability
    try:
        rm = visa.ResourceManager()
        rm.list_resources()
        inst_33220A = rm.open_resource(AGILENT_33220A, read_termination="\r")
        inst_33220A.timeout = 25        
        print ("Checking Device Number")
        print(inst_33220A.query("*IDN?", delay=1))        
        print("Setting Frequency")
        print(inst_33220A.write(":SOUR1:FREQ:CW 1.1512 MHZ"))        
        print("Setting Amplitude")
        print(inst_33220A.write(":SOUR1:VOLT:LEV:IMM:AMPL 0.1"))        
    #Fail Gracefully
    except IOError:
        print 'cannot Connect to Device: '+ AGILENT_33220A
    except Exception as e:
        print 'cannot Find to Device: '+ AGILENT_33220A
    else:
        print "Connection has been Closed"       


def main():
    #Send Commands on COM Port
    setUpCOMPort()
    #Check Device
    test_List_Vendor()
    #Get Initial Values
    test_Values_USB() 
    #Set Values
    set_Values_USB()
    #Re-read the set values 
    test_Values_USB()

if __name__ == '__main__':
    main()
