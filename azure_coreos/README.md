# Create Azure CoreOS VM

1.  tested terraform version -> 0.11.4
2.  need SSH key in file repo

Run docker - 

```
docker run -it --rm -v "\kuber\azure_coreos":/terra -w=/terra -e "TF_VAR_admin_username=<username>" -e "TF_VAR_admin_password=<pw>" -e "TF_VAR_client_id=<client_id>" -e "TF_VAR_client_secret=<secret>" -e "TF_VAR_subscription_id=<sub_id>" -e "TF_VAR_tenant_id=<tenant_id>" hashicorp/terraform:0.11.4 init/plan/apply/destroy

```