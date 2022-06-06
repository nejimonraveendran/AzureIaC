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
//define location with a default value (can be overridden by parameters)
var loc  = 'canadacentral'
var rgName = 'rg-myrealmbookapp' 
var appName = 'myrealmbookapp'

var tags = {
  appName: appName
}


//Create a resource group for all the applications in the deployment
resource bookAppResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: loc
  tags: tags
}


//Create a network security group.  Since the scope is below is set as "scope:bookAppResourceGroup", this gets created within the particular resource group
//by default, the resources are not allowed to be created under the subscription scope.  To be able to do that, your resource creation code should be designed as modules.
module bookAppAsp 'aspModule.bicep' = {
  scope: bookAppResourceGroup
  name: 'aspmyrealmbookapp'
  params: {
    loc: loc
    tags: tags
    aspName: 'asp-${appName}'
    sku: 'P2V3'
    instanceCount: 1
    elasticScaleEnabled: true
    isZoneRedundant: false
    maxElasticWorkerCount: 2
  }
}

module bookAppWebApp 'webappModule.bicep' = {
  scope: bookAppResourceGroup
  name: appName
  params: {
    aspId: bookAppAsp.outputs.aspId
    loc: loc
    tags: tags
    webAppName: appName 
  }
}

