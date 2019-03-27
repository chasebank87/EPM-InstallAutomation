#region set mainVariables and mainFunctions

    . "$($installerPath)\Variables\mainVariables"
    . "$($installerPath)\Functions\mainfunctions.ps1"

#endregion

#region look for zip files and unzip
    if(!$superSilentInstall -or $superSilentInstall -eq $false){
        if($break){Clear-Variable break}
        while($break -ne 'break'){
            Write-Host "Looking for installation files"
            $expectedInstallationFiles = @('V37380-01_1of2.zip','V37380-01_2of2.zip','V37446-01.zip','V74011-01.zip','V74016-01.zip','V74019-01.zip','V74025-01.zip','V74031-01.zip','V74037-01.zip','V74044-01.zip','V74050-01.zip','V74056-01.zip','V74108-01.zip','V76567-01.zip','V76569-01.zip')
            $installationFileAvailability = @()
            $installationFailures = 0
            $installationFiles = Get-ChildItem -Path "$($installerPath)\EPM\11.1.2.4"
            foreach($i in $expectedInstallationFiles){
                if($i -in $installationFiles.name) {
                    $newObject = New-Object -TypeName PSObject
                    $newObject | Add-Member -type NoteProperty -name Name -Value $i
                    $newObject | Add-Member -type NoteProperty -name Available -Value $true
                    $installationFileAvailability += $newObject
                }
                else {
                    $newObject = New-Object -TypeName PSObject
                    $newObject | Add-Member -type NoteProperty -name Name -Value $i
                    $newObject | Add-Member -type NoteProperty -name Available -Value $false 
                    $installationFileAvailability += $newObject           
                }
            }
	    
            foreach($i in $installationFileAvailability){
                Write-Host "Looking for $($i.name)" -ForegroundColor Cyan
                Sleep -Seconds 1.5
                if($i.available -eq $true){
                    Write-Host "OK" -ForegroundColor Green
                }
                else {
                    $installationFailures++
                    Write-Host "NOT FOUND" -ForegroundColor Red
                    While($break -eq $null){
                        Switch($downloadFile = Read-Host "Would you like me to download $($i.name) for you? Y or N"){
                            "Y" {
                                ""
                                Write-Host "Downloading $($i.name).." -ForegroundColor Cyan
                                $fileToDownload = $downloads | Where-Object -FilterScript { $_ -like "*$($i.name)*" }
                                $ProgressPreference = 'SilentlyContinue'
                                #wget $fileToDownload -OutFile "$($installerPath)\EPM\$($i.name)" -Verbose
                                (New-Object System.Net.WebClient).DownloadFile($fileToDownload, "$($installerPath)\EPM\11.1.2.4\$($i.name)")
                                $ProgressPreference = 'Continue'
                                $downloadedFileHash = Get-FileHash -Path "$($installerPath)\EPM\11.1.2.4\$($i.name)"
                                if($downloadedFileHash.hash -notin $downloadHashs){
                                    Write-Host "Downloaded file hash not found. Terminating." -ForegroundColor Red
                                    Read-Host "Cleck enter to exit.."
                                    Exit
                                }
                                else{
                                    Write-Host "Downloaded file hash matches hash array. Continuing.." -ForegroundColor Green
                                    $installationFailures--
                                }
                                $break = 'break'
                            }
                            "N" {
                                Write-Host "Skipping $($i.name).." -ForegroundColor Yellow
                                $break = 'break'
                            }
                            Default {
                                Write-Host "Invalid entry. Please try again.." -ForegroundColor Red
                            }
                        }
                    }
                }
                if($break){Clear-Variable break}
            }
            if($break){Clear-Variable break}
            Write-Host ""
            Write-Host ""
            if($installatioNFailures -gt 0){
                Write-Host "Please download the missing files and place them in the EPM folder." -ForegroundColor Yellow
                Read-Host "Click Enter when the missing files have been placed in the EPM folder."
            }
            elseif($installationFailures -eq 0) {
                Write-Host "All install files are available. Continuing to Install." -ForegroundColor Green
                $break = 'break'
            }
        }
	if($skipUnzip -ne $true){
        $testUnzipDest = Test-Path "$($installerPath)\EPM\Unzipped\"
        if($testUnzipDest -eq $true){
            Remove-Item -Path "$($installerPath)\EPM\Unzipped\" -Recurse -Force
        }
 
        try{
                Write-Host "Unzipping Install Files.  This may take a few minutes." -ForegroundColor Cyan
                $7zipProcess = Start-Process -FilePath """$($7zip)""" -ArgumentList "x ""$($installerPath)\EPM\11.1.2.4\*.zip"" -y -o""$($installerPath)\EPM\Unzipped\""" -WindowStyle Hidden -passthru
            }
        Catch {
                $_ | Out-File "$($installerPath)\Logs\Unzip.Error.log" -Append
            }

        if($7zipProcess) {
            While((get-process -id $7zipProcess.id -ErrorAction SilentlyContinue) -ne $null){
                $unzippedFiles = Get-ChildItem -Path "$($installerPath)\EPM\Unzipped\" -Recurse -ErrorAction SilentlyContinue
                $unzippedFilesSize = "{0:N2}" -f ((Get-ChildItem "$($installerPath)\EPM\Unzipped\" -Recurse  -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum -ErrorAction Stop).Sum / 1MB)
                $unzippedFilesSizeCompPercent = 100 /  19733.84 * [int]$unzippedFilesSize
                $unzippedFilesSizeCompPercent = [math]::floor($unzippedFilesSizeCompPercent)
                $unzipCompPercent = ((100 / 29880 * $unzippedFiles.count) + $unzippedFilesSizeCompPercent) / 2
                $unzipCompPercent = [math]::floor($unzipCompPercent) 
                Write-Host "Unzipping.. $($unzipCompPercent)% Completed." -ForegroundColor Cyan
                Sleep -Seconds 15
            }
         }
	 }
     } elseif($superSilentInstall -and $superSilentInstall -eq $true) {
        Write-Host "Looking for installation files"
        $expectedInstallationFiles = @('V37380-01_1of2.zip','V37380-01_2of2.zip','V37446-01.zip','V74011-01.zip','V74016-01.zip','V74019-01.zip','V74025-01.zip','V74031-01.zip','V74037-01.zip','V74044-01.zip','V74050-01.zip','V74056-01.zip','V74108-01.zip','V76567-01.zip','V76569-01.zip')
        $installationFileAvailability = @()
        $installationFailures = 0
        $installationFiles = Get-ChildItem -Path "$($installerPath)\EPM\11.1.2.4"
        foreach($i in $expectedInstallationFiles){
            if($i -in $installationFiles.name) {
                $newObject = New-Object -TypeName PSObject
                $newObject | Add-Member -type NoteProperty -name Name -Value $i
                $newObject | Add-Member -type NoteProperty -name Available -Value $true
                $installationFileAvailability += $newObject
            }
            else {
                $newObject = New-Object -TypeName PSObject
                $newObject | Add-Member -type NoteProperty -name Name -Value $i
                $newObject | Add-Member -type NoteProperty -name Available -Value $false 
                $installationFileAvailability += $newObject           
            }
        }
        foreach($i in $installationFileAvailability){
            Write-Host "Looking for $($i.name)" -ForegroundColor Cyan
            Sleep -Seconds 1.5
            if($i.available -eq $true){
                Write-Host "OK" -ForegroundColor Green
            }
            else {
                $installationFailures++
                Write-Host "NOT FOUND" -ForegroundColor Red
                Write-Host "Downloading $($i.name).." -ForegroundColor Cyan
                $fileToDownload = $downloads | Where-Object -FilterScript { $_ -like "*$($i.name)*" }
                $ProgressPreference = 'SilentlyContinue'
                #wget $fileToDownload -OutFile "$($installerPath)\EPM\$($i.name)" -Verbose
                (New-Object System.Net.WebClient).DownloadFile($fileToDownload, "$($installerPath)\EPM\11.1.2.4\$($i.name)")
                $ProgressPreference = 'Continue'
                $downloadedFileHash = Get-FileHash -Path "$($installerPath)\EPM\11.1.2.4\$($i.name)"
                if($downloadedFileHash.hash -notin $downloadHashs){
                    Write-Host "Downloaded file hash not found. Terminating." -ForegroundColor Red
                    Read-Host "Cleck enter to exit.."
                    Exit
                }
                else{
                    Write-Host "Downloaded file hash matches hash array. Continuing.." -ForegroundColor Green
                    $installationFailures--
                }
            }

            if($break){Clear-Variable break}
            Write-Host ""
            Write-Host ""
            if($installatioNFailures -gt 0){
                Write-Host "Please download the missing files and place them in the EPM folder." -ForegroundColor Yellow
                Read-Host "Click Enter when the missing files have been placed in the EPM folder."
            }
            elseif($installationFailures -eq 0) {
                #Write-Host "All install files are available. Continuing to Install." -ForegroundColor Green
                $break = 'break'
            }
        }
	if($skipUnzip -ne $true){
        $testUnzipDest = Test-Path "$($installerPath)\EPM\Unzipped\"
        if($testUnzipDest -eq $true){
            Remove-Item -Path "$($installerPath)\EPM\Unzipped\" -Recurse -Force
        }
 
        try{
                Write-Host "Unzipping Install Files.  This may take a few minutes." -ForegroundColor Cyan
                $7zipProcess = Start-Process -FilePath """$($7zip)""" -ArgumentList "x ""$($installerPath)\EPM\11.1.2.4\*.zip"" -y -o""$($installerPath)\EPM\Unzipped\""" -WindowStyle Hidden -passthru
            }
        Catch {
                $_ | Out-File "$($installerPath)\Logs\Unzip.Error.log" -Append
            }

        if($7zipProcess) {
            While((get-process -id $7zipProcess.id -ErrorAction SilentlyContinue) -ne $null){
                $unzippedFiles = Get-ChildItem -Path "$($installerPath)\EPM\Unzipped\" -Recurse -ErrorAction SilentlyContinue
                $unzippedFilesSize = "{0:N2}" -f ((Get-ChildItem "$($installerPath)\EPM\Unzipped\" -Recurse  -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum -ErrorAction Stop).Sum / 1MB)
                $unzippedFilesSizeCompPercent = 100 /  19733.84 * [int]$unzippedFilesSize
                $unzippedFilesSizeCompPercent = [math]::floor($unzippedFilesSizeCompPercent)
                $unzipCompPercent = ((100 / 29880 * $unzippedFiles.count) + $unzippedFilesSizeCompPercent) / 2
                $unzipCompPercent = [math]::floor($unzipCompPercent) 
                Write-Host "Unzipping.. $($unzipCompPercent)% Completed." -ForegroundColor Cyan
                Sleep -Seconds 15
            }
         }
	 }
	 #Check amount of files in unzipped folder
	 $unzippedFiles = Get-ChildItem -Path "$($installerPath)\EPM\Unzipped\" -Recurse -File -ErrorAction SilentlyContinue
	 if($unzippedFiles.count -lt 23500){
	 	Write-Host "Fatal Error: Unzipped directory is missing files. Expected 23500 files, but only $($unzippedFiles.count). Exiting.." -ForegroundColor Red
		Read-Host "Click enter to exit"
		Exit
	 } elseif($unzippedFiles.count -eq 23500){
		Write-Host "Unzipped files are present. Continuing.." -ForegroundColor Cyan
	 }
    }
#endregion

#region announce install

	Write-Host '
 __   __   __   ______   ______  ______   __       __       __   __   __   ______    
/\ \ /\ "-.\ \ /\  ___\ /\__  _\/\  __ \ /\ \     /\ \     /\ \ /\ "-.\ \ /\  ___\   
\ \ \\ \ \-.  \\ \___  \\/_/\ \/\ \  __ \\ \ \____\ \ \____\ \ \\ \ \-.  \\ \ \__ \  
 \ \_\\ \_\\"\_\\/\_____\  \ \_\ \ \_\ \_\\ \_____\\ \_____\\ \_\\ \_\\"\_\\ \_____\ 
  \/_/ \/_/ \/_/ \/_____/   \/_/  \/_/\/_/ \/_____/ \/_____/ \/_/ \/_/ \/_/ \/_____/ 
  
  ' -ForegroundColor Magenta                                                                                  

#endregion

#region start epm install

    if(!$superSilentInstall -or $superSilentInstall -eq $false){
        if($break){Clear-Variable break}
        while($break -ne 'break'){
            $epmInstallPath = Read-Host "Please type the path where you want to install EPM. Example: C:\Oracle\Middleware"
            if(($epmInstallPath.Length - 1) -eq '\'){
               $epmInstallPath =  $epmInstallPath.TrimEnd()
            }
            $testEPMInstallPath = Test-Path -Path $epmInstallPath.Substring(0,3)
            $testEPMInstallPathChildren = Get-ChildItem $epmInstallPath -ErrorAction SilentlyContinue
            if($testEPMInstallPath -eq $false) {
                Write-Host "Invalid Path. Try again." -ForegroundColor Red
            }
            else{
                Write-Host "Valid Path. Continuing." -ForegroundColor Green
                $break = 'break'
            }
            if($testEPMInstallPathChildren.count -gt 0 ) {
                Write-Host "Path contains files. Cannot Continue." -ForegroundColor Red
                Read-Host "Press enter to exit."
                Exit
            } 
            else {
                Write-Host "Path is ready to be used. Continuing." -ForegroundColor Green
                $break = 'break'
            }
        }

        if($break){Clear-Variable break}

        #region build epm install array wiht user interaction

            

    $installArray = @()
    Write-Host "============== Remote Server =============="
    Write-Host "Is this a remote server?"
    Write-Host ""
    Write-Host "1. Yes"
    Write-Host "2. No"
    Write-Host "3. Quit"
    Write-Host "============"
    while($break -ne 'break'){
        switch($answer = Read-Host "Default (2)"){
            "" {
                Write-Host "Default: This is not a remote server." -ForegroundColor Yellow
                $remoteDeployment = $false
                $break = 'break'
            }
            1 {
                Write-Host "This is a remote server" -ForegroundColor Green
                $remoteDeployment = $true
                $break = 'break'
            }
            2 {
                Write-Host "This is not a remote server." -ForegroundColor Yellow
                $remoteDeployment = $false
                $break = 'break'
            }
            3 {
                Write-Host "Exiting.." -ForegroundColor Magenta
                Start-Sleep -Seconds 2
                Exit
            }
            default {
                Write-Host "Invalid entry. Please try again.." -ForegroundColor Red
            }
        }
    }
    if($break){Clear-Variable break}
    foreach($i in $standaloneInstallFiles){
        Clear-Variable installObject
        if($i -notin ('footer','header')){
            $answer = Ask-Install -product $i
        }
        if($answer[1] -eq 1){
            Set-Variable -Name "install$($i)" -Value $answer[0]
            Set-Variable -Name "distributed$($i)" -Value $answer[2]
            $installObject = New-Object -TypeName PSObject
            $installObject | Add-Member -Name Name -Value $i -MemberType NoteProperty
            if((Get-Variable -Name "install$($i)" -ErrorAction SilentlyContinue).Value -eq $true){
                $installObject | Add-Member -Name Install -Value 'Yes' -MemberType NoteProperty
                if(Get-Variable -Name "distributed$($i)" -ErrorAction SilentlyContinue){
                    if((Get-Variable -Name "distributed$($i)").Value -eq $true){
                        $installObject | Add-Member -Name Type -Value Distributed -MemberType NoteProperty
                            $installObject | Add-Member -Name IsRemote -Value No -MemberType NoteProperty
                        } elseif($i -ne 'foundation') {
                            $installObject | Add-Member -Name Type -Value Standalone -MemberType NoteProperty  
                        }
                    } elseif((Get-Variable -Name 'distributed*').Value -contains $true -and $i -in ('hfm','essbase','planning','fdm')){
                        $installObject | Add-Member -Name Type -Value Central -MemberType NoteProperty
                    } elseif((Get-Variable -Name 'distributed*').Value -notcontains $true){
                        $installObject | Add-Member -Name Type -Value Standalone -MemberType NoteProperty
                    }
                if((Get-Variable -Name "distributed*").Value -contains 'True' -and $i -notin ('hfm','essbase','planning','fdm')){
                    $installObject | Add-Member -Name Type -Value 'Central' -MemberType NoteProperty  
                }

            } else {
                if($i -eq 'header' -or $i -eq 'footer'){
                    $installObject | Add-Member -Name Install -Value 'Yes' -MemberType NoteProperty
                    $installObject | Add-Member -Name Type -Value $i -MemberType NoteProperty
                } else {
                    $installObject | Add-Member -Name Install -Value 'No' -MemberType NoteProperty
                    $installObject | Add-Member -Name Type -Value 'Skipped' -MemberType NoteProperty
                }
            }
            if($remoteDeployment -eq $true){
                $installObject | Add-Member -Name Remote -Value Yes -MemberType NoteProperty
            } else {
                $installObject | Add-Member -Name Remote -Value No -MemberType NoteProperty
            }

            $installArray += $installObject
        } elseif($answer[0] -eq 3){
            Exit
        }
    }

#endregion
  
        if($break){Clear-Variable break}
    } elseif($superSilentInstall -and $superSilentInstall -eq $true){
        #region build epm install array

    $installArray = @()
    foreach($i in $installFiles){
        if($installObject){Clear-Variable installObject}
        $installObject = New-Object -TypeName PSObject
        $installObject | Add-Member -Name Name -Value $i -MemberType NoteProperty
        if((Get-Variable -Name "install$($i)" -ErrorAction SilentlyContinue).Value -eq $true){
            $installObject | Add-Member -Name Install -Value 'Yes' -MemberType NoteProperty
            if(Get-Variable -Name "distributed$($i)" -ErrorAction SilentlyContinue){
                if((Get-Variable -Name "distributed$($i)").Value -eq $true){
                    $installObject | Add-Member -Name Type -Value Distributed -MemberType NoteProperty
                     $installObject | Add-Member -Name IsRemote -Value No -MemberType NoteProperty
                    } else {
                        $installObject | Add-Member -Name Type -Value Standalone -MemberType NoteProperty  
                    }
                } elseif((Get-Variable -Name 'distributed*').Value -contains $true -and $i -in ('hfm','essbase','planning','fdm')){
                    $installObject | Add-Member -Name Type -Value Central -MemberType NoteProperty
                } elseif((Get-Variable -Name 'distributed*').Value -notcontains $true){
                    $installObject | Add-Member -Name Type -Value Standalone -MemberType NoteProperty
                }
            if((Get-Variable -Name "distributed*").Value -contains 'True' -and $i -notin ('hfm','essbase','planning','fdm')){
                $installObject | Add-Member -Name Type -Value 'Central' -MemberType NoteProperty  
            }

        } else {
            if($i -eq 'header' -or $i -eq 'footer'){
                $installObject | Add-Member -Name Install -Value 'Yes' -MemberType NoteProperty
                $installObject | Add-Member -Name Type -Value $i -MemberType NoteProperty
            } else {
                $installObject | Add-Member -Name Install -Value 'No' -MemberType NoteProperty
                $installObject | Add-Member -Name Type -Value 'Skipped' -MemberType NoteProperty
            }
        }
        if($remoteDeployment -eq $true){
            $installObject | Add-Member -Name Remote -Value Yes -MemberType NoteProperty
        } else {
            $installObject | Add-Member -Name Remote -Value No -MemberType NoteProperty
        }

        $installArray += $installObject
    }

#endregion

#region loop through epm install array and create install property file
    
    #region loop through epm install array and create install property file
    
    $installArrayWithPath = @()
    foreach($i in $installArray){
        Clear-Variable installObject
        $installObject = New-Object -TypeName PSObject
        $installObject = $i
        if($i.Install -eq 'Yes'){
            if($i.Type -eq 'Distributed' -and $i.Name -ne 'Foundation'){
                if($i.Remote -eq 'Yes'){
                    Write-Host "Adding $($i.name) to install list on remote server." -ForegroundColor Green  
                    $installObject | Add-Member -Name Path -Value "$($installerPath)\Variables\Property Files\11.1.2.4\Install\Distributed\Remote\$($i.Name)" -MemberType NoteProperty -Force
                } elseif($i.Remote -eq 'No') {
                    Write-Host "Adding $($i.name) to install list on central server." -ForegroundColor Green  
                    $installObject | Add-Member -Name Path -Value "$($installerPath)\Variables\Property Files\11.1.2.4\Install\Distributed\Central\$($i.Name)" -MemberType NoteProperty -Force
                }
            } elseif($i.Type -eq 'Central' -and $i.Name -ne 'Foundation') {
                Write-Host "Adding $($i.name) to install list on central server." -ForegroundColor Green
                $installObject | Add-Member -Name Path -Value "$($installerPath)\Variables\Property Files\11.1.2.4\Install\Distributed\Central\$($i.Name)" -MemberType NoteProperty -Force
            } elseif($i.Type -eq 'Central' -and $i.Name -eq 'Foundation') {
                if($i.Remote -eq 'Yes'){
                    Write-Host "Adding $($i.name) to install list on remote server." -ForegroundColor Green
                    $installObject | Add-Member -Name Path -Value "$($installerPath)\Variables\Property Files\11.1.2.4\Install\Distributed\Remote\$($i.Name)" -MemberType NoteProperty -Force
                } elseif($i.Remote -eq 'no') {
                    Write-Host "Adding $($i.name) to install list on central server." -ForegroundColor Green
                    $installObject | Add-Member -Name Path -Value "$($installerPath)\Variables\Property Files\11.1.2.4\Install\Distributed\Central\$($i.Name)" -MemberType NoteProperty -Force
                }
            } elseif($i.Type -eq 'Standalone'){
                Write-Host "Adding $($i.name) to install list on standalone server." -ForegroundColor Green
                $installObject | Add-Member -Name Path -Value "$($installerPath)\Variables\Property Files\11.1.2.4\Install\Standalone\$($i.Name)" -MemberType NoteProperty -Force
            } elseif($i.Type -eq 'Header' -or $i.Type -eq 'Footer'){
                Write-Host "Adding $($i.name) to install list on server." -ForegroundColor Green
                $installObject | Add-Member -Name Path -Value "$($installerPath)\Variables\Property Files\11.1.2.4\Install\Standalone\$($i.Name)" -MemberType NoteProperty -Force
            }
        } else {
            Write-Host "Skipping install for $($i.name). It was not selected.." -ForegroundColor Yellow
            $installObject | Add-Member -Name Path -Value "Null" -MemberType NoteProperty -Force
        }
        $installArrayWithPath += $installObject
    }

#endregion

#region loop through installArrayWithPath and if not null add to installProperty file

    foreach($i in $installArrayWithPath){
        if($i.Path -ne 'Null'){
            New-Variable -Name "input$($i.name)" -Value (Get-Content -Path $i.Path -Raw) -Force
            Set-Variable -Name "input$($i.name)" -Value ($ExecutionContext.InvokeCommand.ExpandString((Get-Variable -Name "input$($i.name)").Value)) -Force
        }
    }

    $data = "$($inputHeader)
		$($inputFoundation)
		$($inputessbase)
		$($inputraf)
		$($inputFCM)
		$($inputTax)
		$($inputHSF)
		$($inputplanning)
		$($inputdisclosure)
		$($inputhfm)
		$($inputfdm)
		$($inputprofit)
		$($inputFooter)"

    $data | Out-File "$($installerPath)\Temp\silentInstall" -Encoding utf8
    $silentInstallFile = Get-Content "$($installerPath)\Temp\silentInstall"
    $Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
    [System.IO.File]::WriteAllLines("$($installerPath)\Temp\silentInstall", $silentInstallFile, $Utf8NoBomEncoding)

#endregion

    try {
    Write-Host "Installing EPM. This may take 10 - 20 Minutes." -ForegroundColor Cyan
    Start-Process -FilePath "$($installerPath)\EPM\Unzipped\installTool.cmd" -ArgumentList "-silent $($installerPath)\Temp\silentInstall" -Verb RunAs -Wait
    }
    catch {
        $_ | Out-File "$($installerPath)\Logs\installTool.Error.log" -Append
        Get-Content "$($installerPath)\Logs\installTool.Error.log" | Write-Host -ForegroundColor Red
        Read-Host "Click enter to exit"
        Exit
    }

#endregion

#region configuration
      
      if(!$superSilentConfig -or $superSilentConfig -eq $false){
          if($break){Clear-Variable break}
              Write-Host "EPM is now installed." -ForegroundColor Green
                while($break -eq $null){
                    switch(Read-Host "Would you like to configure EPM now? Y or N"){
                        "Y" {
                            ""
                            Write-Host "Starting $($epmStatus.name) configuration procedure" -ForegroundColor Cyan
                            Invoke-Expression -Command "$($installerPath)/Powershell/$($configureScript)"
                            $break = 'break'
                            }
                        "N" {
                            ""
                            Write-Host "Skipping $($epmStatus.name) configuration.." -ForegroundColor Yellow
                            Exit
                            }
                        Default {
                            ""
                            Write-Host "Invalid entry. Please try again.." -ForegroundColor Red
                            }
                        }
                    }
            if($break){Clear-Variable break}
        } elseif($superSilentConfig -and $superSilentConfig -eq $true){
            Write-Host "Starting $($epmStatus.name).. configuration procedure" -ForegroundColor Cyan
            Invoke-Expression -Command "$($installerPath)/Powershell/$($configureScript)"
        }
	
	#announce completion if config isn't present
	if($superSilentConfig -ne $true){
	Write-Host '


 ______   ______   __    __   ______  __       ______  ______  ______    
/\  ___\ /\  __ \ /\ "-./  \ /\  == \/\ \     /\  ___\/\__  _\/\  ___\   
\ \ \____\ \ \/\ \\ \ \-./\ \\ \  _-/\ \ \____\ \  __\\/_/\ \/\ \  __\   
 \ \_____\\ \_____\\ \_\ \ \_\\ \_\   \ \_____\\ \_____\ \ \_\ \ \_____\ 
  \/_____/ \/_____/ \/_/  \/_/ \/_/    \/_____/ \/_____/  \/_/  \/_____/ 
                                                                         
									 
 ' -ForegroundColor magenta

	}

#endregion
