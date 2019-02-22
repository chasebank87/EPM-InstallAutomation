#region set mainVariables and mainFunctions

    . 'C:\InstallAutomation\Variables\mainVariables.ps1'
    . 'C:\InstallAutomation\Functions\mainfunctions.ps1'

#endregion

#region confirm install path

    if(!$epmInstallPath){
        $installedSoftware = Get-Software | Where-Object {$_.DisplayName -like "Oracle EPM*"}
        $epmInstallPath = $installedSoftware.UninstallString.Substring(0,3)
        $epmInstallPath = Get-ChildItem $epmInstallPath\*\,\*\* -ErrorAction SilentlyContinue | Where-Object {$_.PSIsContainer -eq $true -and $_.Name -match "Middleware"}
        if($epmInstallPath.Count -ge 1) {
            $epmInstallPath = $epmInstallPath.FullName 
        }
        else {
            $epmInstallPath = Read-Host "Can't find your EPM install path. Please type it in now."
        }
    }

#endregion

#region user input for configuration
    
    Write-Host "========= EPM Configuration ========="
    Write-Host "Would you like to configure EPM now?"
    Write-Host "Please note that Financial Close, and" -ForegroundColor Yellow
    Write-Host "Tax Management are not currently supported." -ForegroundColor Yellow
    Write-Host "If you need these products please choose no." -ForegroundColor Yellow
    Write-Host "1. Yes"
    Write-Host "2. No"
    Write-Host "3. Quit"
    Write-Host "========================================"
    while($break -ne 'break'){
        switch($inp = Read-Host -Prompt "Select"){
            1 {
                Write-Host "Starting TEPM Configuration" -ForegroundColor Green
                Write-Host ""
                $inputConfig = 1
                $break = 'break'
                Break
                }
            2 {
                Write-Host "Skipping EPM Configuration" -ForegroundColor Green
                Write-Host ""
                $break = 'break'
                $inputConfig = 2
                Break
            }
            3 {
                Write-Host "Quitting" -ForegroundColor Red
                Sleep -Seconds 3
                Exit
                }
            default {
                Write-Host "Invalid Selection. Try Again." -ForegroundColor Red
                }
       }
    }
  
    if($break){Clear-Variable break}

#endregion

#region configuration details

    if($inputConfig -eq 1) {
        Write-Host "========= Recommended Oracle Config ========="
        Write-Host "Would you like to use recommended oracle"
        Write-Host "settings for everything except for normally"
        Write-Host "customized items like DB username and passwords."
        Write-Host "1. Yes"
        Write-Host "2. No"
        Write-Host "3. Quit"
        Write-Host "============================================="
        while($break -ne 'break'){
            switch($inp = Read-Host -Prompt "Select"){
                1 {
                    Write-Host "Configuing EPM with Recommended Options" -ForegroundColor Green
                    Write-Host ""
                    $inputRecommended = 1
                    $break = 'break'
                    Break
                    }
                2 {
                    Write-Host "Starting 100% Custom Configuration" -ForegroundColor Green
                    Write-Host ""
                    $break = 'break'
                    $inputRecommended = 2
                    Break
                }
                3 {
                    Write-Host "Quitting" -ForegroundColor Red
                    Sleep -Seconds 3
                    Exit
                    }
                default {
                    Write-Host "Invalid Selection. Try Again." -ForegroundColor Red
                    }
           }
        }
  
    }

    if($break){Clear-Variable break}

    #region prompt user that 100% customization is not currently supported

        if($inputConfig -eq 1) {
            if ($inputRecommended -eq 2) {
                Write-Host "=========== 100% Custom Configuration ==========="
                Write-Host "100% Custom configuration is not currently" -ForegroundColor Yellow
                Write-Host "supported by this installer. Configuring" -ForegroundColor Yellow
                Write-Host "with heavy customizaton with the default" -ForegroundColor Yellow
                Write-Host "configuration utility would be just as fast " -ForegroundColor Yellow
                Write-Host "or faster. Since the potential time savings" -ForegroundColor Yellow
                Write-Host "is so low the time was not spent on this feature." -ForegroundColor Yellow
                Write-Host "Would you like to do a recommended configuration"
                Write-Host "instead?"
                Write-Host "1. Yes"
                Write-Host "2. No"
                Write-Host "3. Quit"
                Write-Host "================================================="
                while($break -ne 'break'){
                    switch($inp = Read-Host -Prompt "Select"){
                        1 {
                            Write-Host "Configuing EPM with Recommended Options" -ForegroundColor Green
                            Write-Host ""
                            $inputCustom = 1
                            $break = 'break'
                            Break
                            }
                        2 {
                            Write-Host "Skipping Configuration" -ForegroundColor Green
                            Write-Host ""
                            $break = 'break'
                            $inputCustom = 2
                            Break
                        }
                        3 {
                            Write-Host "Quitting" -ForegroundColor Red
                            Sleep -Seconds 3
                            Exit
                            }
                        default {
                            Write-Host "Invalid Selection. Try Again." -ForegroundColor Red
                            }
                   }
                }
            }
        }

    if($break){Clear-Variable break}

    #endregion
    
    #region ask to open default configurator for user

        if($inputConfig -eq 1) {
            if ($inputRecommended -eq 2) {
                if ($inputCustom -eq 2) {
                    Write-Host "============= Default Configurator ============="
                    Write-Host "You have declined to configure EPM. Would you like"
                    Write-Host "me to open the default configurator for you now?"
                    Write-Host "1. Yes"
                    Write-Host "2. No"
                    Write-Host "3. Quit"
                    Write-Host "================================================"
                    while($break -ne 'break'){
                        switch($inp = Read-Host -Prompt "Select"){
                            1 {
                                Write-Host "Opening Default Configurator" -ForegroundColor Green
                                Write-Host ""
                                $inputConfigurator = 1
                                $break = 'break'
                                Break
                                }
                            2 {
                                Write-Host "Exiting" -ForegroundColor Green
                                Write-Host ""
                                $break = 'break'
                                $inputConfigurator = 2
                                Sleep -Seconds 3
                                Exit
                            }
                            3 {
                                Write-Host "Quitting" -ForegroundColor Red
                                Sleep -Seconds 3
                                Exit
                                }
                            default {
                                Write-Host "Invalid Selection. Try Again." -ForegroundColor Red
                                }
                       }
                    }
                }
            }
        }

        if($break){Clear-Variable break}

    #endregion

    #region start default configurator
        
        if($inputConfigurator -eq 1) {
            Start-Process -FilePath "$($epmInstallPath)\EPMSystem11R1\common\config\11.1.2.0\configtool.bat" -Verb RunAs
            Read-Host "Press Enter to Exit"
        }

    #endregion

    #region user input for recommended configuration

        if($inputRecommended -eq 1) {
        Write-Host "========= Recommended Oracle Config ========="
        Write-Host "Do you use Oracle DB or Microsoft SQL?"
        #Write-Host ""
        #Write-Host ""
        Write-Host "1. Oracle DB (Not Supported)"
        Write-Host "2. Microsoft SQL"
        Write-Host "3. Quit"
        Write-Host "============================================="
        while($break -ne 'break'){
            switch($inp = Read-Host -Prompt "Select"){
                # 1 {
                #   Write-Host "Configuing EPM with Oracle DB" -ForegroundColor Green
                #   Write-Host ""
                #   $inputDBSoftware = 1
                #  $break = 'break'
                #  Break
                #  }
                2 {
                    Write-Host "Configuring EPM with Microsoft SQL" -ForegroundColor Green
                    Write-Host ""
                    $break = 'break'
                    $inputDBSoftware = 2
                    Break
                }
                3 {
                    Write-Host "Quitting" -ForegroundColor Red
                    Sleep -Seconds 3
                    Exit
                    }
                default {
                    Write-Host "Invalid Selection. Try Again." -ForegroundColor Red
                    }
                }
            }
  
        }

        if($break){Clear-Variable break}

        if($inputRecommended -eq 1) {
            
            while($testDBServer -ne $true){
            Write-Host "========= Database Hostname and Port ========="
            Write-Host "What is your Database Server Hostname (fqdn)?"
            Write-Host ""
            #Write-Host ""
            Write-Host "Type Quit to Exit the Installer" -ForegroundColor Yellow
            Write-Host "============================================"
            $inputDBHostname = Read-Host
            if ($inputDBHostname -like "*quit*") {Exit}
            Write-Host ""
            Write-Host ""
            Write-Host "What is your Database Server Port?"
            Write-Host ""
            Write-Host "Type Quit to Exit the Installer" -ForegroundColor Yellow
            Write-Host "============================================="
            $inputDBPort = Read-Host
            
            if ($inputDBPort -like "*quit*") {Exit}
                $testDBServer = Test-NetConnection -ComputerName $inputDBHostname -Port $inputDBPort -InformationLevel Quiet
                if ($testDBServer -eq $false) {
                    Write-Host "Database Server is unreachable. Please try again." -ForegroundColor Red
                }
  
            }
            if ($testDBServer -eq $true) {
                Write-Host "Database Server is reachable, continuing" -ForegroundColor Green
            }
        }

        if($break){Clear-Variable break}
        if($testDBServer){Clear-Variable testDBServer}

        if($inputRecommended -eq 1) {
            
            
            Write-Host "========= Database Username and Password ========="
            Write-Host "What is your Database Server Username?"
            Write-Host ""
            #Write-Host ""
            Write-Host "Type Quit to Exit the Installer" -ForegroundColor Yellow
            $inputDBUsername = Read-Host
            if ($inputDBUsername -like "*quit*") {Exit}
            Write-Host ""
            Write-Host ""
            Write-Host "What is your Database Username Password?"
            Write-Host ""
            Write-Host "Type Quit to Exit the Installer" -ForegroundColor Yellow
            $inputDBUserPass = Read-Host
            Write-Host "=================================================="
            if ($inputDBUserPass -like "*quit*") {Exit}
              }
        

        if($break){Clear-Variable break}
        
         if($inputRecommended -eq 1) {
            Write-Host "============= Workspace Admin =============="
            Write-Host "What do you want your workspace admin username"
            Write-Host "to be?"
            Write-Host ""
            #Write-Host ""
            Write-Host "Type Quit to Exit the Installer" -ForegroundColor Yellow
            $inputWrkspcAdmin = Read-Host
            Write-Host "============================================"
            if ($inputWrkspcAdmin -like "*quit*") {Exit}
            Write-Host ""
            Write-Host ""
            Write-Host "What do you want your workspace admin password"
            Write-Host "to be?"
            Write-Host ""
            Write-Host "Type Quit to Exit the Installer" -ForegroundColor Yellow
            $inputWrkspcPassword = Read-Host
            Write-Host "============================================"
            if ($inputWrkspcPassword -like "*quit*") {Exit}
            
        }

        if($break){Clear-Variable break}
        Write-Host ""
        if($inputRecommended -eq 1) {
            Write-Host "============== Weblogic Admin ==============="
            Write-Host "What do you want your weblogic admin username"
            Write-Host "to be?"
            Write-Host ""
            Write-Host "Type Quit to Exit the Installer" -ForegroundColor Yellow
            Write-Host "============================================"
            $inputWeblogicAdmin = Read-Host
            if ($inputWeblogicAdmin -like "*quit*") {Exit}
            
            
        }

        if($break){Clear-Variable break}
        Write-Host ""
        if($inputRecommended -eq 1) {
            Write-Host "============== EPM Domain ==============="
            Write-Host "What do you want your EPM Domain to be?"
            Write-Host ""
            #Write-Host ""
            Write-Host "Type Quit to Exit the Installer" -ForegroundColor Yellow
            Write-Host "============================================"
            $inputEPMDomain = Read-Host
            if ($inputEPMDomain -like "*quit*") {Exit}
            
            
        }

        if($break){Clear-Variable break}
        Write-Host ""
        if($inputRecommended -eq 1) {
            Write-Host "============== Workspace Port ==============="
            Write-Host "What do you want your Workspace port to be?"
            Write-Host ""
            #Write-Host ""
            Write-Host "Type Quit to Exit the Installer" -ForegroundColor Yellow
            Write-Host "============================================"
            $inputWrkspcPort = Read-Host
            if ($inputWrkspcPort -like "*quit*") {Exit}
            
            
        }

        if($break){Clear-Variable break}
        Write-Host ""
        if($inputRecommended -eq 1) {
            Write-Host "============== Weblogic Port ==============="
            Write-Host "What do you want your Weblogic port to be?"
            Write-Host ""
            #Write-Host ""
            Write-Host "Type Quit to Exit the Installer" -ForegroundColor Yellow
            Write-Host "============================================"
            $inputWeblogicPort = Read-Host
            if ($inputWeblogicPort -like "*quit*") {Exit}
            
            
        }

        if($break){Clear-Variable break}
        Write-Host ""
        if($inputRecommended -eq 1) {
            Write-Host "========== Email Configuration =========="
            Write-Host "Would you like to setup email for EPM?"
            #Write-Host ""
            Write-Host "1. Yes"
            Write-Host "2. No"
            Write-Host "3. Quit"
            Write-Host "========================================="
            while($break -ne 'break'){
                switch($inp = Read-Host -Prompt "Select"){
                    1 {
                        Write-Host "Starting Email Configuration" -ForegroundColor Green
                        Write-Host ""
                        $inputEmailConfig = 1
                        $break = 'break'
                        Break
                        }
                    2 {
                        Write-Host "Skipping Email Configuration" -ForegroundColor Green
                        Write-Host ""
                        $break = 'break'
                        $inputEmailConfig = 2
                        Break
                    }
                    3 {
                        Write-Host "Quitting" -ForegroundColor Red
                        Sleep -Seconds 3
                        Exit
                        }
                    default {
                        Write-Host "Invalid Selection. Try Again." -ForegroundColor Red
                        }
               }
            }
       }
  
        if($break){Clear-Variable break}
        Write-Host ""
        if($inputEmailConfig -eq 1) {
            Write-Host "============== Email Address ==============="
            Write-Host "What do you want your EPM Admin Email address"
            Write-Host "to be?"
            Write-Host ""
            Write-Host "Type Quit to Exit the Installer" -ForegroundColor Yellow
            Write-Host "============================================"
            $inputEmailAddress = Read-Host
            if ($inputEmailAddress -like "*quit*") {Exit}
            
            
        }

        if($break){Clear-Variable break}
        Write-Host ""
        if($inputEmailConfig -eq 1) {

            while($testSMTPServer -ne $true){
            Write-Host "================ SMTP Server ================="
            Write-Host "What is the hostname (fqdn) of your SMTP server?"
            Write-Host ""
            #Write-Host ""
            Write-Host "Type Quit to Exit the Installer" -ForegroundColor Yellow
            Write-Host "============================================="
            $inputSMTPServer = Read-Host
            if ($inputSMTPServer -like "*quit*") {Exit}
            Write-Host ""
            Write-Host ""
            Write-Host "What is your SMTP Server Port?"
            Write-Host ""
            Write-Host "Type Quit to Exit the Installer" -ForegroundColor Yellow
            Write-Host "============================================="
            $inputSMTPPort = Read-Host
            if ($inputSMTPPort -like "*quit*") {Exit}
                $testSMTPServer = Test-NetConnection -ComputerName $inputSMTPServer -Port $inputSMTPPort -InformationLevel Quiet
                if ($testSMTPServer -eq $false) {
                    Write-Host "Database Server is unreachable. Please try again." -ForegroundColor Red
                }
  
            }
            if ($testSMTPServer -eq $true) {
                Write-Host "Database Server is reachable, continuing" -ForegroundColor Green
            }
        }

        if($break){Clear-Variable break}
        if($testSMTPServer){Clear-Variable testSMTPServer}
        Write-Host ""
        if($inputEmailConfig -eq 1) {
            Write-Host "========== Email Authentication =========="
            Write-Host "Does your SMTP Server require authentication?"
            #Write-Host ""
            Write-Host "1. Yes"
            Write-Host "2. No"
            Write-Host "3. Quit"
            Write-Host "========================================="
            while($break -ne 'break'){
                switch($inp = Read-Host -Prompt "Select"){
                    1 {
                        Write-Host "Starting Email Authentication Configuration" -ForegroundColor Green
                        Write-Host ""
                        $inputEmailAuthConfig = 1
                        $emailAuth = 'true'
                        $break = 'break'
                        Break
                        }
                    2 {
                        Write-Host "Skipping Email Authentication Configuration" -ForegroundColor Green
                        Write-Host ""
                        $break = 'break'
                        $inputEmailAuthConfig = 2
                        $emailAuth = 'false'
                        Break
                    }
                    3 {
                        Write-Host "Quitting" -ForegroundColor Red
                        Sleep -Seconds 3
                        Exit
                        }
                    default {
                        Write-Host "Invalid Selection. Try Again." -ForegroundColor Red
                        }
               }
            }
        }

        if($break){Clear-Variable break}
        Write-Host ""
        if($inputEmailConfig -eq 1) {
            if($inputEmailAuthConfig -eq 1) {
                Write-Host "============ Email Authentication Encryption ============"
                Write-Host "Does your SMTP Server require SSL? TLS is not supported"
                #Write-Host ""
                Write-Host "1. Yes"
                Write-Host "2. No"
                Write-Host "3. Quit"
                Write-Host "=========================================================="
                while($break -ne 'break'){
                    switch($inp = Read-Host -Prompt "Select"){
                        1 {
                            Write-Host "Configuring Email with SSL" -ForegroundColor Green
                            Write-Host ""
                            $inputEmailAuthSSL = 'true'
                            $break = 'break'
                            Break
                            }
                        2 {
                            Write-Host "Continuing Email Authentication without SSL" -ForegroundColor Green
                            Write-Host ""
                            $break = 'break'
                            $inputEmailAuthSSL = 'false'
                            Break
                        }
                        3 {
                            Write-Host "Quitting" -ForegroundColor Red
                            Sleep -Seconds 3
                            Exit
                            }
                        default {
                            Write-Host "Invalid Selection. Try Again." -ForegroundColor Red
                            }
                        }
                    }
                }
            }

        if($break){Clear-Variable break}
        Write-Host ""
        if($inputEmailConfig -eq 1) {
            if($inputEmailAuthConfig -eq 1) {
                Write-Host "================ SMTP USername ================="
                Write-Host "What is your SMTP Username?"
                Write-Host ""
                #Write-Host ""
                Write-Host "Type Quit to Exit the Installer" -ForegroundColor Yellow
                Write-Host "=============================================="
                $inputSMTPUser = Read-Host
                if ($inputSMTPUser -like "*quit*") {Exit}
                Write-Host ""
                Write-Host ""
                Write-Host "What is your SMTP User Password?"
                Write-Host ""
                Write-Host "Type Quit to Exit the Installer" -ForegroundColor Yellow
                Write-Host "=============================================="
                $inputSMTPPassword = Read-Host
                if ($inputSMTPPassword -like "*quit*") {Exit}
              
               
            }

        }

        if($break){Clear-Variable break}
        Write-Host ""
        if ($foundationSilent -ne $null){
            if($inputRecommended -eq 1) {
                Write-Host "============== Foundation DB Name ==============="
                Write-Host "What is your Foundation Database name?"
                Write-Host ""
                #Write-Host ""
                Write-Host "Type Quit to Exit the Installer" -ForegroundColor Yellow
                Write-Host "================================================="
                $inputFNDDB = Read-Host
                if ($inputFNDDB -like "*quit*") {Exit}
                
            
            }
        }

        if($break){Clear-Variable break}
        Write-Host ""
        if($inputRecommended -eq 1) {
            Write-Host "============== EPMA DB Name ==============="
            Write-Host "What is your EPMA Database name? Leave Empty"
            Write-Host "to skip this config."
            Write-Host ""
            Write-Host "Type Quit to Exit the Installer" -ForegroundColor Yellow
            Write-Host "==========================================="
            $inputEPMADB = Read-Host
            if ($inputEPMADB -like "*quit*") {Exit}
            
            
        }

        if($break){Clear-Variable break}
        Write-Host ""
        if($essbaseSilent -ne $null) {
            if($inputRecommended -eq 1) {
                Write-Host "============== Essbase Studio DB Name ==============="
                Write-Host "What is your Essbase Studio Database name?"
                Write-Host ""
                #Write-Host ""
                Write-Host "Type Quit to Exit the Installer" -ForegroundColor Yellow
                Write-Host "====================================================="
                $inputESBDB = Read-Host
                if ($inputESBDB -like "*quit*") {Exit}
                
            
            }
        }
        
        if($break){Clear-Variable break}
        Write-Host ""
        if($inputRecommended -eq 1) {
            Write-Host "============== CALC DB Name ==============="
            Write-Host "What is your CALC Manager Database name? Leave"
            Write-Host "empty to skip this config."
            Write-Host ""
            Write-Host "Type Quit to Exit the Installer" -ForegroundColor Yellow
            Write-Host "==========================================="
            $inputCALCDB = Read-Host
            if ($inputCALCDB -like "*quit*") {Exit}
            
            
        }

        if($break){Clear-Variable break}
        Write-Host ""
        if($disclosureSilent -ne $null) {
            if($inputRecommended -eq 1) {
                Write-Host "============== DISCLOSURE DB Name ==============="
                Write-Host "What is your Disclosure Database name?"
                Write-Host ""
                #Write-Host ""
                Write-Host "Type Quit to Exit the Installer" -ForegroundColor Yellow
                Write-Host "================================================="
                $inputDisclosureDB = Read-Host
                if ($inputDisclosureDB -like "*quit*") {Exit}
                
            
            }
        }

        if($break){Clear-Variable break}
        Write-Host ""
        if($essbaseSilent -ne $null) {
            if($inputRecommended -eq 1) {
                Write-Host "============== EAS DB Name ==============="
                Write-Host "What is your EAS Database name? "
                Write-Host "Commonly that same as Essbase Studio."
                Write-Host ""
                Write-Host "Type Quit to Exit the Installer" -ForegroundColor Yellow
                Write-Host "=========================================="
                $inputEASDB = Read-Host
                if ($inputEASDB -like "*quit*") {Exit}
                
            
            }
        }

        if($break){Clear-Variable break}
        Write-Host ""
        if($planningSilent -ne $null) {
            if($inputRecommended -eq 1) {
                Write-Host "============== PLANNING DB Name ==============="
                Write-Host "What is your Planning Database name? "
                Write-Host ""
                #Write-Host ""
                Write-Host "Type Quit to Exit the Installer" -ForegroundColor Yellow
                Write-Host "==============================================="
                $inputPLNDB = Read-Host
                if ($inputPLNDB -like "*quit*") {Exit}
                
            
            }
        }

        if($break){Clear-Variable break}
        Write-Host ""
        if($profitSilent -ne $null) {
            if($inputRecommended -eq 1) {
                Write-Host "============== PROFIT DB Name ==============="
                Write-Host "What is your Profit Database name? "
                Write-Host ""
                #Write-Host ""
                Write-Host "Type Quit to Exit the Installer" -ForegroundColor Yellow
                Write-Host "============================================="
                $inputProfitDB = Read-Host
                if ($inputProfitDB -like "*quit*") {Exit}
                
            
            }
        }

        if($break){Clear-Variable break}
        Write-Host ""
        if($rafSilent -ne $null) {
            if($inputRecommended -eq 1) {
                Write-Host "============== RAF DB Name ==============="
                Write-Host "What is your RAF Database name? "
                Write-Host ""
                #Write-Host ""
                Write-Host "Type Quit to Exit the Installer" -ForegroundColor Yellow
                Write-Host "=========================================="
                $inputRAFDB = Read-Host
                if ($inputRAFDB -like "*quit*") {Exit}
                
            
            }
        }

        if($break){Clear-Variable break}
        Write-Host ""
        if($fdmSilent -ne $null) {
            if($inputRecommended -eq 1) {
                Write-Host "============== FDM DB Name ==============="
                Write-Host "What is your FDM Database name? "
                Write-Host ""
                #Write-Host ""
                Write-Host "Type Quit to Exit the Installer" -ForegroundColor Yellow
                Write-Host "=========================================="
                $inputFDMDB = Read-Host
                if ($inputFDMDB -like "*quit*") {Exit}
                
            
            }
        }

        if($break){Clear-Variable break}
        Write-Host ""
        if($hfmSilent -ne $null) {
            if($inputRecommended -eq 1) {
                Write-Host "============== HFM DB Name ==============="
                Write-Host "What is your HFM Database name? "
                Write-Host ""
                #Write-Host ""
                Write-Host "Type Quit to Exit the Installer" -ForegroundColor Yellow
                Write-Host "=========================================="
                $inputHFMDB = Read-Host
                if ($inputFDMDB -like "*quit*") {Exit}
                
            
            }
        }

        if($break){Clear-Variable break}
    #endregion

#endregion

#region set variables

    $password = $inputWrkspcPassword
    $wlPort = $inputWeblogicPort
    $wlAdmin = $inputWeblogicAdmin
    $epmDomain = $inputEPMDomain
    $email = $inputEmailAddress
    $workspaceAdmin = $inputWrkspcAdmin
    $workspacePort = $inputWrkspcPort
    $smtpAuth = $emailAuth
    $smtpSSL = $inputEmailAuthSSL
    $smtpServer = $inputSMTPServer
    $smtpPort = $inputSMTPPort
    $smtpPassword = $inputSMTPPassword
    $smtpUsername = $inputSMTPUser
    $dbServer = $inputDBHostname
    $dbServerPort = $inputDBPort
    $dbPassword = $inputDBUserPass
    $dbUser = $inputDBUsername
    $foundationDB = $inputFNDDB
    $bpmaDB = $inputEPMADB
    $esbDB = $inputESBDB
    $calcDB = $inputCALCDB
    $disclosureDB = $inputDisclosureDB
    $easDB = $inputEASDB
    $plnDB = $inputPLNDB
    $profDB = $inputProfitDB
    $rafDB = $inputRAFDB
    $fdmDB = $inputFDMDB
    $hfmDB = $inputHFMDB

    #region configure EPM variables

    $fndConfigureSilent = "<product productXML=""Foundation"">
    <tasks>
      <task>applicationServerDeployment</task>
      <task>editLWAConfiguration</task>
      <task>FndCommonSetting</task>
      <task>preConfiguration</task>
      <task>relationalStorageConfiguration</task>
      <task>WebServerConfiguration</task>
    </tasks>
    <bean name=""main"">
      <bean name=""applicationServerDeployment"">
        <bean name=""WebLogic 10"">
          <property name=""adminHost"">$($fqdn)</property>
          <property name=""adminPassword"">$($password)</property>
          <property name=""adminPort"">$($wlPort)</property>
          <property name=""adminUser"">$($wlAdmin)</property>
          <beanList name=""applications"">
            <listItem>
              <bean>
                <property name=""compactPort"">9000</property>
                <property name=""compactServerName"">EPMServer</property>
                <property name=""compactSslPort"">9443</property>
                <property name=""component"">Shared Services</property>
                <beanList name=""contexts"">
                  <listItem>
                    <property>interop</property>
                  </listItem>
                </beanList>
                <property name=""enable"">true</property>
                <property name=""port"">28080</property>
                <property name=""serverName"">FoundationServices</property>
                <property name=""sslPort"">28443</property>
                <property name=""validationContext"">interop</property>
              </bean>
            </listItem>
          </beanList>
          <property name=""BEA_HOME"">$($epmInstallPath)</property>
          <property name=""domainName"">$($epmDomain)</property>
          <property name=""manualProcessing"">false</property>
          <property name=""remoteDeployment"">false</property>
          <property name=""serverLocation"">$($epmInstallPath)\wlserver_10.3</property>
        </bean>
      </bean>
      <bean name=""customConfiguration"">
        <property name=""AdminEmail"">$($email)</property>
        <property name=""adminPassword"">$($password)</property>
        <property name=""adminUserName"">$($workspaceAdmin)</property>
        <property name=""common_lwa_host"">$($fqdn)</property>
        <property name=""common_lwa_port"">$($workspacePort)</property>
        <property name=""common_lwa_set"">true</property>
        <property name=""common_lwa_ssl_port"">19443</property>
        <property name=""enable_SMTPServer_Authentication"">$($smtpAuth)</property>
        <property name=""enable_ssl"">false</property>
        <property name=""enable_windows_services"">true</property>
        <property name=""enable_windows_services_user_account"">false</property>
        <property name=""enableSslOffloading"">false</property>
        <property name=""externalUrlHost""/>
        <property name=""externalUrlPort""/>
        <property name=""filesystem.artifact.path"">import_export</property>
        <property name=""isSSLForSMTP"">$($smtpSSL)</property>
        <property name=""LwaUpdateAll"">1</property>
        <property name=""relativePaths""/>
        <property name=""relativePathsInstance"">filesystem.artifact.path</property>
        <property name=""SMTPHostName"">$($smtpServer)</property>
        <property name=""SMTPMailServer"">$($smtpServer)</property>
        <property name=""SMTPPort"">$($smtpPort)</property>
        <property name=""SMTPPortIncoming"">$($smtpIncomingPort)</property>
        <property name=""SMTPServerPassword"">$($smtpPassword)</property>
        <property name=""SMTPServerUserID"">$($smtpUsername)</property>
        <property name=""windows_services_password""/>
        <property name=""windows_services_user""/>
      </bean>
      <bean name=""httpServerConfiguration"">
        <property name=""displayVersion"">11.1.1.7</property>
        <bean name=""OracleHTTPserver"">
          <property name=""path"">$($epmInstallPath)\ohs</property>
          <property name=""port"">$($workspacePort)</property>
          <property name=""useSSL"">false</property>
        </bean>
        <property name=""port"">$($workspacePort)</property>
        <property name=""protocol"">http</property>
        <property name=""sharedLocation"">use_local_instance</property>
      </bean>
      <bean name=""lwaConfiguration"">
        <beanList name=""batchUpdateLWAComponents""/>
        <beanList name=""deploymentLWAComponents""/>
      </bean>
      <bean name=""relationalStorageConfiguration"">
        <bean name=""MS_SQL_SERVER"">
          <property name=""createOrReuse"">create</property>
          <property name=""customURL"">false</property>
          <property name=""dbIndexTbsp""/>
          <property name=""dbName"">$($foundationDB)</property>
          <property name=""dbTableTbsp""/>
          <property name=""encrypted"">true</property>
          <property name=""host"">$($dbServer)</property>
          <property name=""jdbcUrl"">jdbc:weblogic:sqlserver://$($dbServer):$($dbServerPort);databaseName=$($foundationDB)</property>
          <property name=""password"">$($dbPassword)</property>
          <property name=""port"">$($dbServerPort)</property>
          <property name=""SSL_ENABLED"">false</property>
          <property name=""userName"">$($dbUser)</property>
          <property name=""VALIDATESERVERCERTIFICATE"">true</property>
        </bean>
      </bean>
      <property name=""shortcutFolderName"">Foundation Services</property>
    </bean>
  </product>
  <product productXML=""workspace"">
    <tasks>
      <task>applicationServerDeployment</task>
    </tasks>
    <bean name=""main"">
      <bean name=""applicationServerDeployment"">
        <bean name=""WebLogic 10"">
          <property name=""adminHost"">$($fqdn)</property>
          <property name=""adminPassword"">$($password)</property>
          <property name=""adminPort"">$($wlPort)</property>
          <property name=""adminUser"">$($wlAdmin)</property>
          <beanList name=""applications"">
            <listItem>
              <bean>
                <property name=""compactPort"">9000</property>
                <property name=""compactServerName"">EPMServer</property>
                <property name=""compactSslPort"">9443</property>
                <property name=""component"">Workspace</property>
                <beanList name=""contexts"">
                  <listItem>
                    <property>workspace</property>
                  </listItem>
                </beanList>
                <property name=""enable"">true</property>
                <property name=""port"">28080</property>
                <property name=""serverName"">FoundationServices</property>
                <property name=""sslPort"">28443</property>
                <property name=""validationContext"">workspace/status</property>
              </bean>
            </listItem>
          </beanList>
          <property name=""BEA_HOME"">$($epmInstallPath)</property>
          <property name=""domainName"">$($epmDomain)</property>
          <property name=""manualProcessing"">false</property>
          <property name=""remoteDeployment"">false</property>
          <property name=""serverLocation"">$($epmInstallPath)\wlserver_10.3</property>
        </bean>
      </bean>
      <bean name=""httpServerConfiguration"">
        <property name=""contextRoot"">workspace</property>
        <property name=""host"">null</property>
        <property name=""port"">$($workspacePort)</property>
        <property name=""protocol"">http</property>
      </bean>
      <bean name=""lwaConfiguration"">
        <beanList name=""batchUpdateLWAComponents""/>
        <beanList name=""deploymentLWAComponents""/>
      </bean>
      <property name=""shortcutFolderName"">Workspace</property>
    </bean>
  </product>"

    $apsConfigureSilent =  "<product productXML=""APS"">
    <tasks>
      <task>applicationServerDeployment</task>
      <task>preConfiguration</task>
    </tasks>
    <bean name=""main"">
      <bean name=""applicationServerDeployment"">
        <bean name=""WebLogic 10"">
          <property name=""adminHost"">$($fqdn)</property>
          <property name=""adminPassword"">$($password)</property>
          <property name=""adminPort"">$($wlPort)</property>
          <property name=""adminUser"">$($wlAdmin)</property>
          <beanList name=""applications"">
            <listItem>
              <bean>
                <property name=""compactPort"">9000</property>
                <property name=""compactServerName"">$($epmDomain)</property>
                <property name=""compactSslPort"">9443</property>
                <property name=""component"">aps</property>
                <beanList name=""contexts"">
                  <listItem>
                    <property>aps</property>
                  </listItem>
                </beanList>
                <property name=""enable"">true</property>
                <property name=""port"">13080</property>
                <property name=""serverName"">AnalyticProviderServices</property>
                <property name=""sslPort"">13083</property>
                <property name=""validationContext"">aps</property>
              </bean>
            </listItem>
          </beanList>
          <property name=""BEA_HOME"">$($epmInstallPath)</property>
          <property name=""domainName"">$($epmDomain)</property>
          <property name=""manualProcessing"">false</property>
          <property name=""remoteDeployment"">false</property>
          <property name=""serverLocation"">$($epmInstallPath)\wlserver_10.3</property>
        </bean>
      </bean>
      <bean name=""lwaConfiguration"">
        <beanList name=""batchUpdateLWAComponents""/>
        <beanList name=""deploymentLWAComponents""/>
      </bean>
      <property name=""shortcutFolderName"">Essbase/Provider Services</property>
    </bean>
  </product>"

  $bpmaConfigureSilent = "<product productXML=""BPMA"">
    <tasks>
      <task>applicationServerDeployment</task>
      <task>bpmaVirtualDirectoryConfiguration</task>
      <task>hubRegistration</task>
      <task>preConfiguration</task>
      <task>relationalStorageConfiguration</task>
    </tasks>
    <bean name=""main"">
      <bean name=""applicationServerDeployment"">
        <bean name=""WebLogic 10"">
          <property name=""adminHost"">$($fqdn)</property>
          <property name=""adminPassword"">$($password)</property>
          <property name=""adminPort"">$($wlPort)</property>
          <property name=""adminUser"">$($wlAdmin)</property>
          <beanList name=""applications"">
            <listItem>
              <bean>
                <property name=""compactPort"">9000</property>
                <property name=""compactServerName"">$($epmDomain)</property>
                <property name=""compactSslPort"">9443</property>
                <property name=""component"">EPMADataSynchronizer</property>
                <beanList name=""contexts"">
                  <listItem>
                    <property>DataSync</property>
                  </listItem>
                </beanList>
                <property name=""enable"">true</property>
                <property name=""port"">19101</property>
                <property name=""serverName"">EpmaDataSync</property>
                <property name=""sslPort"">19145</property>
                <property name=""validationContext"">DataSync</property>
              </bean>
            </listItem>
            <listItem>
              <bean>
                <property name=""compactPort"">9000</property>
                <property name=""compactServerName"">$($epmDomain)</property>
                <property name=""compactSslPort"">9443</property>
                <property name=""component"">EPMAWebTier</property>
                <beanList name=""contexts"">
                  <listItem>
                    <property>awb</property>
                  </listItem>
                </beanList>
                <property name=""enable"">true</property>
                <property name=""port"">19091</property>
                <property name=""serverName"">EpmaWebReports</property>
                <property name=""sslPort"">19047</property>
                <property name=""validationContext"">awb/conf/AwbConfig.xml</property>
              </bean>
            </listItem>
          </beanList>
          <property name=""BEA_HOME"">$($epmInstallPath)</property>
          <property name=""domainName"">$($epmDomain)</property>
          <property name=""manualProcessing"">false</property>
          <property name=""remoteDeployment"">false</property>
          <property name=""serverLocation"">$($epmInstallPath)\wlserver_10.3</property>
        </bean>
      </bean>
      <bean name=""customConfiguration"">
        <property name=""bpmaInterfaceDSConfigSelectionPanel_datasourceAction"">create</property>
        <property name=""createTables"">create</property>
        <property name=""datasourceDbType"">Oracle</property>
        <property name=""epmaNetJniPort"">5255</property>
        <property name=""epmaServicePort"">5251</property>
        <property name=""product"">Datasource</property>
        <property name=""rdbmsPort"">1521</property>
        <property name=""rdbmsServer"">null</property>
        <property name=""rdbmsType"">Oracle</property>
        <property name=""relativePaths""/>
        <property name=""relativePathsInstance""/>
      </bean>
      <bean name=""lwaConfiguration"">
        <beanList name=""batchUpdateLWAComponents""/>
        <beanList name=""deploymentLWAComponents""/>
      </bean>
      <bean name=""relationalStorageConfiguration"">
        <bean name=""MS_SQL_SERVER"">
          <property name=""createOrReuse"">create</property>
          <property name=""customURL"">false</property>
          <property name=""dbIndexTbsp""/>
          <property name=""dbName"">$($bpmaDB)</property>
          <property name=""dbTableTbsp""/>
          <property name=""encrypted"">true</property>
          <property name=""host"">$($dbServer)</property>
          <property name=""jdbcUrl"">jdbc:weblogic:sqlserver://$($dbServer):$($dbServerPort);databaseName=$($bpmaDB);loadLibraryPath=$($epmInstallPath)\wlserver_10.3\server\lib</property>
          <property name=""password"">$($dbPassword)</property>
          <property name=""port"">$($dbServerPort)</property>
          <property name=""SSL_ENABLED"">false</property>
          <property name=""userName"">$($dbUser)</property>
          <property name=""VALIDATESERVERCERTIFICATE"">false</property>
        </bean>
      </bean>
      <property name=""shortcutFolderName"">Foundation Services/Performance Management Architect</property>
    </bean>
  </product>"

  $bpmsConfigureSilent = "<product productXML=""BPMS"">
    <tasks>
      <task>hubRegistration</task>
      <task>preConfiguration</task>
      <task>relationalStorageConfiguration</task>
    </tasks>
    <bean name=""main"">
      <bean name=""customConfiguration"">
        <property name=""productDataLocation"">BPMS\datafiles</property>
        <property name=""relativePaths""/>
        <property name=""relativePathsInstance"">productDataLocation</property>
      </bean>
      <bean name=""relationalStorageConfiguration"">
        <bean name=""MS_SQL_SERVER"">
          <property name=""createOrReuse"">create</property>
          <property name=""customURL"">false</property>
          <property name=""dbIndexTbsp""/>
          <property name=""dbName"">$($esbDB)</property>
          <property name=""dbTableTbsp""/>
          <property name=""encrypted"">true</property>
          <property name=""host"">$($dbServer)</property>
          <property name=""jdbcUrl"">jdbc:weblogic:sqlserver://$($dbServer):$($dbServerPort);databaseName=$($esbDB) ;loadLibraryPath=$($epmInstallPath)\wlserver_10.3\server\lib</property>
          <property name=""password"">$($dbPassword)</property>
          <property name=""port"">$($dbServerPort)</property>
          <property name=""SSL_ENABLED"">false</property>
          <property name=""userName"">$($dbUser)</property>
          <property name=""VALIDATESERVERCERTIFICATE"">false</property>
        </bean>
      </bean>
      <property name=""shortcutFolderName"">Essbase/Essbase Studio</property>
    </bean>
  </product>"

#endregion

$calcConfigureSilent = "<product productXML=""CALC"">
    <tasks>
      <task>applicationServerDeployment</task>
      <task>hubRegistration</task>
      <task>preConfiguration</task>
      <task>relationalStorageConfiguration</task>
    </tasks>
    <bean name=""main"">
      <bean name=""applicationServerDeployment"">
        <bean name=""WebLogic 10"">
          <property name=""adminHost"">$($fqdn)</property>
          <property name=""adminPassword"">$($password)</property>
          <property name=""adminPort"">$($wlPort)</property>
          <property name=""adminUser"">$($wlAdmin)</property>
          <beanList name=""applications"">
            <listItem>
              <bean>
                <property name=""compactPort"">9000</property>
                <property name=""compactServerName"">$($epmDomain)</property>
                <property name=""compactSslPort"">9443</property>
                <property name=""component"">CALC</property>
                <beanList name=""contexts"">
                  <listItem>
                    <property>calcmgr</property>
                  </listItem>
                </beanList>
                <property name=""enable"">true</property>
                <property name=""port"">8500</property>
                <property name=""serverName"">CalcMgr</property>
                <property name=""sslPort"">8543</property>
                <property name=""validationContext"">calcmgr/index.htm</property>
              </bean>
            </listItem>
          </beanList>
          <property name=""BEA_HOME"">$($epmInstallPath)</property>
          <property name=""domainName"">$($epmDomain)</property>
          <property name=""manualProcessing"">false</property>
          <property name=""remoteDeployment"">false</property>
          <property name=""serverLocation"">$($epmInstallPath)\wlserver_10.3</property>
        </bean>
      </bean>
      <bean name=""lwaConfiguration"">
        <beanList name=""batchUpdateLWAComponents""/>
        <beanList name=""deploymentLWAComponents""/>
      </bean>
      <bean name=""relationalStorageConfiguration"">
        <bean name=""MS_SQL_SERVER"">
          <property name=""createOrReuse"">create</property>
          <property name=""customURL"">false</property>
          <property name=""dbIndexTbsp""/>
          <property name=""dbName"">$($calcDB)</property>
          <property name=""dbTableTbsp""/>
          <property name=""encrypted"">true</property>
          <property name=""host"">$($dbServer)</property>
          <property name=""jdbcUrl"">jdbc:weblogic:sqlserver://$($dbServer):$($dbServerPort);databaseName=$($calcDB);loadLibraryPath=$($epmInstallPath)\wlserver_10.3\server\lib</property>
          <property name=""password"">$($dbPassword)</property>
          <property name=""port"">$($dbServerPort)</property>
          <property name=""SSL_ENABLED"">false</property>
          <property name=""userName"">$($dbUser)</property>
          <property name=""VALIDATESERVERCERTIFICATE"">false</property>
        </bean>
      </bean>
      <property name=""shortcutFolderName"">Calculation Manager</property>
    </bean>
  </product>"

  $disclosureConfigureSilent = "<product productXML=""Disclosure"">
    <tasks>
      <task>applicationServerDeployment</task>
      <task>hubRegistration</task>
      <task>preConfiguration</task>
      <task>relationalStorageConfiguration</task>
    </tasks>
    <bean name=""main"">
      <bean name=""applicationServerDeployment"">
        <bean name=""WebLogic 10"">
          <property name=""adminHost"">$($fqdn)</property>
          <property name=""adminPassword"">$($password)</property>
          <property name=""adminPort"">$($wlPort)</property>
          <property name=""adminUser"">$($wlAdmin)</property>
          <beanList name=""applications"">
            <listItem>
              <bean>
                <property name=""compactPort"">9000</property>
                <property name=""compactServerName"">$($epmDomain)</property>
                <property name=""compactSslPort"">9443</property>
                <property name=""component"">DisclosureManagement</property>
                <beanList name=""contexts"">
                  <listItem>
                    <property>discman</property>
                  </listItem>
                </beanList>
                <property name=""enable"">true</property>
                <property name=""port"">8600</property>
                <property name=""serverName"">DisclosureManagement</property>
                <property name=""sslPort"">8643</property>
                <property name=""validationContext"">mappingtool/faces/info.jspx</property>
              </bean>
            </listItem>
          </beanList>
          <property name=""BEA_HOME"">$($epmInstallPath)</property>
          <property name=""domainName"">$($epmDomain)</property>
          <property name=""manualProcessing"">false</property>
          <property name=""remoteDeployment"">false</property>
          <property name=""serverLocation"">$($epmInstallPath)\wlserver_10.3</property>
        </bean>
      </bean>
      <bean name=""lwaConfiguration"">
        <beanList name=""batchUpdateLWAComponents""/>
        <beanList name=""deploymentLWAComponents""/>
      </bean>
      <bean name=""relationalStorageConfiguration"">
        <bean name=""MS_SQL_SERVER"">
          <property name=""createOrReuse"">create</property>
          <property name=""customURL"">false</property>
          <property name=""dbIndexTbsp""/>
          <property name=""dbName"">$($disclosureDB)</property>
          <property name=""dbTableTbsp""/>
          <property name=""encrypted"">true</property>
          <property name=""host"">$($dbServer)</property>
          <property name=""jdbcUrl"">jdbc:weblogic:sqlserver://$($dbServer):$($dbServerPort);databaseName=$($disclosureDB);loadLibraryPath=$($epmInstallPath)\wlserver_10.3\server\lib</property>
          <property name=""password"">$($dbPassword)</property>
          <property name=""port"">$($dbServerPort)</property>
          <property name=""SSL_ENABLED"">false</property>
          <property name=""userName"">$($dbUser)</property>
          <property name=""VALIDATESERVERCERTIFICATE"">false</property>
        </bean>
      </bean>
      <property name=""shortcutFolderName"">Disclosure Management</property>
    </bean>
  </product>"

  $easConfigureSilent = "<product productXML=""eas"">
    <tasks>
      <task>applicationServerDeployment</task>
      <task>hubRegistration</task>
      <task>preConfiguration</task>
      <task>relationalStorageConfiguration</task>
    </tasks>
    <bean name=""main"">
      <bean name=""applicationServerDeployment"">
        <bean name=""WebLogic 10"">
          <property name=""adminHost"">$($fqdn)</property>
          <property name=""adminPassword"">$($password)</property>
          <property name=""adminPort"">$($wlPort)</property>
          <property name=""adminUser"">$($wlAdmin)</property>
          <beanList name=""applications"">
            <listItem>
              <bean>
                <property name=""compactPort"">9000</property>
                <property name=""compactServerName"">$($epmDomain)</property>
                <property name=""compactSslPort"">9443</property>
                <property name=""component"">eas</property>
                <beanList name=""contexts"">
                  <listItem>
                    <property>eas</property>
                  </listItem>
                </beanList>
                <property name=""enable"">true</property>
                <property name=""port"">10080</property>
                <property name=""serverName"">EssbaseAdminServices</property>
                <property name=""sslPort"">10083</property>
                <property name=""validationContext"">easconsole/console.html</property>
              </bean>
            </listItem>
          </beanList>
          <property name=""BEA_HOME"">$($epmInstallPath)</property>
          <property name=""domainName"">$($epmDomain)</property>
          <property name=""manualProcessing"">false</property>
          <property name=""remoteDeployment"">false</property>
          <property name=""serverLocation"">$($epmInstallPath)\wlserver_10.3</property>
        </bean>
      </bean>
      <bean name=""lwaConfiguration"">
        <beanList name=""batchUpdateLWAComponents""/>
        <beanList name=""deploymentLWAComponents""/>
      </bean>
      <bean name=""relationalStorageConfiguration"">
        <bean name=""MS_SQL_SERVER"">
          <property name=""createOrReuse"">create</property>
          <property name=""customURL"">false</property>
          <property name=""dbIndexTbsp""/>
          <property name=""dbName"">$($easDB)</property>
          <property name=""dbTableTbsp""/>
          <property name=""encrypted"">true</property>
          <property name=""host"">$($dbServer)</property>
          <property name=""jdbcUrl"">jdbc:weblogic:sqlserver://$($dbServer):$($dbServerPort);databaseName=$($easDB);loadLibraryPath=$($epmInstallPath)\wlserver_10.3\server\lib</property>
          <property name=""password"">$($dbPassword)</property>
          <property name=""port"">$($dbServerPort)</property>
          <property name=""SSL_ENABLED"">false</property>
          <property name=""userName"">$($dbUser)</property>
          <property name=""VALIDATESERVERCERTIFICATE"">false</property>
        </bean>
      </bean>
      <property name=""shortcutFolderName"">Essbase/Essbase Administration Services</property>
    </bean>
  </product>"

  $essbaseServerConfigureSilent = "<product productXML=""EssbaseServer"">
    <tasks>
      <task>hubRegistration</task>
      <task>preConfiguration</task>
      <task>RegisterEssbaseAsMultipleAgent</task>
    </tasks>
    <bean name=""main"">
      <bean name=""customConfiguration"">
        <property name=""AgentPort"">1423</property>
        <property name=""AgentSSLPort"">6423</property>
        <property name=""AppDirectory"">EssbaseServer\essbaseserver1</property>
        <property name=""bindingHost"">$($fqdn)</property>
        <property name=""ClusterName"">EssbaseCluster-1</property>
        <property name=""company"">hyperion</property>
        <property name=""component.name"">essbaseserver1</property>
        <property name=""EnableClearMode"">true</property>
        <property name=""EnableSecureMode"">false</property>
        <property name=""EndPort"">33768</property>
        <property name=""InstanceName"">Essbase1</property>
        <property name=""LangSelect"">English_UnitedStates.Latin1@Binary</property>
        <property name=""password"">$($password)</property>
        <property name=""relativePaths""/>
        <property name=""relativePathsInstance"">AppDirectory</property>
        <property name=""service"">hypservice</property>
        <property name=""StartPort"">32768</property>
        <property name=""userID"">hypuser</property>
      </bean>
      <property name=""shortcutFolderName"">Essbase/Essbase Server</property>
    </bean>
  </product>"

  $strategicConfigureSilent = "<product productXML=""HSF"">
    <tasks>
      <task>applicationServerDeployment</task>
      <task>HSFDataConfiguration</task>
      <task>HSFWebServiceConfiguration</task>
      <task>hubRegistration</task>
      <task>preConfiguration</task>
    </tasks>
    <bean name=""main"">
      <bean name=""applicationServerDeployment"">
        <bean name=""WebLogic 10"">
          <property name=""adminHost"">$($fqdn)</property>
          <property name=""adminPassword"">$($password)</property>
          <property name=""adminPort"">$($wlPort)</property>
          <property name=""adminUser"">$($wlAdmin)</property>
          <beanList name=""applications"">
            <listItem>
              <bean>
                <property name=""compactPort"">9000</property>
                <property name=""compactServerName"">$($epmDomain)</property>
                <property name=""compactSslPort"">9443</property>
                <property name=""component"">HSF</property>
                <beanList name=""contexts"">
                  <listItem>
                    <property>StrategicPlanning</property>
                  </listItem>
                </beanList>
                <property name=""enable"">true</property>
                <property name=""port"">8900</property>
                <property name=""serverName"">HsfWeb</property>
                <property name=""sslPort"">8943</property>
                <property name=""validationContext"">StrategicPlanning/JavaAPI</property>
              </bean>
            </listItem>
          </beanList>
          <property name=""BEA_HOME"">$($epmInstallPath)</property>
          <property name=""domainName"">$($epmDomain)</property>
          <property name=""manualProcessing"">false</property>
          <property name=""remoteDeployment"">false</property>
          <property name=""serverLocation"">$($epmInstallPath)\wlserver_10.3</property>
        </bean>
      </bean>
      <bean name=""customConfiguration"">
        <property name=""enableSViewProvider"">true</property>
        <property name=""enableWebService"">true</property>
        <property name=""HSFDataDirectory"">data\hsf\db</property>
        <property name=""HSFServicePort"">7750</property>
        <property name=""relativePaths""/>
        <property name=""relativePathsInstance"">HSFDataDirectory</property>
        <property name=""selectedWebServiceServer"">$($fqdn):7750</property>
      </bean>
      <bean name=""lwaConfiguration"">
        <beanList name=""batchUpdateLWAComponents""/>
        <beanList name=""deploymentLWAComponents""/>
      </bean>
      <property name=""shortcutFolderName"">Strategic Finance</property>
    </bean>
  </product>"

$planningConfigureSilent = "<product productXML=""Planning"">
    <tasks>
      <task>applicationServerDeployment</task>
      <task>hubRegistration</task>
      <task>planningRmiServerConfiguration</task>
      <task>preConfiguration</task>
      <task>relationalStorageConfiguration</task>
    </tasks>
    <bean name=""main"">
      <bean name=""applicationServerDeployment"">
        <bean name=""WebLogic 10"">
          <property name=""adminHost"">$($fqdn)</property>
          <property name=""adminPassword"">$($password)</property>
          <property name=""adminPort"">$($wlPort)</property>
          <property name=""adminUser"">$($wlAdmin)</property>
          <beanList name=""applications"">
            <listItem>
              <bean>
                <property name=""compactPort"">9000</property>
                <property name=""compactServerName"">$($epmDomain)</property>
                <property name=""compactSslPort"">9443</property>
                <property name=""component"">Planning</property>
                <beanList name=""contexts"">
                  <listItem>
                    <property>HyperionPlanning</property>
                  </listItem>
                </beanList>
                <property name=""enable"">true</property>
                <property name=""port"">8300</property>
                <property name=""serverName"">Planning</property>
                <property name=""sslPort"">8343</property>
                <property name=""validationContext"">HyperionPlanning/</property>
              </bean>
            </listItem>
          </beanList>
          <property name=""BEA_HOME"">$($epmInstallPath)</property>
          <property name=""domainName"">$($epmDomain)</property>
          <property name=""manualProcessing"">false</property>
          <property name=""remoteDeployment"">false</property>
          <property name=""serverLocation"">$($epmInstallPath)\wlserver_10.3</property>
        </bean>
      </bean>
      <bean name=""customConfiguration"">
        <property name=""port"">11333</property>
        <property name=""relativePaths""/>
        <property name=""relativePathsInstance""/>
      </bean>
      <bean name=""lwaConfiguration"">
        <beanList name=""batchUpdateLWAComponents""/>
        <beanList name=""deploymentLWAComponents""/>
      </bean>
      <bean name=""relationalStorageConfiguration"">
        <bean name=""MS_SQL_SERVER"">
          <property name=""createOrReuse"">create</property>
          <property name=""customURL"">false</property>
          <property name=""dbIndexTbsp""/>
          <property name=""dbName"">$($plnDB)</property>
          <property name=""dbTableTbsp""/>
          <property name=""encrypted"">true</property>
          <property name=""host"">$($dbServer)</property>
          <property name=""jdbcUrl"">jdbc:weblogic:sqlserver://$($dbServer):$($dbServerPort);databaseName=$($plnDB);loadLibraryPath=$($epmInstallPath)\wlserver_10.3\server\lib</property>
          <property name=""password"">$($dbPassword)</property>
          <property name=""port"">$($dbServerPort)</property>
          <property name=""SSL_ENABLED"">false</property>
          <property name=""userName"">$($dbUser)</property>
          <property name=""VALIDATESERVERCERTIFICATE"">false</property>
        </bean>
      </bean>
      <property name=""shortcutFolderName"">Planning</property>
    </bean>
  </product>"

  $profitConfigureSilent = "<product productXML=""Profitability"">
    <tasks>
      <task>applicationServerDeployment</task>
      <task>hubRegistration</task>
      <task>preConfiguration</task>
      <task>relationalStorageConfiguration</task>
      <task>reregisterApplication</task>
    </tasks>
    <bean name=""main"">
      <bean name=""applicationServerDeployment"">
        <bean name=""WebLogic 10"">
          <property name=""adminHost"">$($fqdn)</property>
          <property name=""adminPassword"">$($password)</property>
          <property name=""adminPort"">$($wlPort)</property>
          <property name=""adminUser"">$($wlAdmin)</property>
          <beanList name=""applications"">
            <listItem>
              <bean>
                <property name=""compactPort"">9000</property>
                <property name=""compactServerName"">$($epmDomain)</property>
                <property name=""compactSslPort"">9443</property>
                <property name=""component"">Profitability</property>
                <beanList name=""contexts"">
                  <listItem>
                    <property>profitability</property>
                  </listItem>
                </beanList>
                <property name=""enable"">true</property>
                <property name=""port"">6756</property>
                <property name=""serverName"">Profitability</property>
                <property name=""sslPort"">6743</property>
                <property name=""validationContext"">profitability/ping.jsp</property>
              </bean>
            </listItem>
          </beanList>
          <property name=""BEA_HOME"">$($epmInstallPath)</property>
          <property name=""domainName"">$($epmDomain)</property>
          <property name=""manualProcessing"">false</property>
          <property name=""remoteDeployment"">false</property>
          <property name=""serverLocation"">$($epmInstallPath)\wlserver_10.3</property>
        </bean>
      </bean>
      <bean name=""lwaConfiguration"">
        <beanList name=""batchUpdateLWAComponents""/>
        <beanList name=""deploymentLWAComponents""/>
      </bean>
      <bean name=""relationalStorageConfiguration"">
        <bean name=""MS_SQL_SERVER"">
          <property name=""createOrReuse"">create</property>
          <property name=""customURL"">false</property>
          <property name=""dbIndexTbsp""/>
          <property name=""dbName"">$($profDB)</property>
          <property name=""dbTableTbsp""/>
          <property name=""encrypted"">true</property>
          <property name=""host"">$($dbServer)</property>
          <property name=""jdbcUrl"">jdbc:weblogic:sqlserver://$($dbServer):$($dbServerPort);databaseName=$($profDB);loadLibraryPath=$($epmInstallPath)\wlserver_10.3\server\lib</property>
          <property name=""password"">$($dbPassword)</property>
          <property name=""port"">$($dbServerPort)</property>
          <property name=""SSL_ENABLED"">false</property>
          <property name=""userName"">$($dbUser)</property>
          <property name=""VALIDATESERVERCERTIFICATE"">false</property>
        </bean>
      </bean>
      <property name=""shortcutFolderName"">Profitability</property>
    </bean>
  </product>"

  $rafConfigureSilent = "<product productXML=""raframework"">
    <tasks>
      <task>applicationServerDeployment</task>
      <task>FrameworkServicesConfiguration</task>
      <task>hubRegistration</task>
      <task>preConfiguration</task>
      <task>relationalStorageConfiguration</task>
      <task>rmiPortConfiguration</task>
    </tasks>
    <bean name=""main"">
      <bean name=""applicationServerDeployment"">
        <bean name=""WebLogic 10"">
          <property name=""adminHost"">$($fqdn)</property>
          <property name=""adminPassword"">$($password)</property>
          <property name=""adminPort"">$($wlPort)</property>
          <property name=""adminUser"">$($wlAdmin)</property>
          <beanList name=""applications"">
            <listItem>
              <bean>
                <property name=""compactPort"">9000</property>
                <property name=""compactServerName"">$($epmDomain)</property>
                <property name=""compactSslPort"">9443</property>
                <property name=""component"">RA Framework</property>
                <beanList name=""contexts"">
                  <listItem>
                    <property>raframework</property>
                  </listItem>
                </beanList>
                <property name=""enable"">true</property>
                <property name=""port"">45000</property>
                <property name=""serverName"">RaFramework</property>
                <property name=""sslPort"">45043</property>
                <property name=""validationContext"">raframework/index.jsp</property>
              </bean>
            </listItem>
            <listItem>
              <bean>
                <property name=""compactPort"">9000</property>
                <property name=""compactServerName"">$($epmDomain)</property>
                <property name=""compactSslPort"">9443</property>
                <property name=""component"">Financial Reporting</property>
                <beanList name=""contexts"">
                  <listItem>
                    <property>hr</property>
                  </listItem>
                </beanList>
                <property name=""enable"">true</property>
                <property name=""port"">8200</property>
                <property name=""serverName"">FinancialReporting</property>
                <property name=""sslPort"">8243</property>
                <property name=""validationContext"">hr/status.jsp</property>
              </bean>
            </listItem>
          </beanList>
          <property name=""BEA_HOME"">$($epmInstallPath)</property>
          <property name=""domainName"">$($epmDomain)</property>
          <property name=""manualProcessing"">false</property>
          <property name=""remoteDeployment"">false</property>
          <property name=""serverLocation"">$($epmInstallPath)\wlserver_10.3</property>
        </bean>
      </bean>
      <bean name=""customConfiguration"">
        <property name=""frRmiPortRange"">8205-8228</property>
        <property name=""port"">6860</property>
        <property name=""relativePaths""/>
        <property name=""relativePathsInstance"">repositoryLocation</property>
        <property name=""repositoryLocation"">ReportingAnalysis\data\RM1</property>
        <property name=""rmiPort"">6861</property>
        <property name=""workspacePortRange"">6800-6805</property>
      </bean>
      <bean name=""httpServerConfiguration"">
        <property name=""contextRoot"">workspace</property>
        <property name=""host"">null</property>
        <property name=""port"">$($workspacePort)</property>
        <property name=""protocol"">http</property>
      </bean>
      <bean name=""lwaConfiguration"">
        <beanList name=""batchUpdateLWAComponents""/>
        <beanList name=""deploymentLWAComponents""/>
      </bean>
      <bean name=""relationalStorageConfiguration"">
        <bean name=""MS_SQL_SERVER"">
          <property name=""createOrReuse"">create</property>
          <property name=""customURL"">false</property>
          <property name=""dbIndexTbsp""/>
          <property name=""dbName"">$($rafDB)</property>
          <property name=""dbTableTbsp""/>
          <property name=""encrypted"">true</property>
          <property name=""host"">$($dbServer)</property>
          <property name=""jdbcUrl"">jdbc:weblogic:sqlserver://$($dbServer):$($dbServerPort);databaseName=$($rafDB);loadLibraryPath=$($epmInstallPath)\wlserver_10.3\server\lib</property>
          <property name=""password"">$($dbPassword)</property>
          <property name=""port"">$($dbServerPort)</property>
          <property name=""SSL_ENABLED"">false</property>
          <property name=""userName"">$($dbUser)</property>
          <property name=""VALIDATESERVERCERTIFICATE"">false</property>
        </bean>
      </bean>
      <property name=""shortcutFolderName"">Reporting and Analysis</property>
    </bean>
  </product>"

  $workspaceConfigureSilent = "<product productXML=""workspace"">
    <tasks>
      <task>applicationServerDeployment</task>
    </tasks>
    <bean name=""main"">
      <bean name=""applicationServerDeployment"">
        <bean name=""WebLogic 10"">
          <property name=""adminHost"">$($fqdn)</property>
          <property name=""adminPassword"">$($password)</property>
          <property name=""adminPort"">$($wlPort)</property>
          <property name=""adminUser"">$($wlAdmin)</property>
          <beanList name=""applications"">
            <listItem>
              <bean>
                <property name=""compactPort"">9000</property>
                <property name=""compactServerName"">$($epmDomain)</property>
                <property name=""compactSslPort"">9443</property>
                <property name=""component"">Workspace</property>
                <beanList name=""contexts"">
                  <listItem>
                    <property>workspace</property>
                  </listItem>
                </beanList>
                <property name=""enable"">true</property>
                <property name=""port"">28080</property>
                <property name=""serverName"">FoundationServices</property>
                <property name=""sslPort"">28443</property>
                <property name=""validationContext"">workspace/status</property>
              </bean>
            </listItem>
          </beanList>
          <property name=""BEA_HOME"">$($epmInstallPath)</property>
          <property name=""domainName"">$($epmDomain)</property>
          <property name=""manualProcessing"">false</property>
          <property name=""remoteDeployment"">false</property>
          <property name=""serverLocation"">$($epmInstallPath)\wlserver_10.3</property>
        </bean>
      </bean>
      <bean name=""httpServerConfiguration"">
        <property name=""contextRoot"">workspace</property>
        <property name=""host"">null</property>
        <property name=""port"">$($workspacePort)</property>
        <property name=""protocol"">http</property>
      </bean>
      <bean name=""lwaConfiguration"">
        <beanList name=""batchUpdateLWAComponents""/>
        <beanList name=""deploymentLWAComponents""/>
      </bean>
      <property name=""shortcutFolderName"">Workspace</property>
    </bean>
  </product>"

  $fdmConfigureSilent = "<product productXML=""AIF"">
    <tasks>
      <task>applicationServerDeployment</task>
      <task>hubRegistration</task>
      <task>preConfiguration</task>
      <task>relationalStorageConfiguration</task>
    </tasks>
    <bean name=""main"">
      <bean name=""applicationServerDeployment"">
        <bean name=""WebLogic 10"">
          <property name=""adminHost"">$($fqdn)</property>
          <property name=""adminPassword"">$($password)</property>
          <property name=""adminPort"">$($wlPort)</property>
          <property name=""adminUser"">$($wlAdmin)</property>
          <beanList name=""applications"">
            <listItem>
              <bean>
                <property name=""compactPort"">9000</property>
                <property name=""compactServerName"">$($epmDomain)</property>
                <property name=""compactSslPort"">9443</property>
                <property name=""component"">aif</property>
                <beanList name=""contexts"">
                  <listItem>
                    <property>aif</property>
                  </listItem>
                </beanList>
                <property name=""enable"">true</property>
                <property name=""port"">6550</property>
                <property name=""serverName"">ErpIntegrator</property>
                <property name=""sslPort"">6553</property>
                <property name=""validationContext"">aif/faces/setup/Main.jspx oracle-epm-erpi-webservices/RuleService</property>
              </bean>
            </listItem>
          </beanList>
          <property name=""BEA_HOME"">$($epmInstallPath)</property>
          <property name=""domainName"">$($epmDomain)</property>
          <property name=""manualProcessing"">false</property>
          <property name=""remoteDeployment"">false</property>
          <property name=""serverLocation"">$($epmInstallPath)\wlserver_10.3</property>
        </bean>
      </bean>
      <bean name=""lwaConfiguration"">
        <beanList name=""batchUpdateLWAComponents""/>
        <beanList name=""deploymentLWAComponents""/>
      </bean>
      <bean name=""relationalStorageConfiguration"">
        <bean name=""MS_SQL_SERVER"">
          <property name=""createOrReuse"">create</property>
          <property name=""customURL"">false</property>
          <property name=""dbIndexTbsp""/>
          <property name=""dbName"">$($fdmDB)</property>
          <property name=""dbTableTbsp""/>
          <property name=""encrypted"">true</property>
          <property name=""host"">$($dbServer)</property>
          <property name=""jdbcUrl"">jdbc:weblogic:sqlserver://$($dbServer):$($dbServerPort);databaseName=$($fdmDB);loadLibraryPath=$($epmInstallPath)\wlserver_10.3\server\lib</property>
          <property name=""password"">$($dbPassword)</property>
          <property name=""port"">$($dbServerPort)</property>
          <property name=""SSL_ENABLED"">false</property>
          <property name=""userName"">$($dbUser)</property>
          <property name=""VALIDATESERVERCERTIFICATE"">false</property>
        </bean>
      </bean>
      <property name=""shortcutFolderName"">FDM Enterprise Edition</property>
    </bean>
  </product>"

  $hfmConfigureSilent = "<product productXML=""HFM"">
    <tasks>
      <task>applicationServerDeployment</task>
      <task>clusterConfig</task>
      <task>hfmAppServerConfig</task>
      <task>hubRegistration</task>
      <task>preConfiguration</task>
      <task>relationalStorageConfiguration</task>
      <task>upgradeApplication</task>
    </tasks>
    <bean name=""main"">
      <bean name=""applicationServerDeployment"">
        <bean name=""WebLogic 10"">
          <property name=""adminHost"">$($fqdn)</property>
          <property name=""adminPassword"">$($password)</property>
          <property name=""adminPort"">$($wlPort)</property>
          <property name=""adminUser"">$($wlAdmin)</property>
          <beanList name=""applications"">
            <listItem>
              <bean>
                <property name=""compactPort"">9000</property>
                <property name=""compactServerName"">$($epmDomain)</property>
                <property name=""compactSslPort"">9443</property>
                <property name=""component"">FM Web Services</property>
                <beanList name=""contexts"">
                  <listItem>
                    <property>oracle-epm-fm-webservices</property>
                  </listItem>
                </beanList>
                <property name=""enable"">true</property>
                <property name=""port"">7363</property>
                <property name=""serverName"">HFMWeb</property>
                <property name=""sslPort"">7365</property>
                <property name=""validationContext"">oracle-epm-fm-webservices/ApplicationService</property>
              </bean>
            </listItem>
            <listItem>
              <bean>
                <property name=""compactPort"">9000</property>
                <property name=""compactServerName"">$($epmDomain)</property>
                <property name=""compactSslPort"">9443</property>
                <property name=""component"">FM ADF Web Application</property>
                <beanList name=""contexts"">
                  <listItem>
                    <property>hfmadf</property>
                  </listItem>
                </beanList>
                <property name=""enable"">true</property>
                <property name=""port"">7363</property>
                <property name=""serverName"">HFMWeb</property>
                <property name=""sslPort"">7365</property>
                <property name=""validationContext"">hfmadf/faces/hfm.jspx</property>
              </bean>
            </listItem>
          </beanList>
          <property name=""BEA_HOME"">$($epmInstallPath)</property>
          <property name=""domainName"">$($epmDomain)</property>
          <property name=""manualProcessing"">false</property>
          <property name=""remoteDeployment"">false</property>
          <property name=""serverLocation"">$($epmInstallPath)\wlserver_10.3</property>
        </bean>
      </bean>
      <bean name=""customConfiguration"">
        <bean name=""cluster1"">
          <property name=""clusterName"">HFM1</property>
          <property name=""currentSession"">true</property>
          <property name=""server1"">BLAB-INSTALL</property>
          <property name=""useStickyServer"">true</property>
        </bean>
        <property name=""dataSyncDelay"">300</property>
        <property name=""dbIndexTbsp""/>
        <property name=""dbTableTbsp""/>
        <property name=""deletedClusters""/>
        <property name=""encryptUDL"">false</property>
        <property name=""entryPointPath"">eie</property>
        <property name=""financialManagementPort"">80</property>
        <property name=""hsxDatasourceEndPort"">10020</property>
        <property name=""hsxDatasourceStartPort"">10001</property>
        <property name=""isBufferResizeEnabled"">false</property>
        <property name=""isNonSslEnabled"">true</property>
        <property name=""isSslEnabled"">false</property>
        <property name=""NumMaxDBConnections"">200</property>
        <property name=""port"">9091</property>
        <property name=""receiveBufferSize"">1024</property>
        <property name=""relativePaths""/>
        <property name=""relativePathsInstance"">SystemDataLinkFile</property>
        <property name=""selectedTask"">applicationServerDeployment,bpmaVirtualDirectoryConfiguration,clusterConfig,editLWAConfiguration,financialCloseSupportInformation,FndCommonSetting,FrameworkServicesConfiguration,hfmAppServerConfig,HSFDataConfiguration,HSFWebServiceConfiguration,hubRegistration,planningRmiServerConfiguration,preConfiguration,RegisterEssbaseAsMultipleAgent,relationalStorageConfiguration,reregisterApplication,rmiPortConfiguration,taxOperationsSoaDeployment,upgradeApplication,WebServerConfiguration</property>
        <property name=""serverDelay"">300</property>
        <property name=""ssl_port"">9092</property>
        <property name=""SystemDataLinkFile"">FinancialManagement\ServerWorkingFolder\MS_SQL_SERVER_hfm.udl</property>
      </bean>
      <bean name=""lwaConfiguration"">
        <beanList name=""batchUpdateLWAComponents""/>
        <beanList name=""deploymentLWAComponents""/>
      </bean>
      <bean name=""relationalStorageConfiguration"">
        <bean name=""MS_SQL_SERVER"">
          <property name=""createOrReuse"">create</property>
          <property name=""customURL"">false</property>
          <property name=""dbIndexTbsp""/>
          <property name=""dbName"">$($hfmDB)</property>
          <property name=""dbTableTbsp""/>
          <property name=""encrypted"">true</property>
          <property name=""host"">$($dbServer)</property>
          <property name=""jdbcUrl"">jdbc:weblogic:sqlserver://$($dbServer):$($dbServerPort);databaseName=$($hfmDB);loadLibraryPath=$($epmInstallPath)\wlserver_10.3\server\lib</property>
          <property name=""password"">$($dbPassword)</property>
          <property name=""port"">$($dbServerPort)</property>
          <property name=""SSL_ENABLED"">false</property>
          <property name=""userName"">$($dbUser)</property>
          <property name=""VALIDATESERVERCERTIFICATE"">false</property>
        </bean>
      </bean>
      <property name=""shortcutFolderName"">Financial Management</property>
    </bean>
  </product>"
  #endregion

#endregion

#region configure EPM

    if($inputCALCDB -eq $null -and $inputEPMADB -eq $null) {

    $data = "<?xml version=""1.0"" encoding=""UTF-8"" standalone=""no""?>
<products>
  <instance>$($epmInstallPath)\user_projects\epmsystem1</instance>
  <enable_compact_deployment_mode>false</enable_compact_deployment_mode>
  <auto_port_tick>true</auto_port_tick>
  $($fndConfigureSilent)
  $($apsConfigureSilent)
  $($bpmsConfigureSilent)
  $($disclosureConfigureSilent)
  $($easConfigureSilent)
  $($essbaseServerConfigureSilent)
  $($strategicConfigureSilent)
  $($planningConfigureSilent)
  $($profitConfigureSilent)
  $($rafConfigureSilent)
  $($workspaceConfigureSilent)
  $($fdmConfigureSilent)
  $($hfmConfigureSilent)
</products>
"
}

if($inputCALCDB -eq $null) {

    $data = "<?xml version=""1.0"" encoding=""UTF-8"" standalone=""no""?>
<products>
  <instance>$($epmInstallPath)\user_projects\epmsystem1</instance>
  <enable_compact_deployment_mode>false</enable_compact_deployment_mode>
  <auto_port_tick>true</auto_port_tick>
  $($fndConfigureSilent)
  $($apsConfigureSilent)
  $($bpmaConfigureSilent)
  $($bpmsConfigureSilent)
  $($disclosureConfigureSilent)
  $($easConfigureSilent)
  $($essbaseServerConfigureSilent)
  $($strategicConfigureSilent)
  $($planningConfigureSilent)
  $($profitConfigureSilent)
  $($rafConfigureSilent)
  $($workspaceConfigureSilent)
  $($fdmConfigureSilent)
  $($hfmConfigureSilent)
</products>
"
$data
}

if($inputEPMADB -eq $null) {

    $data = "<?xml version=""1.0"" encoding=""UTF-8"" standalone=""no""?>
<products>
  <instance>$($epmInstallPath)\user_projects\epmsystem1</instance>
  <enable_compact_deployment_mode>false</enable_compact_deployment_mode>
  <auto_port_tick>true</auto_port_tick>
  $($fndConfigureSilent)
  $($apsConfigureSilent)
  $($bpmsConfigureSilent)
  $($calcConfigureSilent)
  $($disclosureConfigureSilent)
  $($easConfigureSilent)
  $($essbaseServerConfigureSilent)
  $($strategicConfigureSilent)
  $($planningConfigureSilent)
  $($profitConfigureSilent)
  $($rafConfigureSilent)
  $($workspaceConfigureSilent)
  $($fdmConfigureSilent)
  $($hfmConfigureSilent)
</products>
"
}

    $data = "<?xml version=""1.0"" encoding=""UTF-8"" standalone=""no""?>
<products>
  <instance>$($epmInstallPath)\user_projects\epmsystem1</instance>
  <enable_compact_deployment_mode>false</enable_compact_deployment_mode>
  <auto_port_tick>true</auto_port_tick>
  $($fndConfigureSilent)
  $($bpmsConfigureSilent)
  $($disclosureConfigureSilent)
  $($easConfigureSilent)
  $($essbaseServerConfigureSilent)
  $($strategicConfigureSilent)
  $($planningConfigureSilent)
  $($profitConfigureSilent)
  $($rafConfigureSilent)
  $($workspaceConfigureSilent)
  $($fdmConfigureSilent)
  $($hfmConfigureSilent)
  $($apsConfigureSilent)
  $($fndConfigureSilent)
  $($bpmaConfigureSilent)
  $($calcConfigureSilent)
</products>
"

$data | Out-File "$($installerPath)\Temp\silentConfigure" -Encoding utf8
    $silentConfigureFile = Get-Content "$($installerPath)\Temp\silentConfigure"
    $Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
    [System.IO.File]::WriteAllLines("$($installerPath)\Temp\silentConfigure", $silentConfigureFile, $Utf8NoBomEncoding)

    try {
    Write-Host "Configuring EPM. This may take 10 - 20 Minutes." -ForegroundColor Cyan
    Start-Process -FilePath "$($epmInstallPath)\EPMSystem11R1\common\config\11.1.2.0\configtool.bat" -Wait -ArgumentList "-silent $($installerPath)\Temp\silentConfigure" -Verb RunAs
    }
    catch {
        $_ | Out-File "$($installerPath)\Logs\configTool.Error.log" -Append
        Get-Content "$($installerPath)\Logs\configTool.Error.log" | Write-Host -ForegroundColor Red
        Read-Host "Click enter to exit"
        Exit
    }

#endregion