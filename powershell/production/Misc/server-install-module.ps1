#Run on Windows Servers to allow module installation
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Install-PackageProvider -Name NuGet
Register-PSRepository -Default