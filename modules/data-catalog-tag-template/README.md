# Google Cloud Data Catalog Tag Template Repository
This module allows the creation of data catalog tag templates including managing of IAM permissions. The module checks if field types are allowed as per data catalog requirements.
## Examples
### Simple tag template
```hcl
module "tag_templates" {
  source       = "/Users/marcwo/Dev/assets/fabric-tag-module/modules/data-catalog-tag-template"
  project_id   = "fast-bi-fabric"
  name         = "my_test_template"
  force_delete = true
  tag_template_fields = [
    {
      field_id     = "my-example-field"
      display_name = "My example tag template field"
      type         = "STRING"
    },
    {
      field_id = "my-example-field2"
      type     = "ENUM"
      values   = ["value1", "value2"]
    }
  ]
}
# tftest modules=1 resources=1
```
### Tag template with IAM
```hcl
module "tag_templates" {
  source       = "/Users/marcwo/Dev/assets/fabric-tag-module/modules/data-catalog-tag-template"
  project_id   = "fast-bi-fabric"
  name         = "my_test_template"
  force_delete = true
  tag_template_fields = [
    {
      field_id     = "my-example-field"
      display_name = "My example tag template field"
      type         = "STRING"
    },
    {
      field_id = "my-example-field2"
      type     = "ENUM"
      values   = ["value1", "value2"]
    }
  ]
  iam = {
    "roles/datacatalog.tagTemplateOwner" = ["user:owner@example.com"]
  }
}
# tftest modules=1 resources=2
```
<!-- BEGIN TFDOC -->
## Variables

| name | description | type | required | default |
|---|---|:---:|:---:|:---:|
| [force_delete](variables.tf#L23) | This confirms the deletion of any possible tags using this template. Must be set to true in order to delete the tag template. | <code>bool</code> | ✓ |  |
| [name](variables.tf#L65) | Tag template name. | <code>string</code> | ✓ |  |
| [project_id](variables.tf#L74) | Id of the project where repository will be created. | <code>string</code> | ✓ |  |
| [tag_template_fields](variables.tf#L85) | Tag templates to be created. | <code title="list&#40;object&#40;&#123;&#10;  field_id     &#61; string&#10;  type         &#61; string&#10;  values       &#61; optional&#40;list&#40;string&#41;&#41;&#10;  description  &#61; optional&#40;string&#41;&#10;  display_name &#61; optional&#40;string&#41;&#10;  is_required  &#61; optional&#40;bool, false&#41;&#10;  order        &#61; optional&#40;number&#41;&#10;&#125;&#41;&#41;">list&#40;object&#40;&#123;&#8230;&#125;&#41;&#41;</code> | ✓ |  |
| [display_name](variables.tf#L17) | Tag template display name. | <code>string</code> |  | <code>&#34;&#34;</code> |
| [iam](variables.tf#L28) | IAM bindings in {ROLE => [MEMBERS]} format. Mutually exclusive with the access_* variables used for basic roles. | <code>map&#40;list&#40;string&#41;&#41;</code> |  | <code>&#123;&#125;</code> |
| [iam_bindings](variables.tf#L35) | Authoritative IAM bindings in {KEY => {role = ROLE, members = [], condition = {}}}. Keys are arbitrary. | <code title="map&#40;object&#40;&#123;&#10;  members &#61; list&#40;string&#41;&#10;  role    &#61; string&#10;  condition &#61; optional&#40;object&#40;&#123;&#10;    expression  &#61; string&#10;    title       &#61; string&#10;    description &#61; optional&#40;string&#41;&#10;  &#125;&#41;&#41;&#10;&#125;&#41;&#41;">map&#40;object&#40;&#123;&#8230;&#125;&#41;&#41;</code> |  | <code>&#123;&#125;</code> |
| [iam_bindings_additive](variables.tf#L50) | Keyring individual additive IAM bindings. Keys are arbitrary. | <code title="map&#40;object&#40;&#123;&#10;  member &#61; string&#10;  role   &#61; string&#10;  condition &#61; optional&#40;object&#40;&#123;&#10;    expression  &#61; string&#10;    title       &#61; string&#10;    description &#61; optional&#40;string&#41;&#10;  &#125;&#41;&#41;&#10;&#125;&#41;&#41;">map&#40;object&#40;&#123;&#8230;&#125;&#41;&#41;</code> |  | <code>&#123;&#125;</code> |
| [region](variables.tf#L79) | Tag template region. | <code>string</code> |  | <code>&#34;europe-west3&#34;</code> |
<!-- END TFDOC -->
