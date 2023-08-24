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

# tfdoc:file:description GCVE stage resources.

module "branch-gcve-folder" {
  source = "../../../modules/folder"
  count  = var.fast_features.gcve ? 1 : 0
  parent = module.branch-infra-folder.id
  name   = "GCVE"
  group_iam = local.groups.gcp-gcve-admins == null ? {} : {
    (local.groups.gcp-gcve-admins) = [
      "roles/vmwareengine.vmwareengineAdmin"
    ]
  }
  tag_bindings = {
    context = try(
      module.organization.tag_values["${var.tag_names.context}/gcve"].id, null
    )
  }
}
module "branch-gcve-dr-folder" {
  source = "../../../modules/folder"
  count  = var.fast_features.gcve ? 1 : 0
  parent = module.branch-gcve-folder.0.id
  name   = "Disaster Recovery"

  iam = {
    "roles/logging.admin"                  = [module.branch-gcve-dr-sa.0.iam_email]
    "roles/owner"                          = [module.branch-gcve-dr-sa.0.iam_email]
    "roles/resourcemanager.folderAdmin"    = [module.branch-gcve-dr-sa.0.iam_email]
    "roles/resourcemanager.projectCreator" = [module.branch-gcve-dr-sa.0.iam_email]
    "roles/compute.xpnAdmin"               = [module.branch-gcve-dr-sa.0.iam_email]
  }
  tag_bindings = {
    context = try(
      module.organization.tag_values["${var.tag_names.environment}/disasterrecovery"].id, null
    )
  }
}

module "branch-gcve-prod-folder" {
  source = "../../../modules/folder"
  count  = var.fast_features.gcve ? 1 : 0
  parent = module.branch-gcve-folder.0.id
  name   = "Production"

  iam = {
    "roles/logging.admin"                  = [module.branch-gcve-prod-sa.0.iam_email]
    "roles/owner"                          = [module.branch-gcve-prod-sa.0.iam_email]
    "roles/resourcemanager.folderAdmin"    = [module.branch-gcve-prod-sa.0.iam_email]
    "roles/resourcemanager.projectCreator" = [module.branch-gcve-prod-sa.0.iam_email]
    "roles/compute.xpnAdmin"               = [module.branch-gcve-prod-sa.0.iam_email]
  }
  tag_bindings = {
    context = try(
      module.organization.tag_values["${var.tag_names.environment}/production"].id, null
    )
  }
}

module "branch-gcve-dr-sa" {
  source       = "../../../modules/iam-service-account"
  count        = var.fast_features.gcve ? 1 : 0
  project_id   = var.automation.project_id
  name         = "dr-resman-gcve-0"
  display_name = "Terraform resman gcve service account."
  prefix       = var.prefix
  # To implement later for CI/CD
  # iam = {
  #   "roles/iam.serviceAccountTokenCreator" = compact([
  #     try(module.branch-gcve-sa-cicd.0.iam_email, null)
  #   ])
  # }
  iam_storage_roles = {
    (var.automation.outputs_bucket) = ["roles/storage.objectAdmin"]
  }
}

module "branch-gcve-prod-sa" {
  source       = "../../../modules/iam-service-account"
  count        = var.fast_features.gcve ? 1 : 0
  project_id   = var.automation.project_id
  name         = "prod-resman-gcve-0"
  display_name = "Terraform resman gcve service account."
  prefix       = var.prefix
  # To implement later for CI/CD
  # iam = {
  #   "roles/iam.serviceAccountTokenCreator" = compact([
  #     try(module.branch-gcve-sa-cicd.0.iam_email, null)
  #   ])
  # }
  iam_storage_roles = {
    (var.automation.outputs_bucket) = ["roles/storage.objectAdmin"]
  }
}

module "branch-gcve-dr-gcs" {
  source        = "../../../modules/gcs"
  count         = var.fast_features.gcve ? 1 : 0
  project_id    = var.automation.project_id
  name          = "dr-resman-gcve-0"
  prefix        = var.prefix
  location      = var.locations.gcs
  storage_class = local.gcs_storage_class
  versioning    = true
  iam = {
    "roles/storage.objectAdmin" = [module.branch-gcve-dr-sa.0.iam_email]
  }
}

module "branch-gcve-prod-gcs" {
  source        = "../../../modules/gcs"
  count         = var.fast_features.gcve ? 1 : 0
  project_id    = var.automation.project_id
  name          = "prod-resman-gcve-0"
  prefix        = var.prefix
  location      = var.locations.gcs
  storage_class = local.gcs_storage_class
  versioning    = true
  iam = {
    "roles/storage.objectAdmin" = [module.branch-gcve-prod-sa.0.iam_email]
  }
}