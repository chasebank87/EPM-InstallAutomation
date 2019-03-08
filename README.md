# EPM InstallAutomation

### Summary:

The goal of this utility was to make the installation and configuration of Hyperion EPM easier and quicker for Hyperion Administrators. While the project is young and in early development this very early version has a lot to offer for very specific situations. 

### Limitations:

1. Oracle DB is not ___currently___ supported
2. SOA is not ___currently___ supported
3. Individual database usernames are not ___currently___ supported

### Requirements:

1. IIS must be installed manually before running utility
2. .Net Framework 3.5 must be installed manually before running utility
3. Logged in as a local Administrator
4. UAC disabled

### Steps:

1. Clone this repository to a folder on your server(s)
2. Edit the variables.ps1 file in the Variables folder
   * Update the $installerPath variable to the directory you cloned the repository (ex. C:\InstallAutomation)

3. Edit the start.ps1, install.ps1, configure.ps1
   * Update the top region where we call our global functions and variables files
   * From the powershell folder in the InstallAutomation path and right click start.ps1, and run with powershell.
4. Follow the prompts

### Features:

1. Super Silent Install
2. Super Silent Config
3. Super Silent All
    * Examples:
    
    ```bash
      .\start.ps1 -superSilentAll -install7zip $true -installnotepadplus  $true -installfirefox $true -installepm $true -epmPath <path> -installFoundation $true -installEssbase $true -installRAF $true -installPlanning $true -installDisclosure $true -installHFM $true -installfdm $true -installProfit $true -installFCM $false -installTax $false -installStrategic $true -dbServer <hostname> -dbPort <port> -dbUser <user> -dbPassword <password> -wkspcAdmin <user> -wkspcAdminPassword <password> -weblogicAdmin <user> -weblogicPort <port> -wkspcPort <port> -epmDomain <domain> -foundationDB <db> -epmaDB <db>  -calcDB <db>  -essbaseDB <db>  -rafDB <db> -planningDB <db> -disclosureDB <db> -hfmDB <db> -fdmDB <db> -profitDB <db> -strategic $true
    ```
    ```bash
.\start.ps1 -superSilentAll -install7zip $true -installnotepadplus  $true -installfirefox $true -installepm $true -epmPath c:\Oracle\Middleware -installFoundation $true -installEssbase $true -installRAF $true -installPlanning $true -installDisclosure $true -installHFM $true -installfdm $true -installProfit $true -installFCM $false -installTax $false -installStrategic $true -dbServer server.domain.com -dbPort 1433 -dbUser hypadmin -dbPassword password -wkspcAdmin admin -wkspcAdminPassword password -weblogicAdmin epm_admin -weblogicPort 7001 -wkspcPort 19000 -epmDomain EPMSystem -foundationDB EPMS_FND -epmaDB EPMS_BPM -calcDB EPMS_CAL -essbaseDB EPMS_ESB -rafDB EPMS_RAF -planningDB EPMS_PLN -disclosureDB EPMS_DMA -hfmDB EPMS_HFM -fdmDB EPMS_FDM -profitDB EPMS_PCM -strategic $true    
    ```    

### See it in Action

<a href="https://vimeo.com/318823905" target="_blank"><img src="https://kb.chaseelder.com/wp-content/uploads/2019/02/Screen-Shot-2019-02-21-at-4.06.28-PM.png" 
alt="EPM InstallAutomation" width="600" height="350"/></a>

<a href="https://kb.chaseelder.com/epm-silent-install-installautomation/">knowledge Base Article</a>
