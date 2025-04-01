resource "azurerm_redis_cache" "redis-001" {
  name                = local.map_custom_name.redis_name
  location            = var.location
  resource_group_name = var.rsgr_name
  capacity            = 1
  family              = lower(local.redis_skuname) == "premium" ? "P" : "C"
  sku_name            = local.redis_skuname
  minimum_tls_version = "1.2"
  redis_version       = "6"
  public_network_access_enabled = local.public_network_access_enabled
  redis_configuration {
  }
  tags = local.tags
}

resource "time_sleep" "wait" {
  depends_on = [azurerm_redis_cache.redis-001]
  create_duration = var.enable_autodestroy ? "${var.destroy_after * 3600}s" : "0s"
}

# Comando para eliminar el recurso después del tiempo definido
resource "null_resource" "delete_after_time" {
  depends_on = [time_sleep.wait]

  provisioner "local-exec" {
    command = "terraform destroy -target=azurerm_redis_cache.redis-001 -auto-approve"
  }
}
      