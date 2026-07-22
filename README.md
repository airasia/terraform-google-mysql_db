Terraform module for a MySQL CloudSQL Instance in GCP

# Upgrade guide from v2.4.1 to v3.0.0

This release upgrades the Cloud SQL dependency to `26.2.2`, requires Terraform `>= 1.3.0`, and supports Google and Google Beta providers `>= 7.12.0, < 8.0.0`.

Consumers can now create PSC-enabled MySQL instances with explicit SSL mode:

```terraform
psc_enabled                   = true
psc_allowed_consumer_projects = ["move-hotels-stg"]
ssl_mode_master_instance      = "ENCRYPTED_ONLY"
ssl_mode_read_replica         = "ENCRYPTED_ONLY"
```

The upstream module now uses `random_password` for generated user passwords. To avoid changing an existing generated password, supply the current password explicitly before upgrading.

The upgrade also enables API-level deletion protection whenever the existing deletion-protection inputs are enabled. Run `terraform plan` and confirm that no Cloud SQL instance or replica replacement is proposed before applying.

For additional users, include `random_password`, `type`, and `host` in each object.

# Upgrade guide from v2.1.0 to v2.1.1

This upgrade requires google provider [v3.44.0](https://github.com/hashicorp/terraform-provider-google/releases/tag/v3.44.0) or above which introduces the `deletion_protection` feature to `google_sql_database_instance` resources. Plan & Apply the google provider version upgrade first **before** upgrading this module version to `v2.1.1`.

# Upgrade guide from v2.0.4 to v2.1.0

First make sure you've planned & applied `v2.0.4`. Then, upon upgrading from `v2.0.4` to `v2.1.0`, you may (or may not) see a plan that destroys & creates an equal number of `google_project_iam_member` resources. It is OK to apply these changes as it will only change the data-structure of these resources [from an array to a hashmap](https://github.com/airasia/terraform-google-external_access/wiki/The-problem-of-%22shifting-all-items%22-in-an-array). Note that, after you plan & apply these changes, you may (or may not) get a **"Provider produced inconsistent result after apply"** error. Just re-plan and re-apply and that would resolve the error.

# Upgrade guide to v2.0.0

`v2.0.0` uses **Terraform v0.13**. You must first upgrade this module through `v1.4.x` incrementally (see below), before you can proceed to upgrade to `v2.0.0`.

Once you have upgraded this module through `v1.4.x`, then before upgrading this module to `v2.0.0` you will first need to upgrade your Terraform version to `v0.13`.

After you have upgraded to **Terraform v0.13**, then in order to upgrade this module to `v2.0.0`, replace the use of `module_depends_on` (if any) with the new Terraform-native `depends_on` instead.

When upgrading this module to `v2.0.0`, you may come across a plan like this:

```terraform
# module.google_mysql_db.null_resource.module_depends_on must be replaced
-/+ resource "null_resource" "module_depends_on" {
      ~ id       = "1295974236403409710" -> (known after apply)
      ~ triggers = { # forces replacement
          ~ "value" = "2" -> "0"
        }
    }
```

It's okay to run `terraform apply` with this plan, as the structure of dependency-injection has changed in **Terraform v0.13**

---

# Upgrade guide through v1.4.x

These incremental upgrades through `1.3.x` -> `1.4.1` -> `1.4.2` -> `1.4.3` will prepare your module for upgrade to `v2.0.0` which uses the new **Terraform v0.13**.

### Upgrading to v1.4.1
* Upgrade `mysql_db` module version to `1.4.1`
* Remove all references of Failover replica from your Terrform configuration
* Run `terraform plan`
   * the plan will show that it will remove the failover instance from your CloudSQL
* Run `terraform apply`
   * the **failover instance will be removed**
   * **no down-time expected on master instance** - unless the GCP zone is (coincidentally) having any kind of outage during that time
   * consider the schedule when you apply this change in production

### Upgrading to v1.4.2
* Upgrade `mysql_db` module version to `1.4.2`
* Enable `var.highly_available = true` if you require Failover / High-Availability
* Run `terraform plan`
   * the plan will show that it will enable High-Availability (failover) for your CloudSQL
* Run `terraform apply`
   * **down-time is expected** - the master instance undergoes a restart at this point
   * consider the schedule when you apply this change in production as your users may not be able to access your DB during this operation

### Upgrading to v1.4.3
* Upgrade `mysql_db` module version to `1.4.3`
* Run `terraform plan`
   * the plan will show that your ReadReplica instance will be replaced - we want to avoid any kind of replacement
   * notice that the plan says an **existing** resource (let's say `resourceX`) will be destroyed and a **new** reource (let's say `resourceY`) will be created
   * notice the array index names
      * `resourceX` has array index `[0]` - although it may not show `[0]`
      * `resourceY` will have array index with the new resource name
* Use `terraform state mv` to manually move the state of `resourceX` to `resourceY`
   * notice the array index names
      * `resourceX` has array index `[0]` - although it may not show `[0]`
      * `resourceY` will have array index with the new resource name
   * refer to https://www.terraform.io/docs/commands/state/mv.html to learn more about how to move Terraform state positions
   * once moved, it will say `Successfully moved 1 object(s).`
* Run `terraform plan`
   * the plan should now show that no changes required
   * this confirms that you have successfully migrated your resource state to a new position as required by `v1.4.3`.

For more elaborate / curious / geeky details, you may refer to the [upgrade guide](https://github.com/terraform-google-modules/terraform-google-sql-db/blob/master/docs/upgrading_to_sql_db_4.0.0.md#upgrading-to-sql-db-400) published by the [terraform-google-sql-db](https://github.com/terraform-google-modules/terraform-google-sql-db) module.

---
