param vmName string
param loc string
param tags object
param vmSize string = 'Standard_D2s_v3'
param osDiskType string = 'Premium_LRS'
param nicId string
param adminUsername string

@secure()
param adminPassword string

resource vm 'Microsoft.Compute/virtualMachines@2021-11-01' = {
  name: vmName
  location: loc
  tags: tags

  zones: [
    '1'
  ]

  properties:{
    hardwareProfile:{
      vmSize: vmSize
    }

    storageProfile:{
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: osDiskType
        }

        deleteOption: 'Delete'
      }

      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2016-datacenter-gensecond'
        version: 'latest'
      }
    }

    networkProfile: {
      networkInterfaces: [
        {
          id: nicId
          properties: {
            deleteOption: 'Delete'
          }
        }
      ]
    }

    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPassword
      windowsConfiguration: {
        enableAutomaticUpdates: true
        provisionVMAgent: true
        patchSettings: {
          enableHotpatching: false
          patchMode: 'AutomaticByOS'
        }
      }
    }

    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}

output vmId string = vm.id
