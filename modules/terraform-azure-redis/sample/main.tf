############################# PRE REQUISITO ############################################################
#scope: El parametro scope corresponde al nombre de la aplicacion o proyecto
#env: Es el ambiente que se va crear prod, dev, qa, stage, test
#seq_number: Es el correlativo del ambiente que se va a crear. Ejemplo el ambiente 1 de desarrollo seria 001

#codproy: Es el codigo de proyecto con el cual se puede asociar la aplicacion y owner
#owner: Es el propietario de los recursos a aprovisionar.No necesariamente el owner es el mismo nombre que el scope
#criticidad: Es la criticidad de los componentes de la aplicacion para el ambiente a aprovisionar.


############################# Casos que soporta el modulo ##############################################

#Recursos dependientes para el aprovisionamiento de Redis

module "infr-env" {
  source   = "git::https://dev.azure.com/nttdata-devops/DevOps/_git/terraform-infr-env?ref=feature/nttdata-first-version"
  infr-env = { scope = "sampleredis", env = "dev" }
}

module "audit" {
  source = "git::https://dev.azure.com/nttdata-devops/DevOps/_git/terraform-audit-tags?ref=feature/modulo-base"
  audit  = { codproy = "1608 - Innovación", owner = "PROYECT NTTDATA", criticidad = "Alto" }
}

module "rsgr-01" {
  source     = "git::https://dev.azure.com/nttdata-devops/DevOps/_git/terraform-azure-rg?ref=feature/nttdata-first-version"
  location   = "eastus"
  infr-env   = module.infr-env.infr-env-var
  audit      = module.audit.audit-tags
  seq_number = "001"
}

module "vnet" {
  source              = "git::https://dev.azure.com/nttdata-devops/DevOps/_git/terraform-azure-vnet?ref=feature/nttdata-first-version"
  rsgr_name           = module.rsgr-01.rsgr_name
  location            = module.rsgr-01.location
  infr-env            = module.infr-env.infr-env-var
  audit               = module.audit.audit-tags
  vnet_address_space  = ["10.203.16.0/21"]
  # Node Pool User = "10.203.16.0/22", Node Pool System = "10.203.21.0/24", REDIS,ACR,DB="10.203.20.128/26", APIM="10.203.20.192/28", AGW="10.203.20.208/28"
  subnetmulti_address = ["10.203.16.0/22", "10.203.21.0/24", "10.203.20.128/26", "10.203.20.192/28", "10.203.20.208/28"]
  seq_number          = "001"
  depends_on          = [module.rsgr-01]
}

data "azurerm_private_dns_zone" "redis_dns" {
  provider            = azurerm.connectivity
  name                = "privatelink.redis.cache.windows.net"
  resource_group_name = "rg-dnsprivado-global"
}

#CASO 1: Aprovisionar recurso redis con Private Endpoint
#Nota: outputs usados subnet_id

module "redis" {
  source     = "git::https://dev.azure.com/nttdata-devops/DevOps/_git/terraform-azure-redis?ref=feature/nttdata-first-version"
  rsgr_name  = module.rsgr-01.rsgr_name
  location   = module.rsgr-01.location
  infr-env   = module.infr-env.infr-env-var
  audit      = module.audit.audit-tags
  subnet_id  = module.vnet.subnet_ids[2]
  seq_number = "001"
  
  dns = {
    zone_ids  = [data.azurerm_private_dns_zone.redis_dns.id]
    zone_name = data.azurerm_private_dns_zone.redis_dns.name
  }
  depends_on = [module.rsgr-01, module.vnet]
}
