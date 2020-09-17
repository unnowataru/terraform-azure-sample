# 見終わったらすぐできる！HashiCorp Terraform で Azure のプロビジョニング

## 以下の事前準備をAzure Cloud Shell で実行してください
### Terraform 用のアプリケーションを作って、

`ad app create --display-name Terraform-Sample --password S@mp!eP@ssw0rd`

### そのアプリのサービスプリンシパルを作って、

`az  ad sp create --id a1e565e8-XXXX-YYYY-ZZZZ-f078d8c19c12`

### サービスプリンシパルに Contributor の権限を付与する。

`az role assignment create --assignee-object-id 54d4158b-XXXX-YYYY-ZZZZ-d19cd1fc9b00 --role contributor`

条件・環境に合わせて権限は調整してください。
