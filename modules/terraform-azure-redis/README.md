# Redis Cache  - Azure
Azure Cache for Redis proporciona un almacén de datos en memoria basado en el software Redis . Redis mejora el rendimiento y la escalabilidad de una aplicación que utiliza mucho los almacenes de datos de back-end. Es capaz de procesar grandes volúmenes de solicitudes de aplicaciones al mantener los datos a los que se accede con frecuencia en la memoria del servidor, que se pueden escribir y leer rápidamente. Redis ofrece una solución crítica de almacenamiento de datos de baja latencia y alto rendimiento para las aplicaciones modernas.

Azure Cache for Redis ofrece tanto el código abierto de Redis (OSS Redis) como un producto comercial de Redis Inc. (Redis Enterprise) como un servicio administrado. Proporciona instancias de servidor de Redis seguras y dedicadas y compatibilidad total con la API de Redis. El servicio es operado por Microsoft, alojado en Azure y puede ser utilizado por cualquier aplicación dentro o fuera de Azure.

Azure Cache for Redis se puede usar como caché de contenido o datos distribuidos, almacén de sesiones, agente de mensajes y más. Se puede implementar de forma independiente. O bien, se puede implementar junto con otros servicios de base de datos de Azure, como Azure SQL o Azure Cosmos DB.

# Variables
El siguiente cuadro se detallan las varaibles que se pueden utitlizar.

| Variable   | Obligatorio | Valor permitido        | Reconstruccion | Ejemplo                       |
| ---------- | ----------- | ---------------------- | ---------------| ----------------------------- |
| infr-env   | si          | json de valores        | si             | { scope = "ntt", env = "dev"} |
| audit      | si          | json de valores        | no             | { codproy = "1608 - Innovación", owner = "PROYECT NTTDATA", criticidad = "Alto" } |
| rsgr_name  | si          | name resorurce group   | si             | "rg-ntt-dev-002"              |
| location   | si          | una region             | si             | "eastus"                      |
| seq_number | si          | numero de secuencia de 3 digitos | si   | "001"                         | 
| subnet_id  | si          | id subnet              | si             | module.vnet.subnet_id         |
| dns        | si          | json de valores        | si             | { zone_ids = [data.azurerm_private_dns_zone.redis_dns.id], zone_name = data.azurerm_private_dns_zone.redis_dns.name } |

# Regiones permitidas

-   eus = "eastus"
-   wes = "westus"

# Ejemplos

Aprovisionar un redis cache en una sola region.

```ts
module "redis" {
  rsgr_name  = "rg-ntt-dev-002"
  location   = "eastus"
  infr-env   = { scope = "ntt", env = "dev" }
  audit      = { codproy = "1608 - Innovación", owner = "PROYECT NTTDATA", criticidad = "Alto" }
  seq_number = "001"
  subnet_id  = module.vnet.subnet_id

  dns = {
    zone_ids  = [data.azurerm_private_dns_zone.redis_dns.id]
    zone_name = data.azurerm_private_dns_zone.redis_dns.name
  }
}
```

# Contribute
NTTDATA - 2023



terraform workspace list | grep -q auto-iac-redis-v-${{ inputs.redis_version }}-${{ github.run_id }} && terraform workspace select auto-iac-redis-v${{ inputs.redis_version }}-${{ github.run_id }} || terraform workspace new auto-iac-redis-v${{ inputs.redis_version }}-${{ github.run_id }}
