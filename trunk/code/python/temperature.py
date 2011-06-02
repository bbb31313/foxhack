import wmi

TEMPATTR = 194 # the number of the temperature attribute

c = wmi.WMI(namespace='root/wmi')

for drive in c.MSStorageDriver_ATAPISmartData():
    # strip out parts of the name to make it more readable.
    driveName = drive.InstanceName.split('_')[1] 
    
    # The first byte of the array is the number of 12-byte 'blocks' it contains.
    blockNum = drive.VendorSpecific[0]
    
    # Split the rest of the array into blocks.
    vs = drive.VendorSpecific[1:]
    blocks = [vs[i*12:i*12+12] for i in xrange(blockNum)]
    
    # Find the temperature block for each drive and print the value.
    print driveName + ':',
    for block in blocks:
        if block[1] == TEMPATTR:
            print str(block[6])  + 'C' 
            break

for cpu in c.MSAcpi_ThermalZoneTemperature():
    print "cputemper :"+str((cpu.CurrentTemperature-2732)/10.0)
    