import os

rsgr_name = os.environ['rsgr_name']
location = os.environ['location']
infr_env = {
    'scope': os.environ['scope'],
    'env': os.environ['env']
}
audit = {
    'codproy': os.environ['codproy'],
    'owner': os.environ['owner'],
    'criticidad': os.environ['criticidad'],
}
seq_number = os.environ['seq_number']

tags = {
    'CodigoProyecto'   : audit['codproy'],
    'NombreOwner'      : audit['owner'],
    'Criticidad'       : audit['criticidad'],
    'Ambiente'         : infr_env['env'],
    'NombreAplicacion' : infr_env['scope'],
}

redis_skuname = "Premium" if infr_env['env'].lower() == 'prod' else "Basic"
family = "P" if redis_skuname.lower() == 'premium' else 'C'
public_network_access_enabled = "true" if infr_env['env'].lower() == "dev" else "false"
resource_redis_code = "redis"
map_custom_name = {
	'redis_name' : resource_redis_code + "-" + infr_env['scope'] + "-" + infr_env['env'] + "-" + seq_number
}
# template
template = """resource "azurerm_redis_cache" "redis-%s" {
	name                = "%s"
	location            = "%s"
	resource_group_name = "%s"
	capacity            = 1
	family              = "%s"
	sku_name            = "%s"
	minimum_tls_version = "1.3"
	redis_version       = "4"
	public_network_access_enabled = "%s"
	redis_configuration {
	}
	tags = %s
}"""

print(template %(seq_number, map_custom_name['redis_name'], location, rsgr_name, family, redis_skuname, public_network_access_enabled, tags))

