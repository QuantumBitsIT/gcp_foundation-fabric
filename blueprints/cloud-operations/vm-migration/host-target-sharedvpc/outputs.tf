# Copyright 2023 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

output "m4ce_gmanaged_service_account" {
  description = "Google managed service account created automatically during the migrate connector registration. It is used by M4CE to perform activities on target projects."
  value       = "serviceAccount:service-${module.host-project.number}@gcp-sa-vmmigration.iam.gserviceaccount.com"
}
