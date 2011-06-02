# -*- coding: utf-8 -*-
# Windows WMI SQL (WQL)
# Network information
#
# http://msdn.microsoft.com/en-us/library/aa394084(VS.85).aspx
# http://python.net/crew/mhammond/win32/
#
# raspi 2008

import sys

try:
  import win32com.client
except ImportError:
  sys.exit("you can has epic fail")

wmi = win32com.client.GetObject("winmgmts:")

def getNetworkAdapters():
  adapters = []

  try:
    # http://msdn.microsoft.com/en-us/library/aa394216(VS.85).aspx
    wql = wmi.ExecQuery("SELECT * FROM Win32_NetworkAdapter WHERE (AdapterTypeID=0 OR AdapterTypeID=9) AND NetConnectionID IS NOT NULL AND Manufacturer <> 'Microsoft'")

    for i in wql:
      id = int(i.Properties_["Index"].Value)

      # Get more adapter information
      # http://msdn.microsoft.com/en-us/library/aa394217(VS.85).aspx
      wql2 = wmi.ExecQuery("SELECT * FROM Win32_NetworkAdapterConfiguration WHERE Index='%d'" % id)

      ip = []
      dns = []

      for j in wql2:
        # Adapter uses DHCP?
        dhcp = j.Properties_["DHCPEnabled"].Value

        # Get DNS servers
        if j.Properties_["DNSServerSearchOrder"].Value != None:
          for q in j.Properties_["DNSServerSearchOrder"].Value:
            dns.append(q.encode(sys.getfilesystemencoding()))
        
        # Get IP + Netmask + Gateway
        if (j.Properties_["IPAddress"].Value != None) and (j.Properties_["IPSubnet"].Value != None):
          ipcount = len(j.Properties_["IPAddress"].Value)
          
          for idx in range(ipcount):
            try:
              gw = j.Properties_["DefaultIPGateway"].Value[idx].encode(sys.getfilesystemencoding())
            except:
              gw = "-"
              
            ipaddr = j.Properties_["IPAddress"].Value[idx].encode(sys.getfilesystemencoding())
            mask = j.Properties_["IPSubnet"].Value[idx].encode(sys.getfilesystemencoding())
            ip.append({"IP": ipaddr, "Mask": mask, "Gateway": gw})
      
      # Get rest  

      name = i.Properties_["Name"].Value.encode(sys.getfilesystemencoding())  

      try:
        connid = i.Properties_["NetConnectionID"].Value.encode(sys.getfilesystemencoding())
      except:
        connid = "?"

      try:
        cstatus = int(i.Properties_["NetConnectionStatus"].Value)
        avail = int(i.Properties_["Availability"].Value)
      except:
        cstatus = 0
        avail = 0
      
      try:
        mac = i.Properties_["MACAddress"].Value.encode(sys.getfilesystemencoding())
      except:
        mac = ""
      
      status = [cstatus, avail]

      adapters.append({"IFName": connid, "Name": name, "Status": status, "IP": ip, "DNS": dns, "MAC": mac, "DHCP": dhcp})
  except:
    print "Unexpected error:", sys.exc_info()[0]
    return
    
  return adapters


availability = ['-', 'Other', 'Unknown', 'Running or Full Power', 'Warning', 'In Test', 'Not Applicable', 'Power Off', 'Off Line', 'Off Duty', 'Degraded', 'Not Installed', 'Install Error', 'Power Save - Unknown', 'Power Save - Low Power Mode', 'Power Save - Standby', 'Power Cycle', 'Power Save - Warning']
connstatus = ['Disconnected', 'Connecting', 'Connected', 'Disconnecting', 'Hardware not present', 'Hardware disabled', 'Hardware malfunction', 'Media disconnected', 'Authenticating', 'Authentication succeeded', 'Authentication failed', 'Invalid address', 'Credentials required']

adapters = getNetworkAdapters()
#print adapters
print "Network adapters:"

for i in adapters:
  if i['IFName'] != "?":
    print "%s (%s):" % (i['IFName'], i['Name'])
    print "  Status: %s (%s)" % (connstatus[i['Status'][0]], availability[i['Status'][1]]) 

    ipstr = ""
    for ip in i['IP']:
      ipstr = "%s/%s (GW: %s) " % (ip['IP'], ip['Mask'], ip['Gateway'])
    print "  IP(s) with mask: " + ipstr
  
    print "  DNS: " + ", ".join(i['DNS'])
    print "  MAC: " + i['MAC']
    print "  Use DHCP: " + (i['DHCP'] and "Yes" or "No")
  
    print ""