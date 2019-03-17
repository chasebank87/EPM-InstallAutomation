# Standalone EPM | Single Server Environment
###### Status: ___Tested Working___

### Steps:
  
  1. Clone repo to a folder on your server __(make sure it is as close to the base drive as possible, or you may get file path too long errors)__
  2. Unblock the __three__ powershell files in the powershell folder. __(Right click file.. Select Properties.. Click unblock)__
  3. Open Powershell as administrator
  4. Set Execution policy to __Unrestricted_
  ```powershell
  Set-ExecutionPolicy Unrestricted
  ```
  5. Browse to the powershell path in the folder you cloned
  ```powershell
  cd c:\EPM\InstallAutomation\Powershell
  ```
  6. To run the script in interactive mode
  ```powershell
  .\start.ps1
  ```
  7. To run the script in silent mode
  * Determine what products you want __(SOA: Tax, and FCM are not supported)__
  * Modify the following command to fit your needs:
```powershell
.\start.ps1 -superSilentAll -installIIS $true -installNetFrame $true -install7zip $true -installnotepadplus  $true -installfirefox $true -installepm $true -epmPath c:\Oracle\Middleware -installFoundation $true -installEssbase $true -installRAF $true -installPlanning $true -installDisclosure $true -installHFM $true -installfdm $true -installProfit $true -installFCM $false -installTax $false -installStrategic $true -dbServer sql.domain.local -dbPort 1433 -dbUser hypadmin -dbPassword Password! -wkspcAdmin admin -wkspcAdminPassword Password! -weblogicAdmin epm_admin -weblogicPort 7001 -weblogicHostname foundation.domain.local -wkspcPort 19000 -epmDomain EPMSystem -foundationDB EPMS_FND -epmaDB EPMS_BPM -calcDB EPMS_CAL -essbaseDB EPMS_ESB -rafDB EPMS_RAF -planningDB EPMS_PLN -disclosureDB EPMS_DMA -hfmDB EPMS_HFM -fdmDB EPMS_FDM -profitDB EPMS_PCM -strategic $true
```
  * If you want to do the install silently, and the configurator interactively use the -superSilentInstall switch instead, and remove all of the config options. Once the install finishes you will be prompted to do the configuration. The command would look like this:
```powershell
.\start.ps1 -superSilentInstall -installIIS $true -installNetFrame $true -install7zip $true -installnotepadplus  $true -installfirefox $true -installepm $true -epmPath c:\Oracle\Middleware -installFoundation $true -installEssbase $true -installRAF $true -installPlanning $true -installDisclosure $true -installHFM $true -installfdm $true -installProfit $true -installFCM $false -installTax $false -installStrategic $true 
```
  * Reference the command line options on the home page of this repo for help
