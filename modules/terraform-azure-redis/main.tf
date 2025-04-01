resource "azurerm_redis_cache" "redis-001" {
  name                = local.map_custom_name.redis_name
  location            = var.location
  resource_group_name = var.rsgr_name
  capacity            = 2
  family              = lower(local.redis_skuname) == "premium" ? "P" : "C"
  sku_name            = local.redis_skuname
  #enable_non_ssl_port = false
  minimum_tls_version = "1.2"
  public_network_access_enabled = local.public_network_access_enabled
  redis_configuration {
  }
  tags = local.tags
}

module "privateendpoint" {
  source                 = "git::https://dev.azure.com/nttdata-devops/DevOps/_git/terraform-azure-pe?ref=feature/nttdata-first-version"
  rsgr_name              = var.rsgr_name
  location               = var.location
  subresource_names      = ["redisCache"]
  endpoint_resource_id   = azurerm_redis_cache.redis-001.id
  endpoint_resource_name = local.map_custom_name.redis_name
  # endpoint_resource_name = local.resource-redis-code
  infr-env               = var.infr-env
  audit                  = var.audit
  subnet_id              = var.subnet_id
  dns                    = var.dns
}
