usr_subscription_id = "XXXX9a92-1234-5678-9012-156b80f2caaa"       # サブスクリプションID (調べる)
usr_tenant_id = "XXXXc4d1-1234-5678-9012-69e89fb4daaa"             # テナントID (調べる)

usr_client_id = "XXXX3b15-1234-5678-9012-563c9c9f1aaa"             # クライアントID (アプリを登録したときに自動生成される)
usr_client_secret = "Netw0rld123!"                                 # シークレット/パスワード (サービスプリンシパルを作ったときに入力している)

usr_region = "southeastasia"                                       # リージョン指定
usr_rg_name = "Sample-RG-0X"                                       # リソースグループ名
usr_vnet_name = "Sample-VNet"                                      # 仮想ネットワーク名
usr_vnet_range = ["10.10.0.0/16"]                                  # 仮想ネットワークのレンジ
usr_subnet_name = "Sample-Subnet"                                  # サブネット名
usr_subnet_range = ["10.10.1.0/24"]                                # サブネットのレンジ
usr_nic_name = "Sample-NIC"                                        # ネットワークインターフェース名
usr_pip_name = "Sample-PIP"                                        # パブリックIP名
usr_nsg_name = "Sample-NSG"                                        # ネットワークセキュリティグループ名
usr_vm_name = "TFVM0001"                                           # 仮想マシン名
usr_vm_size = "Standard_D2s_v3"                                    # 仮想マシンのインスタンスサイズ
usr_vm_username = "AzureUser"                                      # 仮想マシンの管理者名
usr_vm_password = "Netw0rld123!"                                   # 仮想マシンのパスワード

usr_bastion_subnet_name = "AzureBastionSubnet"                     # Bastion用のサブネット名 : AzureBastionSubnetで固定値!!
usr_bastion_subnet_range = ["10.10.255.0/27"]                      # Bastion用のサブネットのレンジ
usr_bastion_pip_name = "Bastion-PIP"                               # Bastion用のパブリックIP名
usr_bastion_name = "Sample-Bastion"                                # Bastionの名前
