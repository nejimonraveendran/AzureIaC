param vmExtensionName string
param tags object
param loc string

resource vmExtension 'Microsoft.Compute/virtualMachines/extensions@2021-11-01' = {
  name: vmExtensionName
  tags: tags
  location: loc

  properties: {
    publisher: 'Microsoft.Powershell'
    type: 'DSC'
    typeHandlerVersion: '2.19'
    autoUpgradeMinorVersion: true
    
  }

  c
}