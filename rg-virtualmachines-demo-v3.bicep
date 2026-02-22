@description('Locatie van de RG wordt overgenomen.')
param location string = resourceGroup().location

@description('De naam van de VM')
param virtualMachineName string = 'vm-windowsserver-demo'

@description('De naam van de VNET')
param vNetName string = 'vnet-westeurope'

@description('De naam van de subnet')
param subnetName string = 'Default'

@description('De naam van de tweede subnet')
param subnetName2 string = 'Subnet2'

@description('Adresprefix van de tweede subnet')
param subnetAddressPrefix2 string = '172.16.1.0/24'

@description('De admin gebruikersnaam voor de VM')
param adminUsername string = 'Dewi'

@description('Het wachtwoord voor de admin gebruiker van de VM')
@secure()
param adminPassword string
@description('NSG groep voor de VM')

resource nsg 'Microsoft.Network/networkSecurityGroups@2020-11-01' = {
  name: '${virtualMachineName}-nsg'
  location: location
  properties: {
    securityRules: [
      {
        name: 'AllowRDP'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 1000
          direction: 'Inbound'
        }
      }
    ]
  }
}

@description('VNet met subnet')
resource vnet 'Microsoft.Network/virtualNetworks@2025-05-01' = {
  name: vNetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '172.16.0.0/16']
      }
      subnets: [
        {
          name: subnetName
          properties: {
            addressPrefix: '172.16.0.0/24'
            networkSecurityGroup: {
              id: nsg.id
            }
            }
        }
        {
          name: subnetName2
          properties: {
            addressPrefix: subnetAddressPrefix2
          }
        }
        ]
    }
}

@description('Publiek IP adres voor de VM')
resource publicIP 'Microsoft.Network/publicIPAddresses@2025-05-01' = {
  name: '${virtualMachineName}-publicip'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

@description('Netwerk interface voor de VM')
resource networkInterface 'Microsoft.Network/networkInterfaces@2025-05-01' = {
  name: '${virtualMachineName}-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: '${virtualMachineName}-ipconfig'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: vnet.properties.subnets[0].id
          }
          publicIPAddress: {
            id: publicIP.id
          }
        }
      }
    ]
  }
}

@description('De Virtual Machine configuratie')
resource vm 'Microsoft.Compute/virtualMachines@2024-11-01' = {
  name: virtualMachineName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B2s_v2'
    }
    osProfile: {
      computerName: take(virtualMachineName, 15)
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2025-datacenter-azure-edition'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterface.id
        }
      ]
    }
    securityProfile: {
      securityType: 'TrustedLaunch'
      uefiSettings: {
        secureBootEnabled: true
        vTpmEnabled: true
      }
    }
  }
}

@description('Automatisch afsluiten om 19:00 om kosten te besparen')
resource shutdownSchedule 'microsoft.devtestlab/schedules@2018-09-15' = {
  name: 'shutdown-computevm-${virtualMachineName}'
  location: location
  properties: {
    status: 'Enabled'
    taskType: 'ComputeVmShutdownTask'
    dailyRecurrence: {
      time: '1900'
    }
    timeZoneId: 'W. Europe Standard Time'
    targetResourceId: vm.id
    notificationSettings: {
      status: 'Enabled'
      emailRecipient: 'asmawidjaja.d@hsleiden.nl' 
    }
  }
}
