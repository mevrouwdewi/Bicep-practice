param virtualNetworks_vnet_westeurope_name string
param virtualMachines_vm_windowsserver_demo_name string
param publicIPAddresses_vm_windowsserver_demo_ip_name string
param networkInterfaces_vm_windowsserver_demo349_z1_name string
param networkSecurityGroups_vm_windowsserver_demo_nsg_name string
param schedules_shutdown_computevm_vm_windowsserver_demo_name string

resource networkSecurityGroups_vm_windowsserver_demo_nsg_name_resource 'Microsoft.Network/networkSecurityGroups@2024-07-01' = {
  name: networkSecurityGroups_vm_windowsserver_demo_nsg_name
  location: 'westeurope'
  properties: {
    securityRules: [
      {
        name: 'MicrosoftDefenderForCloud-JITRule_-2067478764_5E77E019CF124A01A903DB731487CE93'
        id: networkSecurityGroups_vm_windowsserver_demo_nsg_name_MicrosoftDefenderForCloud_JITRule_2067478764_5E77E019CF124A01A903DB731487CE93.id
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
        properties: {
          description: 'MDC JIT Network Access rule for policy \'default\' of VM \'vm-windowsserver-demo\'.'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '172.16.0.4'
          access: 'Deny'
          priority: 4096
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
    ]
  }
}

resource publicIPAddresses_vm_windowsserver_demo_ip_name_resource 'Microsoft.Network/publicIPAddresses@2024-07-01' = {
  name: publicIPAddresses_vm_windowsserver_demo_ip_name
  location: 'westeurope'
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  zones: [
    '1'
  ]
  properties: {
    ipAddress: '4.210.225.26'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
    ddosSettings: {
      protectionMode: 'VirtualNetworkInherited'
    }
  }
}

resource virtualNetworks_vnet_westeurope_name_resource 'Microsoft.Network/virtualNetworks@2024-07-01' = {
  name: virtualNetworks_vnet_westeurope_name
  location: 'westeurope'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '172.16.0.0/16'
      ]
    }
    privateEndpointVNetPolicies: 'Disabled'
    subnets: [
      {
        name: 'snet-westeurope-1'
        id: virtualNetworks_vnet_westeurope_name_snet_westeurope_1.id
        properties: {
          addressPrefixes: [
            '172.16.0.0/24'
          ]
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
    ]
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}

resource virtualMachines_vm_windowsserver_demo_name_resource 'Microsoft.Compute/virtualMachines@2024-11-01' = {
  name: virtualMachines_vm_windowsserver_demo_name
  location: 'westeurope'
  zones: [
    '1'
  ]
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '/subscriptions/2a273d47-b5fb-455f-b78c-2449efafd777/resourceGroups/rg-managedidentity-demo/providers/Microsoft.ManagedIdentity/userAssignedIdentities/managedidentity': {}
    }
  }
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B2s_v2'
    }
    additionalCapabilities: {
      hibernationEnabled: false
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2025-datacenter-azure-edition'
        version: 'latest'
      }
      osDisk: {
        osType: 'Windows'
        name: '${virtualMachines_vm_windowsserver_demo_name}_OsDisk_1_fbfc6a2b3a664de699c73e113c60a761'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          id: resourceId(
            'Microsoft.Compute/disks',
            '${virtualMachines_vm_windowsserver_demo_name}_OsDisk_1_fbfc6a2b3a664de699c73e113c60a761'
          )
        }
        deleteOption: 'Delete'
      }
      dataDisks: []
      diskControllerType: 'SCSI'
    }
    osProfile: {
      computerName: 'vm-windowsserve'
      adminUsername: 'dewi'
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: true
        patchSettings: {
          patchMode: 'AutomaticByPlatform'
          automaticByPlatformSettings: {
            rebootSetting: 'IfRequired'
          }
          assessmentMode: 'ImageDefault'
          enableHotpatching: true
        }
      }
      secrets: []
      allowExtensionOperations: true
      requireGuestProvisionSignal: true
    }
    securityProfile: {
      uefiSettings: {
        secureBootEnabled: true
        vTpmEnabled: true
      }
      securityType: 'TrustedLaunch'
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaces_vm_windowsserver_demo349_z1_name_resource.id
          properties: {
            deleteOption: 'Detach'
          }
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}

resource schedules_shutdown_computevm_vm_windowsserver_demo_name_resource 'microsoft.devtestlab/schedules@2018-09-15' = {
  name: schedules_shutdown_computevm_vm_windowsserver_demo_name
  location: 'westeurope'
  properties: {
    status: 'Enabled'
    taskType: 'ComputeVmShutdownTask'
    dailyRecurrence: {
      time: '1900'
    }
    timeZoneId: 'W. Europe Standard Time'
    notificationSettings: {
      status: 'Enabled'
      timeInMinutes: 30
      emailRecipient: 'asmawidjaja.d@hsleiden.nl'
      notificationLocale: 'en'
    }
    targetResourceId: virtualMachines_vm_windowsserver_demo_name_resource.id
  }
}

resource networkSecurityGroups_vm_windowsserver_demo_nsg_name_MicrosoftDefenderForCloud_JITRule_2067478764_5E77E019CF124A01A903DB731487CE93 'Microsoft.Network/networkSecurityGroups/securityRules@2024-07-01' = {
  name: '${networkSecurityGroups_vm_windowsserver_demo_nsg_name}/MicrosoftDefenderForCloud-JITRule_-2067478764_5E77E019CF124A01A903DB731487CE93'
  properties: {
    description: 'MDC JIT Network Access rule for policy \'default\' of VM \'vm-windowsserver-demo\'.'
    protocol: '*'
    sourcePortRange: '*'
    destinationPortRange: '3389'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '172.16.0.4'
    access: 'Deny'
    priority: 4096
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: []
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
  dependsOn: [
    networkSecurityGroups_vm_windowsserver_demo_nsg_name_resource
  ]
}

resource virtualNetworks_vnet_westeurope_name_snet_westeurope_1 'Microsoft.Network/virtualNetworks/subnets@2024-07-01' = {
  name: '${virtualNetworks_vnet_westeurope_name}/snet-westeurope-1'
  properties: {
    addressPrefixes: [
      '172.16.0.0/24'
    ]
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_vnet_westeurope_name_resource
  ]
}

resource networkInterfaces_vm_windowsserver_demo349_z1_name_resource 'Microsoft.Network/networkInterfaces@2024-07-01' = {
  name: networkInterfaces_vm_windowsserver_demo349_z1_name
  location: 'westeurope'
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        id: '${networkInterfaces_vm_windowsserver_demo349_z1_name_resource.id}/ipConfigurations/ipconfig1'
        type: 'Microsoft.Network/networkInterfaces/ipConfigurations'
        properties: {
          privateIPAddress: '172.16.0.4'
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddresses_vm_windowsserver_demo_ip_name_resource.id
            properties: {
              deleteOption: 'Detach'
            }
          }
          subnet: {
            id: virtualNetworks_vnet_westeurope_name_snet_westeurope_1.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: false
    enableIPForwarding: false
    disableTcpStateTracking: false
    networkSecurityGroup: {
      id: networkSecurityGroups_vm_windowsserver_demo_nsg_name_resource.id
    }
    nicType: 'Standard'
    auxiliaryMode: 'None'
    auxiliarySku: 'None'
  }
}
