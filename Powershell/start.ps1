[CmdletBinding(DefaultParametersetName='none')] 
Param (
  [Parameter(ParameterSetName='superSilentInstall',Mandatory=$False)] [switch]$superSilentInstall,
  [Parameter(ParameterSetName='superSilentConfig',Mandatory=$False)] [switch]$superSilentConfig,
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$False)] [switch]$superSilentAll,
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$True)]
  [Parameter(ParameterSetName='superSilentInstall',Mandatory=$True)] [bool]$install7zip,
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$True)]
  [Parameter(ParameterSetName='superSilentInstall',Mandatory=$True)] [bool]$installnotepadPlus,
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$True)]
  [Parameter(ParameterSetName='superSilentInstall',Mandatory=$True)] [bool]$installfirefox,
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$True)]
  [Parameter(ParameterSetName='superSilentInstall',Mandatory=$True)] [bool]$installepm,
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$True)]
  [Parameter(ParameterSetName='superSilentInstall',Mandatory=$True)] [string]$epmPath,
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$True)]
  [Parameter(ParameterSetName='superSilentInstall',Mandatory=$True)] [bool]$installfoundation,
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$True)]
  [Parameter(ParameterSetName='superSilentInstall',Mandatory=$True)] [bool]$installessbase,
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$True)]
  [Parameter(ParameterSetName='superSilentInstall',Mandatory=$True)] [bool]$installraf,
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$True)]
  [Parameter(ParameterSetName='superSilentInstall',Mandatory=$True)] [bool]$installplanning,
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$True)]
  [Parameter(ParameterSetName='superSilentInstall',Mandatory=$True)] [bool]$installdisclosure,
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$True)]
  [Parameter(ParameterSetName='superSilentInstall',Mandatory=$True)] [bool]$installhfm,
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$True)]
  [Parameter(ParameterSetName='superSilentInstall',Mandatory=$True)] [bool]$installfdm,
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$True)]
  [Parameter(ParameterSetName='superSilentInstall',Mandatory=$True)] [bool]$installprofit,
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$True)]
  [Parameter(ParameterSetName='superSilentInstall',Mandatory=$True)] [bool]$installfcm,
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$True)]
  [Parameter(ParameterSetName='superSilentInstall',Mandatory=$True)] [bool]$installtax,
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$True)]
  [Parameter(ParameterSetName='superSilentInstall',Mandatory=$True)] [bool]$installstrategic,
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
  [Parameter(ParameterSetName='superSilentAll',Mandatory=$False)]
  [Parameter(ParameterSetName='superSilentConfig',Mandatory=$False)] [string]$foundationDB,
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

#region parse silent params and validate

    if($superSilentAll.IsPresent -eq $true){
        $superSilentInstall = $true
        $superSilentConfig = $true
    }

    if($wkspcAdminPassword.Length -lt 8 -or $wkspcAdminPassword -notmatch ".*\d+.*" -or $wkspcAdminPassword -notmatch ".*\w+.*"){
       Write-Host "Workspace admin password does not meet the minimum requirements. Password must be alphanumeric, and at least 8 characters." -ForegroundColor Red
       Read-Host "Click enter to exit"
       exit
    }

#endregion

#region test if ran as admin

    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    if($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator) -eq $false){
        Write-Host "Must run utility as administrator. Exiting.." -ForegroundColor Red
        Read-Host "Click enter to exit."
        exit
    } else {
        Write-Host "Utillity running as administrator. Continuing.." -ForegroundColor Green
    }

#endregion

#region set mainVariables and mainFunctions

    . 'C:\InstallAutomation\Variables\mainVariables.ps1'
    . 'C:\InstallAutomation\Functions\mainfunctions.ps1'

#endregion

#region install assembly and choco

    Add-Type -AssemblyName PresentationFramework
    Invoke-Command -ScriptBlock $choco *> $null
    choco upgrade chocolatey $choco *> $null

#endregion

#region installer important info notice
    
    if($superSilentInstall -or $superSilentInstall){
        Write-Host 'Thank you for using the EPM silent installer/configuration utility. Please note the following requirments and limitations before continuing:
    
        Requirments:
        1. IIS, Netframework 3.5 must be installed as that feature has not beed added to the utility yet.
        2. You must be a local Administrator.
        3. UAC must be disabled.
        4. 7-zip must be installed. The utility will install for you but if you opt out of that feature the script will error out.
    
        Limitations:
        1. This utility should not be used on an environment that has already been configured.
        2. Oracle DB is currently not supported.
        3. 100% Customization is not currently supported. Only common settings can be configured (ex. database name, host, port, smtp, more..)
        4. SOA Products like Tax Management and Financial Close Manager are not supported.' -ForegroundColor Magenta
    } else {
        [System.Windows.MessageBox]::Show('Thank you for using the EPM silent installer/configuration utility. Please note the following requirments and limitations before continuing:
    
        Requirments:
        1. IIS, Netframework 3.5 must be installed as that feature has not beed added to the utility yet.
        2. You must be a local Administrator.
        3. UAC must be disabled.
        4. 7-zip must be installed. The utility will install for you but if you opt out of that feature the script will error out.
    
        Limitations:
        1. This utility should not be used on an environment that has already been configured.
        2. Oracle DB is currently not supported.
        3. 100% Customization is not currently supported. Only common settings can be configured (ex. database name, host, port, smtp, more..)
        4. SOA Products like Tax Management and Financial Close Manager are not supported.
    
        Click ok to continue..')
    }

#endregion

#region look for current programs and hyperion

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
    if(!$superSilentInstall){
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
                        Invoke-Expression -Command "$($installerPath)/Powershell/configure.ps1"
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
                        Invoke-Expression -Command "$($installerPath)/Powershell/install.ps1"
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
        if($install7zip -eq $true){
            choco uninstall 7zip -y -x 
            choco install 7zip --force -y
        }
        if($installNotepadPlus -eq $true){
            choco uninstall notepadplusplus -y -x
            choco install notepadplusplus --force -y
        }
        if($installFirefox -eq $true){
            choco uninstall firefox -y -x
            choco install firefox --force -y
        }
        if($installEPM -eq $true){
            Write-Host "Starting $($epmStatus.name) installation procedure.." -ForegroundColor Cyan
            Invoke-Expression -Command "$($installerPath)/Powershell/install.ps1"
        }
    }
#endregion

#region cleanup variables
    
    if($break){
        Clear-Variable break
    }
    Clear-Variable 7zipStatus,firefoxStatus,notepadStatus,epmStatus

#endregion
