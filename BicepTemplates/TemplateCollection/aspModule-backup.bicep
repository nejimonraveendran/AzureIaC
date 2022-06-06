//module to create app service plan

param aspName string
param loc string
param tags object

//tiers: D1, F1, B1, B2, B3, S1, S2, S3, P1, P2, P3, P1V2, P2V2, P3V2, I1, I2, I3, Y1, EP1, EP2, EP3
param tier string = 'PremiumV2'

//SKUs B1, B2, B3, D1, F1, FREE, I1, I2, I3, P1V2, P1V3, P2V2, P2V3, P3V2, P3V3, PC2, PC3, PC4, S1, S2, S3, SHARED
param skuSize string = 'P1v2'
param skuFamily string = 'Pv2'
param zoneRedundant bool = false

resource asp 'Microsoft.Web/serverfarms@2021-03-01' = {
  name: aspName
  location: loc
  tags: tags

  sku: {
    name: skuSize
    tier: tier
    size: skuSize
    family: skuFamily
    capacity: 1
  }

  kind: 'app'

  properties: {
    perSiteScaling: false
    elasticScaleEnabled: false
    maximumElasticWorkerCount: 1
    isSpot: false
    reserved: false
    isXenon: false
    hyperV: false
    targetWorkerCount: 0
    targetWorkerSizeId: 0
    zoneRedundant: zoneRedundant
  }
}

output aspId string = asp.id
