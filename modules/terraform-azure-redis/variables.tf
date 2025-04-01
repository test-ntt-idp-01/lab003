variable "rsgr_name" {
  description = "Nombre del resource group previamente creado en donde se aprovisionará redis. Ej. rg-ntt-dev-001"
  type        = string
}

variable "location" {
  description = "Locacion donde se va aprovisionar. Ej. eastus"
  type        = string
}

variable "subnet_id" {
  description = "Id de la subnet que se va utilizar"
  type        = string
}

variable "dns" {
  description = "Los detalles de la Zona DNS privada donde se registrará el Private Endpoint"
  type = object({
    zone_ids  = list(string)
    zone_name = string
  })
}

###################################### INICIO Variables Base ###################################################

variable "infr-env" {
  description = "Variables de infra de ambiente scope,env"
  type = object({
    scope = string
    env   = string
  })
  validation {
    condition     = length(var.infr-env.scope) > 2
    error_message = "El scope o canal debe ser mayor a 2 caracteres"
  }
  validation {
    condition     = length(var.infr-env.env) > 0 && length(var.infr-env.env) < 6
    error_message = "El codigo de ambiente debe ser mayor a 2 caracteres y menor a 6 caracteres"
  }
}

variable "audit" {
  description = "Variables de auditoria"
  type = object({
    codproy    = string
    owner      = string
    criticidad = string
  })
  validation {
    condition     = length(var.audit.codproy) > 3
    error_message = "El codproy debe ser mayor a 3 caracteres. Ejemplo: 1497 - Producción De Sistemas | 1608 - Innovación"
  }
  validation {
    condition     = length(var.audit.owner) > 3
    error_message = "El owner debe ser mayor a 3 caracteres. Ejemplo: URPI | SIGE | APP MOVL "
  }
  validation {
    condition     = length(var.audit.criticidad) > 3
    error_message = "La criticidad debe ser mayor 3 digitos. Ejemplo: Muy alto | Alto | Medio | Bajo"
  }
}

variable "seq_number" {
  description = "Numero secuencial correlativo del recurso. Ej. 001"
  type        = string
  default     = "001"
}

###################################### FIN Variables Base ###################################################

locals {
  tags = {
    CodigoProyecto   = var.audit.codproy
    NombreOwner      = var.audit.owner
    Criticidad       = var.audit.criticidad
    Ambiente         = var.infr-env.env
    NombreAplicacion = var.infr-env.scope
  }
  redis_skuname       = lower(var.infr-env.env) == "prod" ? "Premium" : "Standard"
  public_network_access_enabled = lower(var.infr-env.env) == "dev" ? true : false
  resource-redis-code = "redis"
  map_custom_name = {
    redis_name = lower(format("%s%s%s%s%s%s%s", local.resource-redis-code, "-", var.infr-env.scope, "-", var.infr-env.env, "-", var.seq_number))
  }
}
