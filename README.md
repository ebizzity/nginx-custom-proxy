# nginx-custom-proxy

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Febizzity%2Fnginx-custom-proxy%2Fmaster%2Fazuredeploy.json)

This template deploys a custom NGINX reverse proxy into an existing vnet in Azure.  This is a standard Ubuntu VM which then runs a custom script extension to install and configure NGINX.  This can be used as a DNS Proxy, a way to connect to SQL-MI via GLobal VNET Peering, etc.  Click the button above to deploy to your Azure subscription.  

The following parameters are expected:

Service IP: IP Address of the service that is being put behind the proxy.

Port:  Port of the service being put behind the proxy.

ListenPort:  TCP/UDP Port to run the Listener on.

Protocol: TCP or UDP

StorageAccountName: Storage Account for VM Diags

VNETRG: Resource group for the VNET to place VM into.

VNETNAME: Name of VNET for VM to use

SubnetName: Name of Subnet for VM to use

VM Username: VM Username
VM Password: VM Password