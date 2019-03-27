Function Get-Software  {

  [OutputType('System.Software.Inventory')]

  [Cmdletbinding()] 

  Param( 

  [Parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)] 

  [String[]]$Computername=$env:COMPUTERNAME

  )         

  Begin {

  }

  Process  {     

  ForEach  ($Computer in  $Computername){ 

  If  (Test-Connection -ComputerName  $Computer -Count  1 -Quiet) {

  $Paths  = @("SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall","SOFTWARE\\Wow6432node\\Microsoft\\Windows\\CurrentVersion\\Uninstall")         

  ForEach($Path in $Paths) { 

  Write-Verbose  "Checking Path: $Path"

  #  Create an instance of the Registry Object and open the HKLM base key 

  Try  { 

  $reg=[microsoft.win32.registrykey]::OpenRemoteBaseKey('LocalMachine',$Computer,'Registry64') 

  } Catch  { 

  Write-Error $_ 

  Continue 

  } 

  #  Drill down into the Uninstall key using the OpenSubKey Method 

  Try  {

  $regkey=$reg.OpenSubKey($Path)  

  # Retrieve an array of string that contain all the subkey names 

  $subkeys=$regkey.GetSubKeyNames()      

  # Open each Subkey and use GetValue Method to return the required  values for each 

  ForEach ($key in $subkeys){   

  Write-Verbose "Key: $Key"

  $thisKey=$Path+"\\"+$key 

  Try {  

  $thisSubKey=$reg.OpenSubKey($thisKey)   

  # Prevent Objects with empty DisplayName 

  $DisplayName =  $thisSubKey.getValue("DisplayName")

  If ($DisplayName  -AND $DisplayName  -notmatch '^Update  for|rollup|^Security Update|^Service Pack|^HotFix') {

  $Date = $thisSubKey.GetValue('InstallDate')

  If ($Date) {

  Try {

  $Date = [datetime]::ParseExact($Date, 'yyyyMMdd', $Null)

  } Catch{

  Write-Warning "$($Computer): $_ <$($Date)>"

  $Date = $Null

  }

  } 

  # Create New Object with empty Properties 

  $Publisher =  Try {

  $thisSubKey.GetValue('Publisher').Trim()

  } 

  Catch {

  $thisSubKey.GetValue('Publisher')

  }

  $Version = Try {

  #Some weirdness with trailing [char]0 on some strings

  $thisSubKey.GetValue('DisplayVersion').TrimEnd(([char[]](32,0)))

  } 

  Catch {

  $thisSubKey.GetValue('DisplayVersion')

  }

  $UninstallString =  Try {

  $thisSubKey.GetValue('UninstallString').Trim()

  } 

  Catch {

  $thisSubKey.GetValue('UninstallString')

  }

  $InstallLocation =  Try {

  $thisSubKey.GetValue('InstallLocation').Trim()

  } 

  Catch {

  $thisSubKey.GetValue('InstallLocation')

  }

  $InstallSource =  Try {

  $thisSubKey.GetValue('InstallSource').Trim()

  } 

  Catch {

  $thisSubKey.GetValue('InstallSource')

  }

  $HelpLink = Try {

  $thisSubKey.GetValue('HelpLink').Trim()

  } 

  Catch {

  $thisSubKey.GetValue('HelpLink')

  }

  $Object = [pscustomobject]@{

  Computername = $Computer

  DisplayName = $DisplayName

  Version  = $Version

  InstallDate = $Date

  Publisher = $Publisher

  UninstallString = $UninstallString

  InstallLocation = $InstallLocation

  InstallSource  = $InstallSource

  HelpLink = $thisSubKey.GetValue('HelpLink')

  EstimatedSizeMB = [decimal]([math]::Round(($thisSubKey.GetValue('EstimatedSize')*1024)/1MB,2))

  }

  $Object.pstypenames.insert(0,'System.Software.Inventory')

  Write-Output $Object

  }

  } Catch {

  Write-Warning "$Key : $_"

  }   

  }

  } Catch  {}   

  $reg.Close() 

  }                  

  } Else  {

  Write-Error  "$($Computer): unable to reach remote system!"

  }

  } 

  } 

}  


function Ask-Install ($product){
    Write-Host "================ $($product) ================"
    Write-Host "Do you want to install $($product)?"
    Write-Host ""
    Write-Host "1. Yes"
    Write-Host "2. No"
    Write-Host "3. Quit"
    Write-Host "============"
    

    while($break -ne 'break'){
        switch($answer = Read-Host "Default (2)"){
            "" {
                Write-Host "Default: Skipping $($product)." -ForegroundColor Yellow
                if((Get-Variable "install$($product)" -ErrorAction SilentlyContinue)){
                    Set-Variable -Name "install$($product)" -Value $false
                } else {
                    New-Variable -Name "install$($product)"
                    Set-Variable -Name "install$($product)" -Value $false
                }
                $answer = 2
                (Get-Variable -Name "install$($product)").Value
                $answer
                $break = 'break'
            }
            1 {
                Write-Host "Adding $($product) to install list." -ForegroundColor Green
                if((Get-Variable "install$($product)" -ErrorAction SilentlyContinue)){
                    Set-Variable -Name "install$($product)" -Value $true
                } else {
                    New-Variable -Name "install$($product)"
                    Set-Variable -Name "install$($product)" -Value $true
                }
                $answer = 1
                (Get-Variable -Name "install$($product)").Value
                $answer
                $break = 'break'
            }
            2 {
                Write-Host "Skipping $($product). User opted out." -ForegroundColor Yellow
                if((Get-Variable "install$($product)" -ErrorAction SilentlyContinue)){
                    Set-Variable -Name "install$($product)" -Value $false
                } else {
                    New-Variable -Name "install$($product)"
                    Set-Variable -Name "install$($product)" -Value $false
                }
                $answer = 2
                Return (Get-Variable -Name "install$($product)").Value
                Return $answer
                $break = 'break'
            }
            3 {
                $answer = 3
                Write-Host "Exiting.." -ForegroundColor Magenta
                Return $answer
                $break = 'break'
            }
            default {
                Write-Host "Inavlid Entry. Please try again." -ForegroundColor Red
            }
        }
    }
    if($answer -eq 1 -and $product -in ('HFM','FDM','Essbase','Planning')){
        Clear-Variable Break
        Write-Host "================ $($product) ================"
        Write-Host "Do you want $($product) to be distributed?"
        Write-Host ""
        Write-Host "1. Yes"
        Write-Host "2. No"
        Write-Host "3. Quit"
        Write-Host "============"
        while($break -ne 'break'){
            switch($answer = Read-Host "Default (2)"){
                "" {
                    Write-Host "Default: $($product) is not distributed." -ForegroundColor Yellow
                    if((Get-Variable "distributed$($product)" -ErrorAction SilentlyContinue)){
                        Set-Variable -Name "distributed$($product)" -Value $false
                    } else {
                        New-Variable -Name "distributed$($product)"
                        Set-Variable -Name "distributed$($product)" -Value $false
                    }
                    $answer = 2
                    (Get-Variable -Name "install$($product)").Value
                    $answer
                    $break = 'break'
                }
                1 {
                    Write-Host "$($product) is distributed." -ForegroundColor Green
                    if((Get-Variable "distributed$($product)" -ErrorAction SilentlyContinue)){
                        Set-Variable -Name "distributed$($product)" -Value $true
                    } else {
                        New-Variable -Name "distributed$($product)"
                        Set-Variable -Name "distributed$($product)" -Value $true
                    }
                    $answer = 1
                    (Get-Variable -Name "distributed$($product)").Value
                    $answer
                    $break = 'break'
                }
                2 {
                    Write-Host "$($product) is not distributed." -ForegroundColor Yellow
                    if((Get-Variable "distributed$($product)" -ErrorAction SilentlyContinue)){
                        Set-Variable -Name "distributed$($product)" -Value $false
                    } else {
                        New-Variable -Name "distributed$($product)"
                        Set-Variable -Name "distributed$($product)" -Value $false
                    }
                    $answer = 2
                    Return (Get-Variable -Name "distributed$($product)").Value
                    Return $answer
                    $break = 'break'
                }
                3 {
                    $answer = 3
                    Write-Host "Exiting.." -ForegroundColor Magenta
                    Return $answer
                    $break = 'break'
                }
                default {
                    Write-Host "Inavlid Entry. Please try again." -ForegroundColor Red
                }
            }
        }
    }
}


