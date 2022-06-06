param nicName string
param loc string
param tags object
param subnetId string
param publicIpId string
param nsgId string


resource nic 'Microsoft.Network/networkInterfaces@2021-02-01' = {
  name: nicName
  location: loc
  tags: tags
  
  properties: {
    ipConfigurations:[
      {
        name: 'ipconfig1'
        properties: {
          privateIPAddressVersion: 'IPv4'
          privateIPAllocationMethod: 'Dynamic'
          
          subnet: {
            id: subnetId
          }
          
          publicIPAddress: {
            id: publicIpId
          }
        }

      }
    ]

    enableAcceleratedNetworking: true
    networkSecurityGroup: {
      id: nsgId
    }

  }
}

output nicId string = nic.id
