[CmdletBinding(DefaultParametersetName='none')] 
Param (
  #parameter sets
  [Parameter(ParameterSetName='superSilentInstall',Mandatory=$False)] [switch]$superSilentInstall,
  [Parameter(ParameterSetName='superSilentConfig',Mandatory=$False)] [switch]$superSilentConfig,
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$False)] [switch]$superSilentAll,


  #params
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$False)]
  [Parameter(ParameterSetName='superSilentInstall',Mandatory=$False)] [bool]$install7zip,
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$False)]
  [Parameter(ParameterSetName='superSilentInstall',Mandatory=$False)] [bool]$installnotepadPlus,
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$False)]
  [Parameter(ParameterSetName='superSilentInstall',Mandatory=$False)] [bool]$installfirefox,
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$False)]
  [Parameter(ParameterSetName='superSilentInstall',Mandatory=$False)] [bool]$installIIS,
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$False)]
  [Parameter(ParameterSetName='superSilentInstall',Mandatory=$False)] [bool]$installNetFrame,
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$True)]
  [Parameter(ParameterSetName='superSilentInstall',Mandatory=$True)] [bool]$installepm,
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$True)]
  [Parameter(ParameterSetName='superSilentInstall',Mandatory=$True)] [string]$epmPath,
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$False)]
  [Parameter(ParameterSetName='superSilentInstall',Mandatory=$False)] [bool]$installfoundation,
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$False)]
  [Parameter(ParameterSetName='superSilentInstall',Mandatory=$False)] [bool]$installessbase,
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$False)]
  [Parameter(ParameterSetName='superSilentInstall',Mandatory=$False)] [bool]$installraf,
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$False)]
  [Parameter(ParameterSetName='superSilentInstall',Mandatory=$False)] [bool]$installplanning,
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$False)]
  [Parameter(ParameterSetName='superSilentInstall',Mandatory=$False)] [bool]$installdisclosure,
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$False)]
  [Parameter(ParameterSetName='superSilentInstall',Mandatory=$False)] [bool]$installhfm,
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$False)]
  [Parameter(ParameterSetName='superSilentInstall',Mandatory=$False)] [bool]$installfdm,
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$False)]
  [Parameter(ParameterSetName='superSilentInstall',Mandatory=$False)] [bool]$installprofit,
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$False)]
  [Parameter(ParameterSetName='superSilentInstall',Mandatory=$False)] [bool]$installfcm,
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$False)]
  [Parameter(ParameterSetName='superSilentInstall',Mandatory=$False)] [bool]$installtax,
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$False)]
  [Parameter(ParameterSetName='superSilentInstall',Mandatory=$False)] [bool]$installstrategic,
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$True)]
  [Parameter(ParameterSetName='superSilentConfig',Mandatory=$True)] [string]$dbServer,
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$True)]
  [Parameter(ParameterSetName='superSilentConfig',Mandatory=$True)] [string]$dbPort,
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$True)]
  [Parameter(ParameterSetName='superSilentConfig',Mandatory=$True)] [string]$dbUser,
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$True)]
  [Parameter(ParameterSetName='superSilentConfig',Mandatory=$True)] [string]$dbPassword,
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$True)]
  [Parameter(ParameterSetName='superSilentConfig',Mandatory=$True)] [string]$wkspcAdmin,
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$True)]
  [Parameter(ParameterSetName='superSilentConfig',Mandatory=$True)] [string]$wkspcAdminPassword,
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$True)]
  [Parameter(ParameterSetName='superSilentConfig',Mandatory=$True)] [string]$weblogicAdmin,
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$True)]
  [Parameter(ParameterSetName='superSilentConfig',Mandatory=$True)] [string]$weblogicPort,
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$True)]
  [Parameter(ParameterSetName='superSilentConfig',Mandatory=$True)] [string]$weblogicHostname,
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$True)]
  [Parameter(ParameterSetName='superSilentConfig',Mandatory=$True)] [string]$wkspcPort,
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$True)]
  [Parameter(ParameterSetName='superSilentConfig',Mandatory=$True)] [string]$epmDomain,
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$True)]
  [Parameter(ParameterSetName='superSilentConfig',Mandatory=$True)] [string]$foundationDB,
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$False)]
  [Parameter(ParameterSetName='superSilentInstall',Mandatory=$False)]
  [Parameter(ParameterSetName='superSilentConfig',Mandatory=$False)] [bool]$distributedEssbase,
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$False)]
  [Parameter(ParameterSetName='superSilentInstall',Mandatory=$False)]
  [Parameter(ParameterSetName='superSilentConfig',Mandatory=$False)] [bool]$distributedHFM,
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$False)]
  [Parameter(ParameterSetName='superSilentInstall',Mandatory=$False)]
  [Parameter(ParameterSetName='superSilentConfig',Mandatory=$False)] [bool]$distributedFDM,
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$False)]
  [Parameter(ParameterSetName='superSilentInstall',Mandatory=$False)]
  [Parameter(ParameterSetName='superSilentConfig',Mandatory=$False)] [bool]$distributedPlanning,
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$False)]
  [Parameter(ParameterSetName='superSilentInstall',Mandatory=$False)]
  [Parameter(ParameterSetName='superSilentConfig',Mandatory=$False)] [bool]$remoteDeployment,
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$False)]
  [Parameter(ParameterSetName='superSilentConfig',Mandatory=$False)] [string]$epmaDB,
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$False)]
  [Parameter(ParameterSetName='superSilentConfig',Mandatory=$False)] [string]$calcDB,
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$False)]
  [Parameter(ParameterSetName='superSilentConfig',Mandatory=$False)] [string]$essbaseDB,
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$False)]
  [Parameter(ParameterSetName='superSilentConfig',Mandatory=$False)] [string]$rafDB,
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$False)]
  [Parameter(ParameterSetName='superSilentConfig',Mandatory=$False)] [string]$planningDB,
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$False)]
  [Parameter(ParameterSetName='superSilentConfig',Mandatory=$False)] [string]$disclosureDB,
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$False)]
  [Parameter(ParameterSetName='superSilentConfig',Mandatory=$False)] [string]$hfmDB,
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$False)]
  [Parameter(ParameterSetName='superSilentConfig',Mandatory=$False)] [string]$fdmDB,
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$False)]
  [Parameter(ParameterSetName='superSilentConfig',Mandatory=$False)] [string]$profitDB,
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$True)]
  [Parameter(ParameterSetName='superSilentConfig',Mandatory=$True)] [bool]$strategic,
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$False)]
  [Parameter(ParameterSetName='superSilentConfig',Mandatory=$False)] [bool]$startEPM,
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$False)]
  [Parameter(ParameterSetName='superSilentConfig',Mandatory=$False)] [bool]$validate
)


#region installer important info notice
    
    if($superSilentInstall -or $superSilentInstall -or $superSilentConfig){
        Write-Host 'Thank you for using the EPM silent installer/configuration utility. Please note the following requirments and limitations before continuing:
        Warning:
        1. This utility is still in BETA. Continue at your own RISK.

        Requirments:
        1. You must be a local Administrator.
        2. 7-zip must be installed. The utility will install for you but if you opt out of that feature the script will error out.
    
        Limitations:
        1. This utility should not be used on an environment that has already been configured.
        2. Oracle DB is currently not supported.
        3. 100% Customization is not currently supported. Only common settings can be configured (ex. database name, host, port, smtp, more..)
        4. SOA Products like Tax Management and Financial Close Manager are not supported.' -ForegroundColor Magenta
        Read-Host "Click enter to continue"
    } else {
        [System.Windows.MessageBox]::Show('Thank you for using the EPM silent installer/configuration utility. Please note the following requirments and limitations before continuing:
        Warning:
        1. This utility is still in BETA. Continue at your own RISK.

        Requirments:
        1. You must be a local Administrator.
        2. 7-zip must be installed. The utility will install for you but if you opt out of that feature the script will error out.
    
        Limitations:
        1. This utility should not be used on an environment that has already been configured.
        2. Oracle DB is currently not supported.
        3. 100% Customization is not currently supported. Only common settings can be configured (ex. database name, host, port, smtp, more..)
        4. SOA Products like Tax Management and Financial Close Manager are not supported.
    
        Click ok to continue..')
    }

#endregion

#region check current directory

    $currentPath = pwd
    $currentPathChildItems = Get-ChildItem -Path $currentPath
    if($currentPathChildItems.name -notcontains "start.ps1" -and $currentPathChildItems.name -notcontains "install.ps1" -and $currentPathChildItems.name -notcontains "configure.ps1") {
        Write-Host "Working directory is incorrect. Please start script from the powershell folder in the utility directory." -ForegroundColor Red
        Read-Host "Press enter to exit"
        Exit
    } else {
        Write-Host "Working directory is correct. Continuing.." -ForegroundColor Green
        $installerPath = "$currentPath\..\"
    }

#endregion

#region start transcript

    Start-Transcript -Path "$($installerPath)\Logs\transcript.log"

#endregion

#region test script running as admin

    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    if($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator) -eq $false){
        Write-Host "Must run utility as administrator. Exiting.." -ForegroundColor Red
        Read-Host "Click enter to exit."
        exit
    } else {
        Write-Host "Utility running as administrator. Continuing.." -ForegroundColor Green
    }

#endregion

#region check execution policy

    $executionPolicy = Get-ExecutionPolicy
    if($executionPolicy -ne 'Unrestricted'){
        Write-Host "Execution Policy is not set correctly. Changing to Unrestricted.." -ForegroundColor Cyan
        Set-ExecutionPolicy Unrestricted -Force
    } else {
        Write-Host "Execution Policy is correct. Continuing" -ForegroundColor Green
    }

#endregion

#region parse silent params and validate
    
    #set install and config to true if superSilentAll is present
    if($superSilentAll.IsPresent -eq $true){
        $superSilentInstall = $true
        $superSilentConfig = $true
    }
	
    #check if any products are distributed and if remoteDeployment is false
	if($distributedEssbase -or $distributedFDM -or $distributedHFM -or $distributedPlanning){
		if($remoteDeployment -eq $false){
			$firstStage = $true
		}
	}

    #check if password meets oracle requirements
    if($superSilentAll.IsPresent -eq $true -or $superSilentConfig -eq $true -or $superSilentConfig.IsPresent -eq $true){
        if($wkspcAdminPassword.Length -lt 8 -or $wkspcAdminPassword -notmatch ".*\w+.*" -or $wkspcAdminPassword -notmatch '[^a-zA-Z]|.*\d+.*'){
           Write-Host "Workspace admin password does not meet the minimum requirements. Password must be alphanumeric, and at least 8 characters." -ForegroundColor Red
           Read-Host "Click enter to exit"
           exit
        }
    }

    #check if any product is distributed and announces that remoteDeployment is required then exits
    if($distributedEssbase -or $distributedHFM -or $distributedFDM -or $distributedPlanning){
        if($remoteDeployment -ne $true -and $remoteDeployment -ne $false){
            Write-Host "Distributed environments require -remoteDeployment (true | false)" -ForegroundColor Red
            Read-Host "Click enter to exit"
            Exit            
        }
    }

    #check if remoteDeployment is true and sets configFoundation to false
    if($remoteDeployment -eq $true){
        $configFoundation = $false
    }

    #check if distributedEssbase is true and sets configEssbase to false
    if($distributedEssbase -eq $true){
        $configEssbase = $false
    }
    
    #check if distributedHFM is true and sets configHFM to false
    if($distributedHFM -eq $true){
        $configHFM = $false
    } 
    #else if $hfmDB is missing set configHFM to false
    elseif(!$hfmDB){
        $configHFM = $false
    }

    #check if switch epmaDB is missing and sets configEPMA to false
    if(!$epmaDB){
        $configEPMA = $false
    }

    #check if switch calcDB is missing and sets configCALC to false
    if(!$calcDB){
        $configCALC = $false
    }

    #check if switch essbaseDB is missing and sets configEssbase to false
    if(!$essbaseDB){
        $configEssbase = $false
    }

    #check if switch rafDB is missing and sets configRAF to false
    if(!$rafDB){
        $configRAF = $false
    }

    #check if switch planningDB is missing and sets configPlanning to false
    if(!$planningDB){
        $configPlanning = $false
    }

    #check if switch disclosureDB is missing and sets configDisclosure to false
    if(!$disclosureDB){
        $configDisclosure = $false
    }

    #check if fdmDB is missing and sets configFDM to false
    if(!$fdmDB){
        $configFDM = $false
    }

    #check if profitDB is missing and sets configProfit to false
    if(!$profitDB){
        $configProfit = $false
    }

    #check if any products are distributed, if so sets standalone to true
    if($distributedEssbase -ne $true -and $distributedHFM -ne $true -and $distributedFDM -ne $true -and $distributedPlanning -ne $true){
        $standalone = $true
    }

    #region check if install switches are missing, if so set install switch to false

        if(!$install7zip){
            $install7zip = $false
        }
        if(!$installnotepadPlus){
            $installnotepadPlus = $false
        }
        if(!$installfirefox){
            $installfirefox = $false
        }
        if(!$install7zip){
            $install7zip = $false
        }
        if(!$installIIS){
            $installIIS = $false
        }
        if(!$installNetFrame){
            $installNetFrame = $false
        }
        if(!$installfoundation){
            $installfoundation = $false
        }
        if(!$installessbase){
            $installessbase = $false
        }
        if(!$installraf){
            $installraf = $false
        }
        if(!$installplanning){
            $installplanning = $false
        }
        if(!$installdisclosure){
            $installdisclosure = $false
        }
        if(!$installhfm){
            $installhfm = $false
        }
        if(!$installfdm){
            $installfdm = $false
        }
        if(!$installprofit){
            $installprofit = $false
        }
        if(!$installfcm){
            $installfcm = $false
        }
        if(!$installtax){
            $installtax = $false
        }
        if(!$installtax){
            $installstrategic = $false
        }

    #endregion
    
#endregion

#region check if UAC is disabled
   
    $uacSetting = Get-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin
    if($uacSetting.ConsentPromptBehaviorAdmin -ne 0){
        Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 0
        Write-Host "UAC is not disabled. Disabling now... Reboot required to commit change. Please rerun utility after your server restarts." -ForegroundColor Cyan
        $restartPrompt = Read-Host "Restart (Y or N)"
        if($restartPrompt -like '*y*'){
            Write-Host "Restarting server.." -ForegroundColor Cyan
            Restart-Computer
        } elseif($restartPrompt -like '*n*'){
            Write-Host "Exiting.." -ForegroundColor Cyan
            Exit
        }
    } else {
        Write-Host "UAC is already disabled. Continuing.." -ForegroundColor Green
    }

#endregion

#region increase powershell memory limit
    
    $currentPSMemoryLimit = Get-Item WSMan:\localhost\Shell\MaxMemoryPerShellMB
    $currentPSPluginMemoryLimit = Get-Item WSMan:\localhost\Plugin\Microsoft.PowerShell\Quotas\MaxMemoryPerShellMB
    if($currentPSMemoryLimit.value -lt 6144 -or $currentPSPluginMemoryLimit.value -lt 6144){
        Write-Host "Powershell max memory per shell limit too low, raising limit.." -ForegroundColor Cyan
        Set-Item WSMan:\localhost\Shell\MaxMemoryPerShellMB 6144
        Set-Item WSMan:\localhost\Plugin\Microsoft.PowerShell\Quotas\MaxMemoryPerShellMB 6144
        Restart-Service -Name WinRM -Verbose
    }

#endregion

#region install assembly and choco
    
    if (Get-Command choco -errorAction SilentlyContinue){
        if($superSilentConfig.IsPresent -eq $True){
            Add-Type -AssemblyName PresentationFramework
            Invoke-Command -ScriptBlock $choco *> $null
            choco upgrade chocolatey $choco *> $null
        }
    } else {
        Write-Host "Choco already installed. Continuing.." -ForegroundColor Green
    }

#endregion

#region install .net framework 3.5

    if($installNetFrame -eq $true){
        if($superSilentConfig.IsPresent -eq $false){
            $netFrameworkInstall = Get-WindowsFeature -Name Net-Framework-Core
            if($netFrameworkInstall.Installed -ne $true){
                Write-Host ".Net Framework 3.5 is not installed. Installing now.." -ForegroundColor Cyan
                choco install dotnet3.5 -y
            } else {
                Write-Host ".Net Framework 3.5 is already installed. Continuing.." -ForegroundColor Green
            }
        }
    }

#endregion

#region install iis
    
    if($installIIS -eq $true){
        if($superSilentConfig.IsPresent -eq $false -or $superSilentConfig -eq $false){
            $iisInstall = Get-WindowsFeature -Name Web-server
            if($iisInstall.Installed -ne $true){ 
                Write-Host "IIS is not installed. Installing now.." -ForegroundColor Cyan
                Install-WindowsFeature -Name Web-Server -IncludeAllSubFeature -IncludeManagementTools
            } else {
                Write-Host "IIS is already installed. Continuing" -ForegroundColor Green
            }
        }
    }
#endregion

#region set mainVariables and mainFunctions
    
    Unblock-File -Path "$($installerPath)\Variables\mainVariables.ps1"
    Unblock-File -Path "$($installerPath)\Functions\mainfunctions.ps1"
    . "$($installerPath)\Variables\mainVariables.ps1"
    . "$($installerPath)\Functions\mainfunctions.ps1"

#endregion

#region look for current programs and hyperion

    #build software install array
    $installedSoftware = Get-Software
    $7zipStatus = New-Object PSObject
    $7zipStatus | Add-Member -MemberType NoteProperty -Name Name -Value "7-Zip"
    $7zipStatus | Add-Member -MemberType NoteProperty -Name chocoName -Value "7zip"
    $firefoxStatus = New-Object PSObject
    $firefoxStatus | Add-Member -MemberType NoteProperty -Name Name -Value "Firefox"
    $firefoxStatus | Add-Member -MemberType NoteProperty -Name chocoName -Value "firefox"
    $notepadStatus = New-Object PSObject
    $notepadStatus | Add-Member -MemberType NoteProperty -Name Name -Value "Notepad++"
    $notepadStatus | Add-Member -MemberType NoteProperty -Name chocoName -Value "notepadplusplus"
    $epmStatus = New-Object PSObject
    $epmStatus | Add-Member -MemberType NoteProperty -Name Name -Value "Oracle EPM"
    foreach($i in $installedSoftware) {
        
        #look for 7zip
        if($i.DisplayName -like "*7-Zip*") {
            $7zipStatus | Add-Member -MemberType NoteProperty -Name Installed -Value $true
        }

        #look for firefox
        if($i.DisplayName -like "*Firefox*") {
            $firefoxStatus | Add-Member -MemberType NoteProperty -Name Installed -Value $true
        }

        #look for notepad++
        if($i.DisplayName -like "*Notepad++*") {
            $notepadStatus | Add-Member -MemberType NoteProperty -Name Installed -Value $true
        }

         #look for epm
        if($i.DisplayName -like "*Oracle EPM*") {
            $epmStatus | Add-Member -MemberType NoteProperty -Name Installed -Value $true
        }
    }

#endregion

#region prompt user
    
    #check if silent switches are  false, if so start interactive  mode
    if($superSilentInstall -eq $false -or $superSilentConfig -eq $false){
        $softwareStatus = @($7zipStatus,$firefoxStatus,$notepadStatus)
        foreach($j in $softwareStatus){
            if($j.installed -eq $true) {
                Write-Host "$($j.name) is already installed. Skipping.." -ForegroundColor Green
            }

            else {
                Write-Host "$($j.name) is not installed." -ForegroundColor Yellow
                while($break -eq $null){
                    switch(Read-Host "Would you like me to install $($j.name) for you? Y or N"){
                        "Y" {
                            ""
                            $installFile = $j.name + 'Installer.exe'
                            Write-Host "Installing $($j.name).." -ForegroundColor Cyan
                            #Start-Process -FilePath "$($installerPath)\Third Party\$($installFile)" -Wait
                            choco install $j.chocoName -y
                            $break = 'break'
                        }
                        "N" {
                            ""
                            Write-Host "Skipping $($j.name).." -ForegroundColor Yellow
                            $break = 'break'
                        }
                        Default {
                            ""
                            Write-Host "Invalid entry. Please try again.." -ForegroundColor Red
                        }
                    }
                }
            }
            if($break){
                Clear-Variable break
            }
        }
        if($break){
            Clear-Variable break
        }

        if($epmStatus.installed -eq $true){
            Write-Host "$($epmStatus.name) is already installed. Skipping.." -ForegroundColor Green
            while($break -eq $null){
                switch(Read-Host "EPM is already installed. Would you like to configure EPM? Y or N"){
                    "Y" {
                        ""
                        Write-Host "Starting $($epmStatus.name).. configuration procedure" -ForegroundColor Cyan
                        Invoke-Expression -Command "$($installerPath)/Powershell/configure.ps1" -Verbose
                        $break = 'break'
                    }
                    "N" {
                        ""
                        Write-Host "Skipping $($epmStatus.name) configuration.." -ForegroundColor Yellow
                        $break = 'break'
                    }
                    Default {
                        ""
                        Write-Host "Invalid entry. Please try again.." -ForegroundColor Red
                    }
                }
            }
            if($break){
                Clear-Variable break
            }
        }
        else {
            Write-Host "$($epmStatus.name) is not installed." -ForegroundColor Yellow
            while($break -eq $null){
                switch(Read-Host "Would you like me to install $($epmStatus.name) for you? Y or N"){
                    "Y" {
                        ""
                        Write-Host "Starting $($epmStatus.name) installation procedure.." -ForegroundColor Cyan
                        Invoke-Expression -Command "$($installerPath)/Powershell/install.ps1" -Verbose
                        $break = 'break'
                    }
                    "N" {
                        ""
                        Write-Host "Skipping $($epmStatus.name) installation.." -ForegroundColor Yellow
                        $break = 'break'
                    }
                    Default {
                        ""
                        Write-Host "Invalid entry. Please try again.." -ForegroundColor Red
                    }
                }
            }
        }
    } elseif($superSilentInstall -and $superSilentInstall -eq $true) {
        $currentSoftware = Get-Software
        if($install7zip -eq $true){
            if('7-Zip' -in $currentSoftware.DisplayName){
                Write-Host "7-Zip already installed. Continuing.." -ForegroundColor Green
            } else {
                choco install 7zip --force -y
            }
        }
        if($installNotepadPlus -eq $true){
            if('Notepad++' -in $currentSoftware.DisplayName){
                Write-Host "Notepad++ already installed. Continuing.." -ForegroundColor Green
            } else {
                choco install notepadplusplus --force -y  
            }
        }
        if($installFirefox -eq $true){
            if('Firefox' -in $currentSoftware.DisplayName){
                Write-Host "Firefox already installed. Continuing.." -ForegroundColor Green
            } else {
                choco install firefox --force -y
            }
        }
        if($installEPM -eq $true){
            if('Oracle EPM System' -in $currentSoftware.DisplayName){
                Write-Host "EPM is already installed. I don't want to mess anything up for you. Exiting" -ForegroundColor Red
                Exit
            } else {
                Write-Host "Starting $($epmStatus.name) installation procedure.." -ForegroundColor Cyan
                Invoke-Expression -Command "$($installerPath)/Powershell/install.ps1" -Verbose
            }
        }
    }

#endregion

#region cleanup variables
    
    if($break){
        Clear-Variable break
    }
    Clear-Variable 7zipStatus,firefoxStatus,notepadStatus,epmStatus

#endregion

#region stop transcript

    Stop-Transcript

#endregion
