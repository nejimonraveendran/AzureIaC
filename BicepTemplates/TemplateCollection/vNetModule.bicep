param vNetName string
param loc string
param tags object
param subnetName string

resource vNet 'Microsoft.Network/virtualNetworks@2021-08-01' = {
  name: vNetName
  location: loc
  tags: tags
  
  properties:{
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/24'
      ]
    }

    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
    ]

  }
}

output subnetId string  = vNet.properties.subnets[0].id
