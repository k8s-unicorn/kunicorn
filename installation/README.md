# Installation script

Here we use [terraform](https://terraform.io) to deploy k8s distribution for testing.
if you want to deploy to Qingcloud. please download the [Qingcloud terraform plugin](https://github.com/yunify/qingcloud-terraform-provider)

create a terraform script as below:

``` hcl

provider "qingcloud" {
	access_key = "****"
	secret_key = "*******"
	zone = "ap2a"
}

```

init project 

``` shell
terraform init
```

and apply

``` shell
terraform apply
```