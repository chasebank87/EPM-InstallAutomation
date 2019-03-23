# Distributed Essbase | Two Server Environment
###### Version 11.1.2.4.900
___Note: Interactive mode not supported yet for multiple server deployments. Silent only___

###### Status: ___Tested Working___

### Steps:
  #### Foundation Server: (First)
  1. Clone repo to a folder on your ***Foundation Server*** __(make sure it is as close to the base drive as possible, or you may get file path too long errors)__
  2. Unblock the __three__ powershell files in the powershell folder. __(Right click file.. Select Properties.. Click unblock)__
  3. Open Powershell as administrator
  4. Set Execution policy to __Unrestricted__
  ```powershell
  Set-ExecutionPolicy Unrestricted
  ```
  5. Browse to the powershell path in the folder you cloned
  ```powershell
  cd c:\EPM\InstallAutomation\Powershell
  ```
  6. To run the script in silent mode
  * Determine what products you want __(SOA: Tax, and FCM are not supported)__
  * Modify the following command to fit your needs:
```powershell
.\start.ps1 -superSilentAll -installIIS $true -installNetFrame $true -install7zip $true -installnotepadplus  $true -installfirefox $true -installepm $true -epmPath c:\Oracle\Middleware -installFoundation $true -installEssbase $true -installFR $true -installPlanning $true -installfdm $true -dbServer sql.domain.local -dbPort 1433 -dbUser hypadmin -dbPassword Password! -wkspcAdmin admin -wkspcAdminPassword Password! -weblogicAdmin epm_admin -weblogicPort 7001 -weblogicHostname foundation.domain.local -wkspcPort 19000 -epmDomain EPMSystem -foundationDB EPMS_FND -epmaDB EPMS_BPM -calcDB EPMS_CAL -essbaseDB EPMS_ESB -frDB EPMS_HRF -planningDB EPMS_PLN -fdmDB EPMS_FDM -strategic $false -distributedEssbase $true -remoteDeployment $false
```
  * The difference with this command are the switches -distributedEssbase, and -remoteDeployment. If you set -distributedEssbase to $true, and -remoteDeployment to $false it will only install ___(EAS, Studio, Provider)___ which is what you want to do on the foundation server.
  * If you dont want a product installed outside of Essbase you can set the install to $false, and ommit the DB switch for that product. For instance if your client does not need __HFM__ your command would look like this:
```powershell
.\start.ps1 -superSilentAll -installIIS $true -installNetFrame $true -install7zip $true -installnotepadplus  $true -installfirefox $true -installepm $true -version900 -epmPath c:\Oracle\Middleware -installFoundation $true -installEssbase $true -installFR $true -installPlanning $true -installfdm $true -dbServer sql.domain.local -dbPort 1433 -dbUser hypadmin -dbPassword Password! -wkspcAdmin admin -wkspcAdminPassword Password! -weblogicAdmin epm_admin -weblogicPort 7001 -weblogicHostname foundation.domain.local -wkspcPort 19000 -epmDomain EPMSystem -foundationDB EPMS_FND -epmaDB EPMS_BPM -calcDB EPMS_CAL -essbaseDB EPMS_ESB -frDB EPMS_HRF -planningDB EPMS_PLN -fdmDB EPMS_FDM -strategic $false -distributedEssbase $true -remoteDeployment $false 
```
  * Reference the command line options on the home page of this repo for help
  7. Start __Weblogic Admin Server__ (VERY IMPORTANT)
  #### Essbase Server: (Second)
  1. Clone repo to a folder on your ***Essbase Server*** __(make sure it is as close to the base drive as possible, or you may get file path too long errors)__
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
  6. To run the script in silent mode
  * Determine what products you want __(SOA: Tax, and FCM are not supported)__ In the most common scenario only Essbase and Foundation would be installed on this standalone Essbase server.
  * Modify the following command to fit your needs: 
```powershell
.\start.ps1 -superSilentAll -installNetFrame $true -install7zip $true -installnotepadplus  $true -installfirefox $true -installepm $true -version900 -epmPath c:\Oracle\Middleware -installFoundation $true -installEssbase $true -dbServer sql.domain.local -dbPort 1433 -dbUser hypadmin -dbPassword Password! -wkspcAdmin admin -wkspcAdminPassword Password! -weblogicAdmin epm_admin -weblogicPort 7001 -weblogicHostname foundation.domain.local -wkspcPort 19000 -epmDomain EPMSystem -foundationDB EPMS_FND -essbaseDB EPMS_ESB -strategic $false -distributedEssbase $true -remoteDeployment $true
```
  * The difference with this command from the one we did on the __Foundation Server__ is the -remoteDeployment swich, the values we provided for the install switches, and the DB switches we ommited
  * -remoteDeployment __$true__ tells the script that this is a remote server, and only installs __Essbase Server__
  * Changing the -install switches to __$false__ tells the script not to install those products
  * Ommiting the different productDB switches tells the script not to try and configure the products we chose not to install

### See the above steps in action:

<a href="https://vimeo.com/323622992" target="_blank"><img src="https://kb.chaseelder.com/wp-content/uploads/2019/03/2019-03-13_21-01-50.png" 
alt="EPM InstallAutomation" width="600" height="350"/></a>


