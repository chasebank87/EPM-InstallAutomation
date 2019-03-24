
# Distributed HFM, FDM, ESB, PLN | Five Server Environment
* Version: ___11.1.2.4___
* Status: ___Working___
* Time: ___1 Hour___
* Note: ___Interactive mode not supported yet for multiple server deployments. Silent only___
* Note: ___Instead of cloaning the repo to every server and downloading the files fresh, you can just map a drive to the repo on the first server. Then browse to that mapped drive in powershell to the powershell folder and run everything as normal.

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
.\start.ps1 -superSilentAll -installIIS $true -installNetFrame $true -install7zip $true -installnotepadplus  $true -installfirefox $true -installepm $true -epmPath c:\Oracle\Middleware -installFoundation $true -installEssbase $true -installRAF $true -installPlanning $true -installfdm $true -dbServer sql.domain.local -dbPort 1433 -dbUser hypadmin -dbPassword Password! -wkspcAdmin admin -wkspcAdminPassword Password! -weblogicAdmin epm_admin -weblogicPort 7001 -weblogicHostname foundation.domain.local -wkspcPort 19000 -epmDomain EPMSystem -epmaDB EPMS_BPM -foundationDB EPMS_FND -calcDB EPMS_CAL -hfmDB EPMS_HFM -rafDB EPMS_RAF -fdmDB EPMS_FDM -planningDB EPMS_PLN -essbaseDB EPMS_ESB -strategic $false -distributedEssbase $true -distributedPlanning $true -distributedHFM $true -distributedFDM $true -remoteDeployment $false
```
  * The difference with this command are the switches -distributedPlanning, -distributedEssbase,  and -remoteDeployment. If you set -distributedPlanning, and -distributedEssbase to $true, and -remoteDeployment to $false, utility will only install ___(Planning, EAS, Studio, and Provider services but it won't configure Planning)___ which is what you want to do on the foundation server.
  * Reference the command line options on the home page of this repo for help
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
  * Determine what products you want __(SOA: Tax, and FCM are not supported)__ In the most common scenario only Essbase and Foundation would be installed on this remote Essbase server.
  * Modify the following command to fit your needs: 
```powershell
.\start.ps1 -superSilentAll -installNetFrame $true -install7zip $true -installnotepadplus  $true -installfirefox $true -installepm $true -epmPath c:\Oracle\Middleware -installFoundation $true -installEssbase $true -dbServer sql.domain.local -dbPort 1433 -dbUser hypadmin -dbPassword Password! -wkspcAdmin admin -wkspcAdminPassword Password! -weblogicAdmin epm_admin -weblogicPort 7001 -weblogicHostname foundation.domain.local -wkspcPort 19000 -epmDomain EPMSystem -foundationDB EPMS_FND -essbaseDB EPMS_ESB -strategic $false -distributedEssbase $true -remoteDeployment $true
```
  * The difference with this command from the one we did on the __Foundation Server__ is the -remoteDeployment swich, the values we provided for the install switches, and the DB switches we ommited
  * -remoteDeployment __$true__ tells the script that this is a remote server, and only installs __Essbase Server__
  * Changing the -install switches to __$false__ tells the script not to install those products
  * Ommiting the different productDB switches tells the script not to try and configure the products we chose not to install
  #### Planning Server: (Third)
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
  * Determine what products you want __(SOA: Tax, and FCM are not supported)__ In the most common scenario only Planning and Foundation would be installed on this remote server.
  ```
.\start.ps1 -superSilentAll -installNetFrame $true -install7zip $true -installnotepadplus  $true -installfirefox $true -installepm $true -epmPath c:\Oracle\Middleware -installFoundation $true -installPlanning $true -dbServer sql.domain.local -dbPort 1433 -dbUser hypadmin -dbPassword Password! -wkspcAdmin admin -wkspcAdminPassword Password! -weblogicAdmin epm_admin -weblogicPort 7001 -weblogicHostname foundation.domain.local -wkspcPort 19000 -epmDomain EPMSystem -foundationDB EPMS_FND -planningDB EPMS_PLN -strategic $false -distributedPlanning $true -remoteDeployment $true  
  ```
  * -remoteDeployment __$true__ tells the script that this is a remote server, and only installs __Planning Server__
  * Changing the -install switches to __$false__ tells the script not to install those products
  * Ommiting the different productDB switches tells the script not to try and configure the products we chose not to install
  #### HFM Server: (Fourth)
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
  * Determine what products you want __(SOA: Tax, and FCM are not supported)__ In the most common scenario only Planning and Foundation would be installed on this remote server.
  ```
  start.ps1 -superSilentAll -installNetFrame $true -install7zip $true -installnotepadplus  $true -installfirefox $true -installepm $true -epmPath c:\Oracle\Middleware -installFoundation $true -installHFM $true -dbServer sql.domain.local -dbPort 1433 -dbUser hypadmin -dbPassword Password! -wkspcAdmin admin -wkspcAdminPassword Password! -weblogicAdmin epm_admin -weblogicPort 7001 -weblogicHostname foundation.domain.local -wkspcPort 19000 -epmDomain EPMSystem -foundationDB EPMS_FND -hfmDB EPMS_HFM -strategic $false -distributedHFM $true -remoteDeployment $true  
  ```
  #### FDM Server: (Fifth)
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
  * Determine what products you want __(SOA: Tax, and FCM are not supported)__ In the most common scenario only Planning and Foundation would be installed on this remote server.
  ```
  start.ps1 -superSilentAll -installNetFrame $true -install7zip $true -installnotepadplus  $true -installfirefox $true -installepm $true -epmPath c:\Oracle\Middleware -installFoundation $true -installFDM $true -installHFM $true -dbServer sql.domain.local -dbPort 1433 -dbUser hypadmin -dbPassword Password! -wkspcAdmin admin -wkspcAdminPassword Password! -weblogicAdmin epm_admin -weblogicPort 7001 -weblogicHostname foundation.domain.local -wkspcPort 19000 -epmDomain EPMSystem -foundationDB EPMS_FND -fdmDB EPMS_FDM -strategic $false -distributedFDM $true -remoteDeployment $true  
  ```
  #### Foundation Server: (Sixth)
  1. Run the configuration GUI
    * Start Menu
  2. Select Configure Database, and Deploy to Application server for all Distributed Products
  3. Select Configure Web Server under Foundation
  4. Click next until completion
  
  ![alt text](https://github.com/chasebank87/EPMSilent-InstallAutomation/blob/master/Help/deployPlanning.gif)
  
  
### See the above steps in action:


