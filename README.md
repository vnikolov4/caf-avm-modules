# caf-avm-source
AVM Modules



# Collecting required AVM modules in a single own GitHub repo

Pros:

✅ All the AVM modules you use are in one repo

✅ Super easy for your IaC code to reference: just source = "git::https://github.com/my-org/terraform-avm-vendor.git//avm-res-network-virtualnetwork"

✅ You control when to pull updates; you can pin by commit/tag

✅ Works great in locked-down environments (only allow your org’s repos)

Cons:

You are responsible for periodically syncing from upstream (but that’s true for any fork/cloned copy).

This is what I’d recommend !

Sources:
    https://azure.github.io/Azure-Verified-Modules/indexes/terraform/tf-resource-modules/


The own Repo AVM module structure:
        caf-avm-modules/
        avm-res-network-virtualnetwork/
        avm-res-network-subnet/
        avm-res-keyvault-vault/
        avm-res-storage-storageaccount/
        README.md

Example of the git command to be executed for creating the tree:
git subtree add --prefix avm-res-network-virtualnetwork https://github.com/Azure/terraform-azurerm-avm-res-network-virtualnetwork.git main --squash

Imported Resources:
avm-res-resources-resourcegroup
https://github.com/Azure/terraform-azurerm-avm-res-resources-resourcegroup.git

avm-res-network-virtualnetwork
https://github.com/Azure/terraform-azurerm-avm-res-network-virtualnetwork.git


You can use Git submodules, but I’d actually recommend avoiding them for Terraform modules unless you truly need submodules for other reasons.

Recommended: Use Git module source, not Git submodule

You have:

Repo A: my-org/caf-avm-modules (all AVM modules, vendored)

Repo B: my-org/caf-avm-lz (your layered IaC)