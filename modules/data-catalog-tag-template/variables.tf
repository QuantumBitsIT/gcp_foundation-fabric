/**
 * Copyright 2023 Google LLC
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

variable "display_name" {
  description = "Tag template display name."
  type        = string
  default     = ""
}

variable "force_delete" {
  description = "This confirms the deletion of any possible tags using this template. Must be set to true in order to delete the tag template."
  type        = bool
}

variable "iam" {
  description = "IAM bindings in {ROLE => [MEMBERS]} format. Mutually exclusive with the access_* variables used for basic roles."
  type        = map(list(string))
  default     = {}
  nullable    = false
}

variable "iam_bindings" {
  description = "Authoritative IAM bindings in {KEY => {role = ROLE, members = [], condition = {}}}. Keys are arbitrary."
  type = map(object({
    members = list(string)
    role    = string
    condition = optional(object({
      expression  = string
      title       = string
      description = optional(string)
    }))
  }))
  default  = {}
  nullable = false
}

variable "iam_bindings_additive" {
  description = "Keyring individual additive IAM bindings. Keys are arbitrary."
  type = map(object({
    member = string
    role   = string
    condition = optional(object({
      expression  = string
      title       = string
      description = optional(string)
    }))
  }))
  default  = {}
  nullable = false
}

variable "name" {
  description = "Tag template name."
  type        = string
  validation {
    condition     = can(regex("^[a-z_][a-z0-9_]{0,63}$", var.name))
    error_message = "'tag_templates' id value must start with a letter (a-z) or underscore (_) and only contain letters (a-z), numbers(0-9) or underscores(_)."
  }
}

variable "project_id" {
  description = "Id of the project where repository will be created."
  type        = string
}

variable "region" {
  description = "Tag template region."
  type        = string
  default     = "europe-west3"
}

variable "tag_template_fields" {
  description = "Tag templates to be created."
  type = list(object({
    field_id     = string
    type         = string
    values       = optional(list(string))
    description  = optional(string)
    display_name = optional(string)
    is_required  = optional(bool, false)
    order        = optional(number)
  }))

  validation {
    condition     = alltrue([for field in var.tag_template_fields : contains(["BOOL", "DOUBLE", "ENUM", "STRING", "TIMESTAMP"], field["type"])])
    error_message = "Supported types are 'BOOL', 'DOUBLE', 'ENUM', 'STRING' and 'TIMESTAMP'."
  }
}
