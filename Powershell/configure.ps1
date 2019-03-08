﻿#region set mainVariables and mainFunctions

    . 'C:\InstallAutomation\Variables\mainVariables.ps1'
    . 'C:\InstallAutomation\Functions\mainfunctions.ps1'

#endregion

#region confirm install path

    if(!$epmInstallPath){
        $installedSoftware = Get-Software | Where-Object {$_.DisplayName -like "Oracle EPM*"}
        if($installedSoftware){
            $epmInstallPath = $installedSoftware.UninstallString.Substring(0,3)
            $epmInstallPath = Get-ChildItem $epmInstallPath\*\,\*\* -ErrorAction SilentlyContinue | Where-Object {$_.PSIsContainer -eq $true -and $_.Name -match "Middleware"}
        }
        
        if($epmInstallPath.Count -ge 1) {
            $epmInstallPath = $epmInstallPath.FullName 
        }
        else {
            $epmInstallPath = Read-Host "Can't find your EPM install path. Please type it in now."
        }
    }

#endregion

#region user input for configuration
    
    if(!$superSilentConfig -or $superSilentConfig -eq $false){
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
    }
#endregion

#region configuration details

    if(!$superSilentConfig -or $superSilentConfig -eq $false){
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
    }
    #region prompt user that 100% customization is not currently supported
        
        if(!$superSilentConfig -or $superSilentConfig -eq $false){
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
    }
    #endregion
    
    #region ask to open default configurator for user
        
        if(!$superSilentConfig -or $superSilentConfig -eq $false){
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
    }
    #endregion

    #region start default configurator
        
        if(!$superSilentConfig -or $superSilentConfig -eq $false){
            if($inputConfigurator -eq 1) {
                Start-Process -FilePath "$($epmInstallPath)\EPMSystem11R1\common\config\11.1.2.0\configtool.bat" -Verb RunAs
                Read-Host "Press Enter to Exit"
            }
        }
    #endregion

    #region user input for recommended configuration
        
        if(!$superSilentConfig -or $superSilentConfig -eq $false){
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
                Write-Host "============== Weblogic Hostname ==============="
                Write-Host "What is the hostname of the server where weblogic"
                Write-Host "is installed?"
                Write-Host ""
                Write-Host "Type Quit to Exit the Installer" -ForegroundColor Yellow
                Write-Host "================================================"
                $inputWeblogicHostname = Read-Host
                if ($inputWeblogicHostname -like "*quit*") {Exit}
            
            
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
        } elseif($superSilentConfig -and $superSilentConfig -eq $true){
            $inputWrkspcPassword = $wkspcAdminPassword
            $inputWrkspcPort = $weblogicPort
            $inputWeblogicPort = $weblogicPort
            $inputWeblogicHostname = 
            $inputWeblogicAdmin = $weblogicAdmin
            $inputEPMDomain = $epmDomain
            $inputWrkspcAdmin = $wkspcAdmin
            $inputDBHostname = $dbServer
            $inputDBPort = $dbPort
            $inputDBUsername = $dbUser
            $inputDBUserPass = $dbPassword
            $inputFNDDB = $foundationDB
            $inputEPMADB = $epmaDB
            $inputESBDB = $essbaseDB
            $inputCALCDB = $calcDB
            $inputDisclosureDB = $disclosureDB
            $inputEASDB = $essbaseDB
            $inputPLNDB = $planningDB
            $inputProfitDB = $profitDB
            $inputRAFDB = $rafDB
            $inputFDMDB = $fdmDB
            $inputHFMDB = $hfmDB
        }
    #endregion

#endregion

#region set variables

    $password = $inputWrkspcPassword
    $wlPort = $inputWeblogicPort
    $wlHost = $inputWeblogicHostname
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

    if($foundationDB -ne $null){
        $fndConfigureSilent = Get-Content -Path "$($installerPath)\Variables\Property Files\foundation" -Raw
        $fndConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($fndConfigureSilent)
    }
    if($foundationDB -ne $null){
        $apsConfigureSilent =  Get-Content -Path "$($installerPath)\Variables\Property Files\aps" -Raw
        $apsConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($apsConfigureSilent)
    }
    if($bpmaDB -ne $null){
        $bpmaConfigureSilent = Get-Content -Path "$($installerPath)\Variables\Property Files\epma" -Raw
        $bpmaConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($bpmaConfigureSilent)
    }
    if($esbDB -ne $null){
        $bpmsConfigureSilent = Get-Content -Path "$($installerPath)\Variables\Property Files\essbaseStudio" -Raw
        $bpmsConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($bpmsConfigureSilent)
    }
    if($calcDB -ne $null){
        $calcConfigureSilent = Get-Content -Path "$($installerPath)\Variables\Property Files\calc" -Raw
        $calcConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($calcConfigureSilent)
    }
    if($disclosureDB -ne $null){
        $disclosureConfigureSilent = Get-Content -Path "$($installerPath)\Variables\Property Files\disclosure" -Raw
        $disclosureConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($disclosureConfigureSilent)
    }
    if($easDB -ne $null){
        $easConfigureSilent = Get-Content -Path "$($installerPath)\Variables\Property Files\eas" -Raw
        $easConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($easConfigureSilent)
    }
    if($esbDB -ne $null){
        $essbaseServerConfigureSilent = Get-Content -Path "$($installerPath)\Variables\Property Files\essbase" -Raw
        $essbaseServerConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($essbaseServerConfigureSilent)
    }
    if($strategic -eq $true){
        $strategicConfigureSilent = Get-Content -Path "$($installerPath)\Variables\Property Files\strategic" -Raw
        $strategicConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($strategicConfigureSilent)
    }
    if($plnDB -ne $null){
        $planningConfigureSilent = Get-Content -Path "$($installerPath)\Variables\Property Files\planning" -Raw
        $planningConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($planningConfigureSilent)
    }
    if($profDB -ne $null){
        $profitConfigureSilent = Get-Content -Path "$($installerPath)\Variables\Property Files\profit" -Raw
        $profitConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($profitConfigureSilent)
    }
    if($rafDB -ne $null){
        $rafConfigureSilent = Get-Content -Path "$($installerPath)\Variables\Property Files\raf" -Raw
        $rafConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($rafConfigureSilent)
    }
    if($foundationDB -ne $null){
        $workspaceConfigureSilent = Get-Content -Path "$($installerPath)\Variables\Property Files\workspace" -Raw 
        $workspaceConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($workspaceConfigureSilent) 
    }
    if($fdmDB -ne $null){
        $fdmConfigureSilent = Get-Content -Path "$($installerPath)\Variables\Property Files\fdm" -Raw 
        $fdmConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($fdmConfigureSilent) 
    }
    if($hfmDB -ne $null){
        $hfmConfigureSilent = Get-Content -Path "$($installerPath)\Variables\Property Files\hfm" -Raw
        $hfmConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($hfmConfigureSilent)
    }

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

#region start epm and validate

    if($startEPM -eq $true){
        try {
            Start-Process -FilePath "$($epmInstallPath)\user_projects\epmsystem1\bin\start.bat" -Wait -Verb RunAs
        }
        catch {
            $_ | Out-File "$($installerPath)\Logs\startEPM.Error.log" -Append
            Get-Content "$($installerPath)\Logs\startEPM.Error.log" | Write-Host -ForegroundColor Red
            Read-Host "Click enter to exit"
            Exit
        }
        if($validate -eq $true){
            try {
                Start-Process -FilePath "$($epmInstallPath)\user_projects\epmsystem1\bin\validate.bat" -Wait -Verb RunAs
            }
            catch {
                $_ | Out-File "$($installerPath)\Logs\validate.Error.log" -Append
                Get-Content "$($installerPath)\Logs\validate.Error.log" | Write-Host -ForegroundColor Red
                Read-Host "Click enter to exit"
                Exit
            }
        }
    }

#endregion