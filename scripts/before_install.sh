TF_VERSION="0.12.0"
curl -sLo /tmp/terraform.zip https://releases.hashicorp.com/terraform/$TF_VERSION/terraform_$TF_VERSION_linux_amd64.zip
unzip /tmp/terraform.zip -d /tmp
mkdir ~/bin
mv /tmp/terraform ~/bin
