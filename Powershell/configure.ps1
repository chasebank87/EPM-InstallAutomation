#region set mainVariables and mainFunctions

    . "$($installerPath)\Variables\mainVariables"
    . "$($installerPath)\Functions\mainfunctions.ps1"

#endregion

#region announce install

	Write-Host '

 ______   ______   __   __   ______  __   ______   __  __   ______   __   __   __   ______    
/\  ___\ /\  __ \ /\ "-.\ \ /\  ___\/\ \ /\  ___\ /\ \/\ \ /\  == \ /\ \ /\ "-.\ \ /\  ___\   
\ \ \____\ \ \/\ \\ \ \-.  \\ \  __\\ \ \\ \ \__ \\ \ \_\ \\ \  __< \ \ \\ \ \-.  \\ \ \__ \  
 \ \_____\\ \_____\\ \_\\"\_\\ \_\   \ \_\\ \_____\\ \_____\\ \_\ \_\\ \_\\ \_\\"\_\\ \_____\ 
  \/_____/ \/_____/ \/_/ \/_/ \/_/    \/_/ \/_____/ \/_____/ \/_/ /_/ \/_/ \/_/ \/_/ \/_____/ 
                                                                                              
											      
' -ForegroundColor Magenta                                                                                  

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
                Write-Host "============================================"
                $inputWrkspcAdmin = Read-Host
                if ($inputWrkspcAdmin -like "*quit*") {Exit}
                while($inputWrkspcPassword.Length -lt 8 -or $inputWrkspcPassword -notmatch ".*\d+.*" -or $inputWrkspcPassword -notmatch ".*\w+.*"){
                Write-Host ""
                Write-Host "============================================"
                Write-Host "What do you want your workspace admin password"
                Write-Host "to be?"
                Write-Host ""
                Write-Host "Type Quit to Exit the Installer" -ForegroundColor Yellow
                    Write-Host "============================================"
                    $inputWrkspcPassword = Read-Host
                    if($inputWrkspcPassword -like "*quit*") {Exit}
                    if($wkspcAdminPassword.Length -lt 8 -or $wkspcAdminPassword -notmatch ".*\w+.*" -or $wkspcAdminPassword -notmatch '[^a-zA-Z]|.*\d+.*'){
                        Write-Host "Workspace admin password does not meet the minimum requirements. Password must be alphanumeric, and at least 8 characters." -ForegroundColor Red
                        Read-Host "Click enter to retry"
                    }
                }
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
            $inputWrkspcPort = $wkspcPort
            $inputWeblogicPort = $weblogicPort
            $inputWeblogicHostname = $weblogicHostname
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

    if($standalone -eq $true){
        Write-Host "Starting Standalone Configuration" -ForegroundColor cyan
        Write-Host "Adding Header to config file" -ForegroundColor green
        $headerConfigureSilent = Get-Content -Path "$($installerPath)\Variables\Property Files\11.1.2.4\Config\Standalone\header" -Raw
        $headerConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($headerConfigureSilent)
 
        if($configFoundation -ne $false){
            Write-Host "Adding Foundation to config file" -ForegroundColor green
            $fndConfigureSilent = Get-Content -Path "$($installerPath)\Variables\Property Files\11.1.2.4\Config\Standalone\foundation" -Raw
            $fndConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($fndConfigureSilent)
        }
        if($configEssbase -ne $false){
            Write-Host "Adding Provider to config file" -ForegroundColor green
            $apsConfigureSilent =  Get-Content -Path "$($installerPath)\Variables\Property Files\11.1.2.4\Config\Standalone\aps" -Raw
            $apsConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($apsConfigureSilent)
        } 
        if($configEPMA -ne $false){
            Write-Host "Adding EPMA to config file" -ForegroundColor green
            $bpmaConfigureSilent = Get-Content -Path "$($installerPath)\Variables\Property Files\11.1.2.4\Config\Standalone\epma" -Raw
            $bpmaConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($bpmaConfigureSilent)
        }
        if($configEssbase -ne $false){
            Write-Host "Adding Essbase Studio to config file" -ForegroundColor green
            $bpmsConfigureSilent = Get-Content -Path "$($installerPath)\Variables\Property Files\11.1.2.4\Config\Standalone\essbaseStudio" -Raw
            $bpmsConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($bpmsConfigureSilent)
        }
        if($configCALC -ne $false){
            Write-Host "Adding CALC to config file" -ForegroundColor green
            $calcConfigureSilent = Get-Content -Path "$($installerPath)\Variables\Property Files\11.1.2.4\Config\Standalone\calc" -Raw
            $calcConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($calcConfigureSilent)
        }
        if($configDisclosure -ne $false){
            Write-Host "Adding Disclosure to config file" -ForegroundColor green
            $disclosureConfigureSilent = Get-Content -Path "$($installerPath)\Variables\Property Files\11.1.2.4\Config\Standalone\disclosure" -Raw
            $disclosureConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($disclosureConfigureSilent)
        }
        if($configEssbase -ne $false){
            Write-Host "Adding EAS to config file" -ForegroundColor green
            $easConfigureSilent = Get-Content -Path "$($installerPath)\Variables\Property Files\11.1.2.4\Config\Standalone\eas" -Raw
            $easConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($easConfigureSilent)
        }
        if($configEssbase -ne $false){
            Write-Host "Adding Essbase to config file" -ForegroundColor green
            $essbaseServerConfigureSilent = Get-Content -Path "$($installerPath)\Variables\Property Files\11.1.2.4\Config\Standalone\essbase" -Raw
            $essbaseServerConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($essbaseServerConfigureSilent)
        }
        if($strategic -ne $false){
            Write-Host "Adding Strategic to config file" -ForegroundColor green
            $strategicConfigureSilent = Get-Content -Path "$($installerPath)\Variables\Property Files\11.1.2.4\Config\Standalone\strategic" -Raw
            $strategicConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($strategicConfigureSilent)
        }
        if($configPlanning -ne $false){
            Write-Host "Adding Planning to config file" -ForegroundColor green
            $planningConfigureSilent = Get-Content -Path "$($installerPath)\Variables\Property Files\11.1.2.4\Config\Standalone\planning" -Raw
            $planningConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($planningConfigureSilent)
        }
        if($configProfit -ne $false){
            Write-Host "Adding Profit to config file" -ForegroundColor green
            $profitConfigureSilent = Get-Content -Path "$($installerPath)\Variables\Property Files\11.1.2.4\Config\Standalone\profit" -Raw
            $profitConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($profitConfigureSilent)
        }
        if($configRAF -ne $false){
            Write-Host "Adding RAF to config file" -ForegroundColor green
            $rafConfigureSilent = Get-Content -Path "$($installerPath)\Variables\Property Files\11.1.2.4\Config\Standalone\raf" -Raw
            $rafConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($rafConfigureSilent)
        }
        if($configFoundation -ne $false){
            Write-Host "Adding Workspace to config file" -ForegroundColor green
            $workspaceConfigureSilent = Get-Content -Path "$($installerPath)\Variables\Property Files\11.1.2.4\Config\Standalone\workspace" -Raw 
            $workspaceConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($workspaceConfigureSilent) 
        }
        if($configFDM -ne $false){
            Write-Host "Adding FDM to config file" -ForegroundColor green
            $fdmConfigureSilent = Get-Content -Path "$($installerPath)\Variables\Property Files\11.1.2.4\Config\Standalone\fdm" -Raw 
            $fdmConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($fdmConfigureSilent) 
        }
        if($configHFM -ne $false){
            Write-Host "Adding HFM to config file" -ForegroundColor green
            $hfmConfigureSilent = Get-Content -Path "$($installerPath)\Variables\Property Files\11.1.2.4\Config\Standalone\hfm" -Raw
            $hfmConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($hfmConfigureSilent)
        }
    } else {
        if($firstStage -eq $true){
            Write-Host "Starting Distributed Central Configuration" -ForegroundColor cyan
            if($remoteDeployment -and $remoteDeployment -eq $true){
                Write-Host "Adding Remote Header to config file" -ForegroundColor green
                $headerConfigureSilent = Get-Content -Path "$($installerPath)\Variables\Property Files\11.1.2.4\Config\Distributed\remote\header" -Raw
                $headerConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($headerConfigureSilent)
            } elseif(!$remoteDeployment -or $remoteDeployment -eq $false) {
                Write-Host "Adding Central Header to config file" -ForegroundColor green
                $headerConfigureSilent = Get-Content -Path "$($installerPath)\Variables\Property Files\11.1.2.4\Config\Distributed\central\header" -Raw
                $headerConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($headerConfigureSilent)
            }
            if($configFoundation -ne $false -and $remoteDeployment -eq $true){
                Write-Host "Adding Remote Foundation to config file" -ForegroundColor green
                $fndConfigureSilent = Get-Content -Path "$($installerPath)\Variables\Property Files\11.1.2.4\Config\Distributed\Remote\foundation" -Raw
                $fndConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($fndConfigureSilent)
            } elseif($configFoundation -ne $false -and $remoteDeployment -ne $true){
               	Write-Host "Adding Central Foundation to config file" -ForegroundColor green
                $fndConfigureSilent = Get-Content -Path "$($installerPath)\Variables\Property Files\11.1.2.4\Config\Distributed\Central\foundation" -Raw
                $fndConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($fndConfigureSilent)

            }
            if($configEssbase -ne $false -or $distributedEssbase -eq $true -and $remoteDeployment -eq $false){
                Write-Host "Adding Central Provider to config file" -ForegroundColor green
                $apsConfigureSilent =  Get-Content -Path "$($installerPath)\Variables\Property Files\11.1.2.4\Config\Distributed\Central\aps" -Raw
                $apsConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($apsConfigureSilent)
            } 
            if($configEPMA -ne $false){
                Write-Host "Adding Central EPMA to config file" -ForegroundColor green
                $bpmaConfigureSilent = Get-Content -Path "$($installerPath)\Variables\Property Files\11.1.2.4\Config\Distributed\Central\epma" -Raw
                $bpmaConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($bpmaConfigureSilent)
            }
            if($configEssbase -ne $false -or $distributedEssbase -eq $true -and $remoteDeployment -eq $false){
                Write-Host "Adding Central Essbase Studio to config file" -ForegroundColor green
                $bpmsConfigureSilent = Get-Content -Path "$($installerPath)\Variables\Property Files\11.1.2.4\Config\Distributed\Central\essbaseStudio" -Raw
                $bpmsConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($bpmsConfigureSilent)
            }
            if($configCALC -ne $false){
                Write-Host "Adding Central CALC to config file" -ForegroundColor green
                $calcConfigureSilent = Get-Content -Path "$($installerPath)\Variables\Property Files\11.1.2.4\Config\Distributed\Central\calc" -Raw
                $calcConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($calcConfigureSilent)
            }
            if($configDisclosure -ne $false){
                Write-Host "Adding Central Disclosure to config file" -ForegroundColor green
                $disclosureConfigureSilent = Get-Content -Path "$($installerPath)\Variables\Property Files\11.1.2.4\Config\Distributed\Central\disclosure" -Raw
                $disclosureConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($disclosureConfigureSilent)
            }
            if($configEssbase -ne $false -or $distributedEssbase -eq $true -and $remoteDeployment -eq $false){
                Write-Host "Adding Central EAS to config file" -ForegroundColor green
		$easConfigureSilent = Get-Content -Path "$($installerPath)\Variables\Property Files\11.1.2.4\Config\Distributed\Central\eas" -Raw
                $easConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($easConfigureSilent)
            }
            if($configEssbase -ne $false -or $distributedEssbase -eq $true -and $remoteDeployment -eq $false){
                Write-Host "Skipping Essbase configuration.. please configure on remote server" -ForegroundColor yellow
                $essbaseServerConfigureSilent = ''
            } elseif($configEssbase -eq $false -and $remoteDeployment -eq $true -and $distributedEssbase -eq $true) {
                Write-Host "Adding Remote Essbase to config file" -ForegroundColor green
                $essbaseServerConfigureSilent = Get-Content -Path "$($installerPath)\Variables\Property Files\11.1.2.4\Config\Distributed\Remote\essbase" -Raw
                $essbaseServerConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($essbaseServerConfigureSilent)
            }
            if($strategic -eq $true){
                Write-Host "Adding Central Strategic to config file" -ForegroundColor green
                $strategicConfigureSilent = Get-Content -Path "$($installerPath)\Variables\Property Files\11.1.2.4\Config\Distributed\Central\strategic" -Raw
                $strategicConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($strategicConfigureSilent)
            }
            if($configPlanning -ne $false -and $distributedPlanning -eq $true){
                Write-Host "Skipping Planning config.. Please configure on remote server." -ForegroundColor yellow
                $planningConfigureSilent = '' 
            } elseif($configPlanning -ne $false -and $distributedPlanning -ne $true) {
                Write-Host "Adding Standalone Planning to config file" -ForegroundColor green
                $planningConfigureSilent = Get-Content -Path "$($installerPath)\Variables\Property Files\11.1.2.4\Config\Standalone\planning" -Raw
                $planningConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($planningConfigureSilent)
            }
            if($configProfit -ne $false){
                Write-Host "Adding Central Profit to config file" -ForegroundColor green
                $profitConfigureSilent = Get-Content -Path "$($installerPath)\Variables\Property Files\11.1.2.4\Config\Distributed\Central\profit" -Raw
                $profitConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($profitConfigureSilent)
            }
            if($configRAF -ne $false){
                Write-Host "Adding Central RAF to config file" -ForegroundColor green
                $rafConfigureSilent = Get-Content -Path "$($installerPath)\Variables\Property Files\11.1.2.4\Config\Distributed\Central\raf" -Raw
                $rafConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($rafConfigureSilent)
            }
            if($configFoundation -ne $false -and $remoteDeployment -ne $true){
                Write-Host "Adding Central Workspace to config file" -ForegroundColor green
                $workspaceConfigureSilent = Get-Content -Path "$($installerPath)\Variables\Property Files\11.1.2.4\Config\Distributed\Central\workspace" -Raw 
                $workspaceConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($workspaceConfigureSilent) 
            }
            if($configFDM -ne $false -and $distributedFDM -eq $true){
                Write-Host "Skipping FDM config.. Please configure on remote server." -ForegroundColor yellow
                $fdmConfigureSilent = ''
            } elseif($configFDM -ne $false -and $distributedFDM -ne $true) {
                Write-Host "Adding Central FDM to config file" -ForegroundColor green
                $fdmConfigureSilent = Get-Content -Path "$($installerPath)\Variables\Property Files\11.1.2.4\Config\Distributed\Central\fdm" -Raw 
                $fdmConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($fdmConfigureSilent) 
            }
            if($configHFM -ne $false -or $distributedHFM -ne $false -and $remoteDeployment -eq $false){
                Write-Host "Skipping HFM config.. Please configure on remote server." -ForegroundColor yellow
                $hfmConfigureSilent = ''
           } elseif($configHFM -ne $false -and $distributedHFM -ne $true) {
                Write-Host "Adding Standalone HFM to config file" -ForegroundColor green
                $hfmConfigureSilent = Get-Content -Path "$($installerPath)\Variables\Property Files\11.1.2.4\Config\Standalone\hfm" -Raw
                $hfmConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($hfmConfigureSilent)
           }
        } elseif($distributedEssbase -eq $true -or $distributedPlanning -eq $true -or $distributedFDM -eq $true -or $distributedHFM -eq $true -and $remoteDeployment -eq $true){
            Write-Host "Starting Distributed Remote Configuration" -ForegroundColor cyan
            if($remoteDeployment -and $remoteDeployment -eq $true){
                Write-Host "Adding Remote Header to config file" -ForegroundColor green
                $headerConfigureSilent = Get-Content -Path "$($installerPath)\Variables\Property Files\11.1.2.4\Config\Distributed\remote\header" -Raw
                $headerConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($headerConfigureSilent)
            } elseif(!$remoteDeployment -or $remoteDeployment -eq $false) {
                Write-Host "Adding Central Header to config file" -ForegroundColor green
                $headerConfigureSilent = Get-Content -Path "$($installerPath)\Variables\Property Files\11.1.2.4\Config\Distributed\central\header" -Raw
                $headerConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($headerConfigureSilent)
            }
            if($configFoundation -eq $false -and $firstStage -ne $true -and $remoteDeployment -eq $true){
                Write-Host "Adding Remote Foundation to config file" -ForegroundColor green
                $fndConfigureSilent = Get-Content -Path "$($installerPath)\Variables\Property Files\11.1.2.4\Config\Distributed\Remote\foundation" -Raw
                $fndConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($fndConfigureSilent)
            } 
            if($configEssbase -ne $false -or $distributedEssbase -eq $true -and $remoteDeployment -eq $false){
                Write-Host "Adding Central Provider to config file" -ForegroundColor green
                $apsConfigureSilent =  Get-Content -Path "$($installerPath)\Variables\Property Files\11.1.2.4\Config\Distributed\Central\aps" -Raw
                $apsConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($apsConfigureSilent)
            } 
            if($configEPMA -ne $false){
                Write-Host "Adding Central EPMA to config file" -ForegroundColor green
                $bpmaConfigureSilent = Get-Content -Path "$($installerPath)\Variables\Property Files\11.1.2.4\Config\Distributed\Central\epma" -Raw
                $bpmaConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($bpmaConfigureSilent)
            }
            if($configEssbase -ne $false -or $distributedEssbase -eq $true -and $remoteDeployment -eq $false){
                Write-Host "Adding Central Essbase Studio to config file" -ForegroundColor green
                $bpmsConfigureSilent = Get-Content -Path "$($installerPath)\Variables\Property Files\11.1.2.4\Config\Distributed\Central\essbaseStudio" -Raw
                $bpmsConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($bpmsConfigureSilent)
            }
            if($configCALC -ne $false){
                Write-Host "Adding Central CALC to config file" -ForegroundColor green
                $calcConfigureSilent = Get-Content -Path "$($installerPath)\Variables\Property Files\11.1.2.4\Config\Distributed\Central\calc" -Raw
                $calcConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($calcConfigureSilent)
            }
            if($configDisclosure -ne $false){
                Write-Host "Adding Central Disclosure to config file" -ForegroundColor green
                $disclosureConfigureSilent = Get-Content -Path "$($installerPath)\Variables\Property Files\11.1.2.4\Config\Distributed\Central\disclosure" -Raw
                $disclosureConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($disclosureConfigureSilent)
            }
            if($configEssbase -ne $false -or $distributedEssbase -eq $true -and $remoteDeployment -eq $false){
                Write-Host "Adding Central EAS to config file" -ForegroundColor green
                $easConfigureSilent = Get-Content -Path "$($installerPath)\Variables\Property Files\11.1.2.4\Config\Distributed\Central\eas" -Raw
                $easConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($easConfigureSilent)
            }
            if($configEssbase -ne $false -or $distributedEssbase -eq $false -and $remoteDeployment -eq $false){
                Write-Host "Adding Standalone Essbase to config file" -ForegroundColor green
                $essbaseServerConfigureSilent = Get-Content -Path "$($installerPath)\Variables\Property Files\11.1.2.4\Config\Standalone\essbase" -Raw
                $essbaseServerConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($essbaseServerConfigureSilent)
            } elseif($configEssbase -eq $false -and $remoteDeployment -eq $true -and $distributedEssbase -eq $true) {
                Write-Host "Adding Remote Essbase to config file" -ForegroundColor green
                $essbaseServerConfigureSilent = Get-Content -Path "$($installerPath)\Variables\Property Files\11.1.2.4\Config\Distributed\Remote\essbase" -Raw
                $essbaseServerConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($essbaseServerConfigureSilent)
            }
            if($strategic -eq $true){
                Write-Host "Adding Central Strategic to config file" -ForegroundColor green
                $strategicConfigureSilent = Get-Content -Path "$($installerPath)\Variables\Property Files\11.1.2.4\Config\Distributed\Central\strategic" -Raw
                $strategicConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($strategicConfigureSilent)
            }
            if($configPlanning -ne $false -and $distributedPlanning -eq $true -and $remoteDeployment -ne $true){
                Write-Host "Adding Central Planning to config file" -ForegroundColor green
                $planningConfigureSilent = Get-Content -Path "$($installerPath)\Variables\Property Files\11.1.2.4\Config\Distributed\Central\planning" -Raw
                $planningConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($planningConfigureSilent)
            } elseif($configPlanning -ne $false -and $distributedPlanning -eq $true -and $remoteDeployment -eq $true) {
                Write-Host "Adding Remote Planning to config file" -ForegroundColor green
                $planningConfigureSilent = Get-Content -Path "$($installerPath)\Variables\Property Files\11.1.2.4\Config\Distributed\Remote\planning" -Raw
                $planningConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($planningConfigureSilent)
            }
            if($configProfit -ne $false){
                Write-Host "Addding Central Profit to config file" -ForegroundColor green
                $profitConfigureSilent = Get-Content -Path "$($installerPath)\Variables\Property Files\11.1.2.4\Config\Distributed\Central\profit" -Raw
                $profitConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($profitConfigureSilent)
            }
            if($configRAF -ne $false){
                Write-Host "Adding Central RAF to config file" -ForegroundColor green
                $rafConfigureSilent = Get-Content -Path "$($installerPath)\Variables\Property Files\11.1.2.4\Config\Distributed\Central\raf" -Raw
                $rafConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($rafConfigureSilent)
            }
            if($configFoundation -ne $false -and $remoteDeployment -ne $true){
            }
            if($configFDM -ne $false -and $distributedFDM -eq $true -and $remoteDeployment -ne $true){
                Write-Host "Adding Central FDM to config file" -ForegroundColor green
                $fdmConfigureSilent = Get-Content -Path "$($installerPath)\Variables\Property Files\11.1.2.4\Config\Distributed\Central\fdm" -Raw 
                $fdmConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($fdmConfigureSilent) 
            } elseif($configFDM -ne $false -and $distributedFDM -eq $true -and $remoteDeployment -eq $true) {
                Write-Host "Adding Remote FDM config file" -ForegroundColor green
                $fdmConfigureSilent = Get-Content -Path "$($installerPath)\Variables\Property Files\11.1.2.4\Config\Distributed\Remote\fdm" -Raw 
                $fdmConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($fdmConfigureSilent) 
            }
            if($configHFM -ne $false -or $distributedHFM -eq $true -and $remoteDeployment -eq $false){
                Write-Host "Adding Central HFM to config file" -ForegroundColor green
                $hfmConfigureSilent = Get-Content -Path "$($installerPath)\Variables\Property Files\11.1.2.4\Config\Distributed\Central\hfm" -Raw
                $hfmConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($hfmConfigureSilent)
           } elseif($configHFM -eq $false -and $distributedHFM -eq $true -and $remoteDeployment -eq $true) {
                Write-Host "Adding Remote HFM to config file" -ForegroundColor green
                $hfmConfigureSilent = Get-Content -Path "$($installerPath)\Variables\Property Files\11.1.2.4\Config\Distributed\Remote\hfm" -Raw
                $hfmConfigureSilent = $ExecutionContext.InvokeCommand.ExpandString($hfmConfigureSilent)
           }
        }
    }
    #endregion

#endregion

#region configure EPM

    if($inputCALCDB -eq $null -and $inputEPMADB -eq $null) {

  $data = "$($headerConfigureSilent)
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

    $data = "$($headerConfigureSilent)
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

    $data = "$($headerConfigureSilent)
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

    $data = "$($headerConfigureSilent)
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
  $($workspaceConfigureSilent)
  $($bpmaConfigureSilent)
  $($calcConfigureSilent)
</products>
"
    
    $data | Out-File "$($installerPath)\Temp\silentConfigure" -Encoding utf8
    $silentConfigureFile = Get-Content "$($installerPath)\Temp\silentConfigure"
    $Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
    [System.IO.File]::WriteAllLines("$($installerPath)\Temp\silentConfigure", $silentConfigureFile, $Utf8NoBomEncoding)

    try {
    Write-Host "Configuring EPM. This may take 30 - 45 Minutes." -ForegroundColor Cyan
    Start-Process -FilePath "$($epmInstallPath)\EPMSystem11R1\common\config\11.1.2.0\configtool.bat" -Wait -ArgumentList "-silent $($installerPath)\Temp\silentConfigure" -Verb RunAs -Verbose
    }
    catch {
        $_ | Out-File "$($installerPath)\Logs\configTool.Error.log" -Append
        Get-Content "$($installerPath)\Logs\configTool.Error.log" | Write-Host -ForegroundColor Red
        Read-Host "Click enter to exit"
        Exit
    }

#endregion 

#region if any distributed -and remoteDeployment -eq false
    if($distributedHFM -eq $true -or $distributedFDM -eq $true -or $distributedPLN -eq $true -or $distributedESB -eq $true -and $remoteDeployment -eq $false){
    	try {
	     Write-Host "Starting Admin Server for Remote Deployments" -ForegroundColor Cyan
	     Start-Process -FilePath "$($epmInstallPath)\user_projects\domains\EPMSystem\bin\startWebLogic.cmd" -Verb RunAs -Verbose
	} catch {
	    $_ | Out-File "$($installerPath)\Logs\startAdminServer.Error.log" -Append
            Get-Content "$($installerPath)\Logs\startAdminServer.Error.log" | Write-Host -ForegroundColor Red
            Read-Host "Click enter to exit"
            Exit
	}
    }

#endregion 

#region start epm and validate

    if($startEPM -eq $true){
        try {
            Write-Host "Starting EPM." -ForegroundColor Cyan
            Start-Process -FilePath "$($epmInstallPath)\user_projects\epmsystem1\bin\start.bat" -Wait -Verb RunAs -Verbose
        }
        catch {
            $_ | Out-File "$($installerPath)\Logs\startEPM.Error.log" -Append
            Get-Content "$($installerPath)\Logs\startEPM.Error.log" | Write-Host -ForegroundColor Red
            Read-Host "Click enter to exit"
            Exit
        }
        if($validate -eq $true){
            try {
                Write-Host "Validating EPM." -ForegroundColor Cyan
                Start-Process -FilePath "$($epmInstallPath)\user_projects\epmsystem1\bin\validate.bat" -Wait -Verb RunAs -Verbose
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

#region export common settings if not remote
    
    if($remoteDeployment -ne $true){
        $commonSettings = @()
        foreach($i in $dbProperties){
            [PSObject]$property = Invoke-SQLcmd -ConnectionString "Server=$($dbServer);User Id=$($dbUser);Password=$($dbPassword);Database=$($foundationDB)" -Query "SELECT PROPERTY_NAME,PROPERTY_VALUE FROM HSS_COMPONENT_PROPERTY_VALUES WHERE PROPERTY_NAME = '$($i)'"
            $commonSettings += $property
        }
        $commonSettings | Export-Csv "$($installerPAth)\Temp\commonSettings.csv"
    }

#endregion

#region announce completion 
	Write-Host '


 ______   ______   __    __   ______  __       ______  ______  ______    
/\  ___\ /\  __ \ /\ "-./  \ /\  == \/\ \     /\  ___\/\__  _\/\  ___\   
\ \ \____\ \ \/\ \\ \ \-./\ \\ \  _-/\ \ \____\ \  __\\/_/\ \/\ \  __\   
 \ \_____\\ \_____\\ \_\ \ \_\\ \_\   \ \_____\\ \_____\ \ \_\ \ \_____\ 
  \/_____/ \/_____/ \/_/  \/_/ \/_/    \/_____/ \/_____/  \/_/  \/_____/ 
                                                                         
									 
 ' -ForegroundColor magenta

#endregion
