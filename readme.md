# Azure の初期設定を Cloud Shell から実行
## Terraform 用のアプリケーションを作って、
az ad app create --display-name Terraform-Sample --password P@ssw0rd123!
## そのアプリのサービスプリンシパルを作って、
az ad sp create --id a1e565e8-XXXX-YYYY-ZZZZ-f078d8c19c12
## サービスプリンシパルに Contributor の権限を付与する。
az role assignment create --assignee-object-id 54d4158b-XXXX-YYYY-ZZZZ-d19cd1fc9b00 --role contributor

条件・環境に合わせて権限は調整してください。
