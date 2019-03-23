# EPM InstallAutomation

### Summary:

The goal of this utility was to make the installation and configuration of Hyperion EPM easier and quicker for Hyperion Administrators. While the project is young and in early development this very early version has a lot to offer for very specific situations. __Scroll down to the bottom of this page to find the instructions for your particular environemt layout__

### Limitations:

1. Oracle DB is not ___currently___ supported
2. SOA is not ___currently___ supported
3. Individual database usernames are not ___currently___ supported

### Requirements:

1. Logged in as a local Administrator
2. Run powershell as admin
2. A SQL Server,  and a User with sysadmin access ___or___ The databases previously created to Oracle specifications
4. 64 Bit OS Only
5. Windows Server 2008 or 2012

### Steps:

1. Clone this repository to a folder on your server(s)
2. Unblock the three scripts in the powershell folder
3. Open Powershell as Administrator
4. Set ExecutionPolicy to Unrestricted
```
Set-ExecutionPolicy Unrestricted
```
5. Browse to utility powershell path
  ```
  cd c:\InstallAutomation\Powershell
  ```
6. Run start.ps1
  ```
  .\start.ps1
  ```
7. Follow the prompts (if silent parameters where not used)

### Command Line Options:

Use only one of the following main options: -superSilentInstall, -superSilentConfig, -superSilentAll. To do a silent config, and install use the -superSilentAll option and all of its required and optional options. If you want to do just a silent install use the -superSilentInstall and all of its required options and optional options. Do the same thing for a silent configuration. If you specify a database for any of the modules the utility will configure that module. If a database name is not specified for a module that module will not be configured.

  #### -superSilentInstall
      * Required Sub Options:
          * -installEPM ($true | $false)
          * -epmPath (String | Example: C:\Oracle\Middleware)
      * Optional Sub Options: (Default answer to below install switches is $false)
          * -install7zip ($true | $false)
          * -installNotepadPlus ($true | $false)
          * -installFirefox ($true | $false)
          * -installFoundation ($true | $false)
          * -installEssbase ($true | $false)
          * -installRAF ($true | $false)
          * -installPlanning ($true | $false)
          * -installDisclosure ($true | $false)
          * -installHFM ($true | $false)
          * -installFDM ($true | $false)
          * -installProfit ($true | $false)
          * -installFCM ($true | $false)
          * -installTax ($true | $false)
          * -installStrategic ($true | $false)
          * -version900 (Switch | Using this switch will install 11.1.2.4.900 otherwise 11.1.2.4 will be installed)
  #### -superSilentConfig
      * Required Sub Options:
          * -dbServer (String | Example: server.domain.local)
          * -dbPort (String | Example: 1433)
          * -dbUser (String | Example: Hypadmin)
          * -dbpassword (String | Example: password!)
          * -wkspcAdmin (String | Example: Admin)
          * -wkspcAdminPassword (String | Example: password!)
          * -wkspcPort (String | Example: 19000)
          * -weblogicAdmin (String | Example: epm_admin)
          * -weblogicPort (String | Example: 7001)
          * -weblogicHostname (String | Example: server.domain.local)
          * -epmDomain (String | Example: EPMSystem)
          * -strategic ($true | $false)
      * Optional Sub Options:
          * -epmaDB (String | Example: EPMS_BPM)
          * -calcDB (String | Example: EPMS_CAL)
          * -essbaseDB (String | Example: EPMS_ESB)
          * -rafDB (String | Example: EPMS_RAF)
          * -planningDB (String | Example: EPMS_PLN)
          * -disclosureDB (String | Example: EPMS_DMA)
          * -hfmDB (String | Example: EPMS_HFM)
          * -fdmDB (String | Example: EPMS_FDM)
          * -profitDB (String | Example: EPMS_PCM)
          * -startEPM ($true | $false)
          * -validate ($true | $false)
          * -distributedEssbase ($true | $false)
          * -distributedHFM ($true | $false)
          * -distributedPlanning ($true | $false)
          * -distributedFDM ($true | $false)
          * -remoteDeployment ($true | $false)
          * -configSQL (switch)
          * -sqlAdmin (String | Example: sa)
          * -sqlAdminPassword (String | Example: Password!)
          * -version900 (Switch | Using this switch will configure 11.1.2.4.900 otherwise 11.1.2.4 will be configured)
          * -instance (String | Example: FND1)
          * -noDomain (Switch | Using this switch will configure EPM with hostname only not hostname and domain)
   #### -superSilentAll
       * Required Sub Options:
          * -installEPM ($true | $false)
          * -epmPath (String | Example: C:\Oracle\Middleware)
          * -dbServer (String | Example: server.domain.local)
          * -dbPort (String | Example: 1433)
          * -dbUser (String | Example: Hypadmin)
          * -dbpassword (String | Example: password!)
          * -wkspcAdmin (String | Example: Admin)
          * -wkspcAdminPassword (String | Example: password!)
          * -wkspcPort (String | Example: 19000)
          * -weblogicAdmin (String | Example: epm_admin)
          * -weblogicPort (String | Example: 7001)
          * -weblogicHostname (String | Example: server.domain.local)
          * -epmDomain (String | Example: EPMSystem)
          * -foundationDB (String | Example: EPMS_FND)
          * -strategic ($true | $false)
       * Optional Sub Options: (Default answer to below install switches is $false)
          * -install7zip ($true | $false)
          * -installNotepadPlus ($true | $false)
          * -installFirefox ($true | $false)
          * -installFoundation ($true | $false)
          * -installEssbase ($true | $false)
          * -installRAF ($true | $false)
          * -installPlanning ($true | $false)
          * -installDisclosure ($true | $false)
          * -installHFM ($true | $false)
          * -installFDM ($true | $false)
          * -installProfit ($true | $false)
          * -installFCM ($true | $false)
          * -installTax ($true | $false)
          * -installStrategic ($true | $false)
          * -epmaDB (String | Example: EPMS_BPM)
          * -calcDB (String | Example: EPMS_CAL)
          * -essbaseDB (String | Example: EPMS_ESB)
          * -rafDB (String | Example: EPMS_RAF)
          * -planningDB (String | Example: EPMS_PLN)
          * -disclosureDB (String | Example: EPMS_DMA)
          * -hfmDB (String | Example: EPMS_HFM)
          * -fdmDB (String | Example: EPMS_FDM)
          * -profitDB (String | Example: EPMS_PCM)
          * -startEPM ($true | $false)
          * -validate ($true | $false)
          * -distributedEssbase ($true | $false)
          * -distributedHFM ($true | $false)
          * -distributedPlanning ($true | $false)
          * -distributedFDM ($true | $false)
          * -remoteDeployment ($true | $false)
          * -configSQL (switch)
          * -sqlAdmin (String | Example: sa)
          * -sqlAdminPassword (String | Example: Password!)
          * -version900 (Switch | Using this switch will install/configure 11.1.2.4.900 otherwise 11.1.2.4 will be installed/configured)
          * -instance (String | Example: FND1)
          * -noDomain (Switch | Using this switch will configure EPM with hostname only not hostname and domain)
          
### Environment Instructions:

1. <a href="https://github.com/chasebank87/EPMSilent-InstallAutomation/blob/master/Standalone.md">Standalone EPM __(Single Server Environment)__</a>
2. <a href="https://github.com/chasebank87/EPMSilent-InstallAutomation/blob/master/DistributedEssbase.md">Distributed Essbase __(Two Server Environment)__</a>
2. <a href="https://github.com/chasebank87/EPMSilent-InstallAutomation/blob/master/DistributedHFM.md">Distributed HFM __(Two Server Environment)__</a>
3. <a href="https://github.com/chasebank87/EPMSilent-InstallAutomation/blob/master/DistributedPlanning.md">Distributed Planning & Essbase __(Three Server Environment)__</a>



### Features:

1. Super Silent Install
2. Super Silent Config
3. Super Silent All
    * Examples:
    
```bash
.\start.ps1 -superSilentAll -installIIS $true -installNetFrame $true -install7zip $true -installnotepadplus  $true -installfirefox $true -installepm $true -epmPath <path> -installFoundation $true -installEssbase $true -installRAF $true -installPlanning $true -installDisclosure $true -installHFM $true -installfdm $true -installProfit $true -installFCM $false -installTax $false -installStrategic $true -dbServer <hostname> -dbPort <port> -dbUser <user> -dbPassword <password> -wkspcAdmin <user> -wkspcAdminPassword <password> -weblogicAdmin <user> -weblogicPort <port> -weblogicHostname <hostname> -wkspcPort <port> -epmDomain <domain> -foundationDB <db> -epmaDB <db>  -calcDB <db>  -essbaseDB <db>  -rafDB <db> -planningDB <db> -disclosureDB <db> -hfmDB <db> -fdmDB <db> -profitDB <db> -strategic $true -startEPM $true -validate $true
```



```bash
.\start.ps1 -superSilentAll -installIIS $true -installNetFrame $true -install7zip $true -installnotepadplus  $true -installfirefox $true -installepm $true -epmPath c:\Oracle\Middleware -installFoundation $true -installEssbase $true -installRAF $true -installPlanning $true -installDisclosure $true -installHFM $true -installfdm $true -installProfit $true -installFCM $false -installTax $false -installStrategic $true -dbServer server.domain.com -dbPort 1433 -dbUser hypadmin -dbPassword password -wkspcAdmin admin -wkspcAdminPassword password -weblogicAdmin epm_admin -weblogicPort 7001 -weblogicHostname server.domain.com -wkspcPort 19000 -epmDomain EPMSystem -foundationDB EPMS_FND -epmaDB EPMS_BPM -calcDB EPMS_CAL -essbaseDB EPMS_ESB -rafDB EPMS_RAF -planningDB EPMS_PLN -disclosureDB EPMS_DMA -hfmDB EPMS_HFM -fdmDB EPMS_FDM -profitDB EPMS_PCM -strategic $true -startEPM $true -validate $true
```


### See it in Action

<a href="https://vimeo.com/318823905" target="_blank"><img src="https://kb.chaseelder.com/wp-content/uploads/2019/02/Screen-Shot-2019-02-21-at-4.06.28-PM.png" 
alt="EPM InstallAutomation" width="600" height="350"/></a>

<a href="https://kb.chaseelder.com/epm-silent-install-installautomation/">knowledge Base Article</a>
