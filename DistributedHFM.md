
# Distributed HFM | Two Server Environment
___Note: Interactive mode not supported yet for multiple server deployments. Silent only___

___Note: An important concept to know about when doing a distributed silent install of any of the following products is very important: HFM, FDM, Planning..
Since you have to first install, and configure all of the non distributed products on the foundation server, then install and configure the distributed products on 
their respective servers, and finally come back to the foundation server and deploy the distributed applications and reconfigure the webserver. To handle this
procedure there are two command line switches: -firstStage, and -secondStage. -firstStage would onbviously be for the first step on the foundation server, and 
-secondStage would be for the last step on the foundation server. You will not use this switch for the distributed servers.___

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
.\start.ps1 -superSilentAll -install7zip $true -installnotepadplus  $true -installfirefox $true -installepm $true -epmPath c:\Oracle\Middleware -installFoundation $true -installEssbase $false -installRAF $true -installPlanning $false -installDisclosure $false -installHFM $true -installfdm $true -installProfit $false -installFCM $false -installTax $false -installStrategic $false -dbServer sql.domain.local -dbPort 1433 -dbUser hypadmin -dbPassword Password! -wkspcAdmin admin -wkspcAdminPassword Password! -weblogicAdmin epm_admin -weblogicPort 7001 -weblogicHostname foundation.domain.local -wkspcPort 19000 -epmDomain EPMSystem -foundationDB EPMS_FND -calcDB EPMS_CAL -rafDB EPMS_RAF -hfmDB EPMS_HFM -fdmDB EPMS_FDM -strategic $false -distributedHFM -remoteDeployment $false -firstStage
```
  * The difference with this command are the switches -distributedHFM, -remoteDeployment, and -firstStage. If you set -distributedHFM to $true, -remoteDeployment to $false, and -firstStage it will only install ___(HFMWeb, and it won't configure)___ which is what you want to do on the foundation server.
  * If you dont want a product installed outside of HFM you can set the install to $false, and ommit the DB switch for that product. For instance if your client does not need __Essbase__ your command would look like this:
```powershell
.\start.ps1 -superSilentAll -install7zip $true -installnotepadplus  $true -installfirefox $true -installepm $true -epmPath c:\Oracle\Middleware -installFoundation $true -installEssbase $false -installRAF $true -installPlanning $true -installDisclosure $true -installHFM $true -installfdm $true -installProfit $true -installFCM $false -installTax $false -installStrategic $true -dbServer sql.domain.local -dbPort 1433 -dbUser hypadmin -dbPassword Password! -wkspcAdmin admin -wkspcAdminPassword Password! -weblogicAdmin epm_admin -weblogicPort 7001 -weblogicHostname foundation.domain.local -wkspcPort 19000 -epmDomain EPMSystem -foundationDB EPMS_FND -epmaDB EPMS_BPM -calcDB EPMS_CAL -hfmDB EPMS_HFM -rafDB EPMS_RAF -planningDB EPMS_PLN -disclosureDB EPMS_DMA -fdmDB EPMS_FDM -profitDB EPMS_PCM -strategic $true -distributedHFM $true -remoteDeployment $false -firstStage
```
  * Reference the command line options on the home page of this repo for help
  #### HFM Server: (Second)
  1. Clone repo to a folder on your ***HFM Server*** __(make sure it is as close to the base drive as possible, or you may get file path too long errors)__
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
.\start.ps1 -superSilentAll -install7zip $true -installnotepadplus  $true -installfirefox $true -installepm $true -epmPath c:\Oracle\Middleware -installFoundation $true -installEssbase $false -installRAF $false -installPlanning $false -installDisclosure $false -installHFM $true -installfdm $false -installProfit $false -installFCM $false -installTax $false -installStrategic $false -dbServer sql.domain.local -dbPort 1433 -dbUser hypadmin -dbPassword Password! -wkspcAdmin admin -wkspcAdminPassword Password! -weblogicAdmin epm_admin -weblogicPort 7001 -weblogicHostname foundation.domain.local -wkspcPort 19000 -epmDomain EPMSystem -foundationDB EPMS_FND -hfmDB EPMS_HFM -remoteDeployment $true -distributedHFM $true
```
  * The difference with this command from the one we did on the __Foundation Server__ is the -remoteDeployment swich, the ommition of the -firstStage/-secondStage switches, the values we provided for the install switches, and the DB switches we ommited
  * -remoteDeployment __$true__ tells the script that this is a remote server, and only installs __Essbase Server__
  * -firstStage, and -secondStage are ___only___ for the Foundation server.
  * Changing the -install switches to __$false__ tells the script not to install those products
  * Ommiting the different productDB switches tells the script not to try and configure the products we chose not to install

### See the above steps in action:

<a href="https://vimeo.com/323622992" target="_blank"><img src="https://kb.chaseelder.com/wp-content/uploads/2019/03/2019-03-13_21-01-50.png" 
alt="EPM InstallAutomation" width="600" height="350"/></a>


