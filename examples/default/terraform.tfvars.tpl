# GSA_GENERAL_OPTIONS
subscription_id     = "99f3ac34-3b27-4667-918c-c6953312cea8"
tenant_id           = "00000000-0000-0000-0000-000000000000"
location            = "westeurope"
resource_group_name = "gsa-weu"
gsa_owner_group_id  = "00000000-0000-0000-0000-000000000000"

# AVM_GENERAL_OPTIONS
lock = {
  kind = "CanNotDelete"
  name = "Lock-GSA"
}

# SCALE_SET_OPTIONS
scale_set_name      = "vmss-gsa"
scale_set_subnet_id = "/subscriptions/d379e727-8520-429b-8caa-086d16c31cc6/resourceGroups/rg-gsa-pa-network-we-dev/providers/Microsoft.Network/virtualNetworks/vnet-gsa-pa-network-we-dev/subnets/snet-private-access-we-dev"

tags = {
  "environment" = "dev"
  "landingzone" = "90_appzones"
  "workload"    = "gsa"
}
