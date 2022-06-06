//prerequisites:
  //install azure CLI: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=azure-cli
  //install Windows terminal: https://docs.microsoft.com/en-us/windows/terminal/install
  //install bicep (from windows terminal): az bicep install. If already installed: az bicep upgrade
  //install MIcrosoft bicep extension in VS code: https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep  

//use the following command to deploy this template
//az deployment sub create --location canadacentral --template-file deployment-1.0.bicep --parameters loc=canadacentral env=dev
//or
//az deployment sub create --location canadacentral --template-file deployment-1.0.bicep --parameters parameters.json

//to delete the deployment:
//az deployment sub delete --name deployment-1.0

//set target scope.  Default is 'resourceGroup'
targetScope = 'subscription' 

//https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/parameters
//define parameters (to be supplied via command line or via parameters file)
@maxLength(5)
@allowed([
  'dev'
  'qa'
  'prod'
])
param env string

//define location with a default value (can be overridden by parameters)
param loc string = 'canadacentral'

//define top-level variables
var org = 'mr' 
var appName = 'ba'
var resourceMidName = '${org}-${appName}-${env}'

//define resource names
var bookAppResourceGroupName = 'rg-${resourceMidName}'
var bookAppNsgName = 'nsg-${resourceMidName}'
var bookAppVNetName = 'vnet-${resourceMidName}'
var bookAppWebServerPublicIpName = 'pip-${resourceMidName}-ws'
var bookAppWebServerNicName = 'nic-${resourceMidName}-ws'
var bookAppWebServerVmName = 'vm-${resourceMidName}-ws'
var bookAppDbVmName = 'vm-${resourceMidName}-db'
var bookAppTags = {
  appName: appName
  env: env 
}

var subnetName = 'subnet-default'

//Create a resource group for all the applications in the deployment
resource bookAppResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: bookAppResourceGroupName
  location: loc
  tags: bookAppTags
}


//Create a network security group.  Since the scope is below is set as "scope:bookAppResourceGroup", this gets created within the particular resource group
//by default, the resources are not allowed to be created under the subscription scope.  To be able to do that, your resource creation code should be designed as modules.
module bookAppNsg 'nsgModule.bicep' = {
  scope: bookAppResourceGroup
  name: bookAppNsgName
  params: {
    loc: loc
    nsgName: bookAppNsgName 
    tags: bookAppTags
  }
}

//Create a VNet
module bookAppVNet 'vNetModule.bicep' = {
  name: bookAppVNetName
  scope: bookAppResourceGroup
  params: {
    loc: loc
    vNetName: bookAppVNetName
    subnetName: subnetName
    tags: bookAppTags
  }
}


//create a public ip (to expose the web server VM)
module bookAppWebServerPublicIp 'publicIpModule.bicep' = {
  scope: bookAppResourceGroup
  name: bookAppWebServerPublicIpName
  params: {
    loc: loc
    publicIpName: bookAppWebServerPublicIpName 
    tags: bookAppTags
  }
}

//create a network interface card attached to the subnet created above and expose through the public IP created above.
module bookAppWebServerNic 'nicModule.bicep' = {
  scope: bookAppResourceGroup
  name: bookAppWebServerNicName
  params: {
    loc: loc
    nicName: bookAppWebServerNicName 
    nsgId: bookAppNsg.outputs.nsgId
    publicIpId: bookAppWebServerPublicIp.outputs.publicIpId
    subnetId: bookAppVNet.outputs.subnetId
    tags: bookAppTags
  }
}


//create a windows vm
module bookAppWebServerVm 'vmModule.bicep' = {
  scope: bookAppResourceGroup
  name: bookAppWebServerVmName
  params: {
    vmName: bookAppWebServerVmName
    adminPassword: 'MyVm@09876543'
    adminUsername: 'nejimon'
    loc: loc
    nicId: bookAppWebServerNic.outputs.nicId
    tags: bookAppTags
  }
}


