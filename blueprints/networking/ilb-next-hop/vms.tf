/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

locals {
  vm_startup_script = <<END
    apt update
    apt upgrade -y
    apt install -y nginx tcpdump
END
}

module "vm-left" {
  source        = "../../../modules/compute-vm"
  for_each      = local.zones
  project_id    = module.project.project_id
  zone          = each.value
  name          = "${var.prefix}-vm-left-${each.key}"
  instance_type = "f1-micro"
  network_interfaces = [
    {
      network    = module.vpc-left.self_link
      subnetwork = values(module.vpc-left.subnet_self_links)[0]
    }
  ]
  tags = ["ssh"]
  metadata = {
    startup-script = local.vm_startup_script
  }
  service_account = {
    email = try(module.service-accounts.email, null)
  }
}

module "vm-right" {
  source        = "../../../modules/compute-vm"
  for_each      = local.zones
  project_id    = module.project.project_id
  zone          = each.value
  name          = "${var.prefix}-vm-right-${each.key}"
  instance_type = "f1-micro"
  network_interfaces = [
    {
      network    = module.vpc-right.self_link
      subnetwork = values(module.vpc-right.subnet_self_links)[0]
    }
  ]
  tags = ["ssh"]
  metadata = {
    startup-script = local.vm_startup_script
  }
  service_account = {
    email = try(module.service-accounts.email, null)
  }
}
