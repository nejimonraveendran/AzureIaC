param nsgName string
param loc string
param tags object

resource nsg 'Microsoft.Network/networkSecurityGroups@2021-08-01' = {
  name: nsgName
  location: loc
  tags: tags
  properties: {
    securityRules:[
      {
        name: 'AllowRDP'
        type: 'RDP'
        properties:{
          priority: 101
          access: 'Allow'
          direction: 'Inbound'
          protocol:'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }

      {
        name: 'AllowPort80'
        type: 'RDP'
        properties:{
          priority: 110
          access: 'Allow'
          direction: 'Inbound'
          protocol:'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '80'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }


    ]
  }
}

output nsgId string = nsg.id
