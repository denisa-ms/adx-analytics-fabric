param prefix string = 'a-${uniqueString(resourceGroup().id)}'
param serverName string = '${prefix}-dbserver'
param databaseName string = 'aworks'
param location string = 'westeurope'
param adminLogin string = 'SqlAdmin'
param adminPassword string = 'ChangeYourAdminPassword1'
param eventHubNamespaceName string = '${prefix}-ehub-ns'
param eventHubEvents string = 'events'
param ehubConsumerGroup1 string = 'kustoConsumerGroup1'

resource sqlServer 'Microsoft.Sql/servers@2021-02-01-preview' = {
  name: serverName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    administratorLogin: adminLogin
    administratorLoginPassword: adminPassword
  }
}

resource sqlServerFirewallRules 'Microsoft.Sql/servers/firewallRules@2020-11-01-preview' = {
  parent: sqlServer
  name: 'Allow Azure Services'
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '255.255.255.255'
  }
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2021-02-01-preview' = {
  name: databaseName
  parent: sqlServer
  location: location
  sku: {
    name: 'GP_S_Gen5'
    tier: 'GeneralPurpose'
    family: 'Gen5'
    capacity: 2
  }
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    sampleName: 'AdventureWorksLT'
  }
}



resource eventHubNamespace 'Microsoft.EventHub/namespaces@2021-11-01' = {
  name: eventHubNamespaceName
  location: location
  sku: {
    capacity: 1
    name: 'Standard'
    tier: 'Standard'
  }
  properties: {}
}

resource eventHub1 'Microsoft.EventHub/namespaces/eventhubs@2021-11-01' = {
  name: eventHubEvents
  parent: eventHubNamespace
  properties: {
    messageRetentionInDays: 1
    partitionCount: 1
  }
}


resource kustoConsumerGroup1 'Microsoft.EventHub/namespaces/eventhubs/consumergroups@2021-11-01' = {
  name: ehubConsumerGroup1
  parent: eventHub1
  properties: {}
}
