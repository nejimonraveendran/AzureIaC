param publicIpName string
param loc string
param tags object

resource publicIp 'Microsoft.Network/publicIPAddresses@2021-08-01' = {
  name: publicIpName
  location: loc
  tags: tags

  properties: {
    deleteOption: 'Delete'
    publicIPAllocationMethod: 'Static'
    publicIPAddressVersion: 'IPv4'
  }  
 
  sku: {
    name: 'Standard'
  }

  zones: [
    '1'
  ]
}

output publicIpId string = publicIp.id
