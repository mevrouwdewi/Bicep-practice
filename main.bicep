// Dit is de IaC-orchestrator

targetScope = 'subscription'

@description('Vul de unieke naam in voor de Resource Group (bijv. "virtualmachines")')
param RGname string

@description('De locatie voor alle resources')
param location string = 'westeurope'

@secure()
param adminPassword string

resource newRG 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: 'rg-${RGname}-demo'
  location: location
}

module infrastructure './rg-virtualmachines-demo-v3.bicep' = {
  name: 'infraDeployment'
  scope: newRG
  params: {
    location: location
    adminPassword: adminPassword
    virtualMachineName: 'vm-${RGname}' 
  }
}
