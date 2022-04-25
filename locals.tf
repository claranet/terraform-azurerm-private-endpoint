locals {
  resource_type = format("%s/%s", split("/", var.resource_id)[6], split("/", var.resource_id)[7])

  resource_types_mapping = {
    "Microsoft.Appconfiguration/configurationStores" = {
      subresource      = "configurationStores"
      private_dns_zone = "privatelink.azconfig.io"
    },
    "Microsoft.Batch/batchAccounts" = {
      subresource      = "batchAccount"
      private_dns_zone = "privatelink.${var.location_cli}.batch.azure.com"
    },
    "Microsoft.Cache/Redis" = {
      subresource      = "redisCache"
      private_dns_zone = "privatelink.redis.cache.windows.net"
    },
    "Microsoft.Cache/redisEnterprise" = {
      subresource      = "redisEnterprise"
      private_dns_zone = "privatelink.redisenterprise.cache.azure.net"
    },
    "Microsoft.CognitiveServices/accounts" = {
      subresource      = "account"
      private_dns_zone = "privatelink.cognitiveservices.azure.com"
    },
    "Microsoft.ContainerRegistry/registries" = {
      subresource      = "registry"
      private_dns_zone = "privatelink.azurecr.io"
    },
    "Microsoft.ContainerService/managedClusters" = {
      subresource      = "management"
      private_dns_zone = "privatelink.${var.location_cli}.azmk8s.io"
    },
    "Microsoft.DataFactory/factories" = {
      subresource      = "dataFactory"
      private_dns_zone = "privatelink.datafactory.azure.net"
    },
    "Microsoft.DBforMariaDB/servers" = {
      subresource      = "mariadbServer"
      private_dns_zone = "privatelink.mariadb.database.azure.com"
    },
    "Microsoft.DBforMySQL/servers" = {
      subresource      = "mysqlServer"
      private_dns_zone = "privatelink.mysql.database.azure.com"
    },
    "Microsoft.DBforPostgreSQL/servers" = {
      subresource      = "postgresqlServer"
      private_dns_zone = "privatelink.postgres.database.azure.com"
    },
    "Microsoft.Devices/IotHubs" = {
      subresource      = "iotHub"
      private_dns_zone = "privatelink.azure-devices.net"
    },
    "Microsoft.DigitalTwins/digitalTwinsInstances" = {
      subresource      = "digitalTwinsInstances"
      private_dns_zone = "privatelink.digitaltwins.azure.net"
    },
    "Microsoft.EventGrid/domains" = {
      subresource      = "domain"
      private_dns_zone = "privatelink.eventgrid.azure.net"
    },
    "Microsoft.EventGrid/topics" = {
      subresource      = "topic"
      private_dns_zone = "privatelink.eventgrid.azure.net"
    },
    "Microsoft.EventHub/namespaces" = {
      subresource      = "namespace"
      private_dns_zone = "privatelink.servicebus.windows.net"
    },
    "Microsoft.HDInsight/clusters" = {
      subresource      = "cluster"
      private_dns_zone = "privatelink.azurehdinsight.net"
    },
    "Microsoft.KeyVault/managedHSMs" = {
      subresource      = "HSM"
      private_dns_zone = "privatelink.managedhsm.azure.net"
    },
    "Microsoft.KeyVault/vaults" = {
      subresource      = "vault"
      private_dns_zone = "privatelink.vaultcore.azure.net"
    },
    "Microsoft.MachineLearningServices/workspaces" = {
      subresource      = "amlworkspace"
      private_dns_zone = "privatelink.api.azureml.ms"
    },
    "Microsoft.Search/searchServices" = {
      subresource      = "searchService"
      private_dns_zone = "privatelink.search.windows.net"
    },
    "Microsoft.ServiceBus/namespaces" = {
      subresource      = "namespace"
      private_dns_zone = "privatelink.servicebus.windows.net"
    },
    "Microsoft.SignalRService/SignalR" = {
      subresource      = "signalR"
      private_dns_zone = "privatelink.service.signalr.net"
    },
    "Microsoft.Sql/servers" = {
      subresource      = "sqlServer"
      private_dns_zone = "privatelink.database.windows.net"
    },
    "Microsoft.Web/sites" = {
      subresource      = "sites"
      private_dns_zone = "privatelink.azurewebsites.net"
    },
  }

  subresources_mapping = {
    # CosmosDB subresources
    Sql       = "privatelink.documents.azure.com"
    SQL       = "privatelink.documents.azure.com"
    MongoDB   = "privatelink.mongo.cosmos.azure.com"
    Cassandra = "privatelink.cassandra.cosmos.azure.com"
    Gremlin   = "privatelink.gremlin.cosmos.azure.com"
    Table     = "privatelink.table.cosmos.azure.com"

    # Storage Account subresources
    Blob  = "privatelink.blob.core.windows.net"
    Table = "privatelink.table.core.windows.net"
    Queue = "privatelink.queue.core.windows.net"
    File  = "privatelink.file.core.windows.net"
    Web   = "privatelink.web.core.windows.net"
  }
}
