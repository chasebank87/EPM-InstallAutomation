#region variables

    $reportsPath = 'C:\Automation\Reports\'
    $weblogicHostname = 'localhost'
    $weblogicPort = '7001'
    $weblogicUsername = 'epm_admin'
    $weblogicPassword = 'Password!'
    $distributionList = ('test@website.com','test2@website.com')
    $mwPath = 'C:\Oracle\Middleware'
    $domainPath = 'C:\Oracle\Middleware\user_projects\domains\EPMSystem'
    $pythonScript = 'C:\Automation\Scripts\weblogicStatus.py'
    $sender = 'testsend@website.com'
    $smtpServer = 'smtp.example.com'
    $subject = "EPM Start Services Status"
    
    #report style
    $HTMLParameters = @{ 
    PreContent = "<H1>PRODUCTION</H1><h2>Hyperion Service Status</h2>"  
    PostContent = "<p class='footer'>$(get-date)</p>"
    head = @"
 <Title>Hyperion Service Status</Title>
 <link href="https://fonts.googleapis.com/css?family=Montserrat:400,500,600,700,800" rel="stylesheet">
<style>

body { 
    background-color:#E5E4E2;
    font-family: 'Montserrat', sans-serif !important;
    font-size:10pt; 
}

td, th { 
    border:0px solid black; 
    border-collapse:collapse;
    text-align: left;
}

th {
    border-bottom: 2px solid black;
}

tr:ntr-child(odd) {background-color: lightgray}

table {
    width: 100vw;
}

h1 {
    font-weight: 600;
}
h2 {
 font-family: 'Montserrat', sans-serif !important;
 color:#8c8c8c;
 font-weight: 500;
}

.footer 
{ color:green; 
  margin-left:10px; 
  font-family: 'Montserrat', sans-serif !important;
  font-size:10pt;
  font-style:italic;
  padding-top: 50px;
}

</style>
"@
}

#endregion

#region functions

    function get-WeblogicServerStatus($server, $port = '7001', $user, $password, $HTMLParameters) {
    <#
        .SYNOPSIS
            Gets the weblogic services status from a linux server.
        .DESCRIPTION
            Gets the weblogic services status from a linux server. This uses an SSH session that must be opened 
            and provided to use this function. This function will also format the output to only include the service status.
        .PARAMETER Code
            Session - An SSH session created by the user: $exampleSession = New-SSHSession -ComputerName "Linus Server Hostname" -Credential "Credentials"
            Port - The port weblogic listens on the Linux Server
            Username - A weblogic admin username
            Password - The password for the weblogic admin
            epmUser - The user that was used to install weblogic on the linux server
        .EXAMPLE
           PS > $serverStatus = getWeblogicServerStatus -session $exampleSession -port 7001 -username admin -password "password" -epmUser oracle

           Description
           -----------
           Writes the services status to a variable to be used later
        .NOTES
           Author: Chase Elder
           Requires: Powershell 5
 
           Version History
           0.1 - Initial release
        #>
    $WLST = "$($mwPath)\wlserver_10.3\common\bin\wlst.cmd"
    $pythonScript = $pythonScript
    $pythonScriptBlock = "connect('$($user)','$($password)','t3://$($server):$($port)')

domainConfig()
serverList=cmo.getServers();
domainRuntime()
cd('/ServerLifeCycleRuntimes/')
print '&!%'
for server in serverList:
 name=server.getName()
 cd(name)
 serverState=cmo.getState()
 if serverState=='Shutdown':
  print name + ',' + serverState + '|'
  break
 print name + ',' + serverState  + '|'
 cd('..')
    "
    $Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
    [System.IO.File]::WriteAllLines($pythonScript, $pythonScriptBlock, $Utf8NoBomEncoding)        
    $getStatus = &$WLST $pythonScript
    $getStatusExtract = $getStatus | Out-String
    $ServerStatusFormated = $getStatusExtract -replace "`n|`r"
    $ServerStatusFormated = $ServerStatusFormated.Substring($ServerStatusFormated.IndexOf('&') + 1);
    $ServerStatusFormated = $ServerStatusFormated.Substring($ServerStatusFormated.IndexOf('!') + 1);
    $ServerStatusFormated = $ServerStatusFormated.Substring($ServerStatusFormated.IndexOf('%') + 1);
    $ServerStatusArray = $ServerStatusFormated.Split('|')
    $resultsArray = @()
    foreach($i in $ServerStatusArray){
        if($i.Length -gt 2){
            if($i -notlike '*AdminServer*'){
                $currentObjects = $i | Out-String
                $currentObjects = $currentObjects -replace "`n|`r"
                $currentObjects = $currentObjects.Split(',')
                $name = $currentObjects | Select -First 1
                $state = $currentObjects | Select -Last 1
                $serverObject = New-Object psobject
                $serverObject | Add-Member -Name Name -Value $name -MemberType NoteProperty
                $serverObject | Add-Member -Name State -Value $state -MemberType NoteProperty
                $resultsArray += $serverObject
            }
        }
    }
    return,$resultsArray
    }

    function Send-Email($sender, $recipient, $subject, $body, $smtpServer) {
        $MsgStart = New-Object Net.Mail.MailMessage
        $SMTPStart = New-Object Net.Mail.SmtpClient("$($smtpServer)")
        $MsgStart.From = "$($sender)"
        $MsgStart.To.Add("$($recipient)")
        $MsgStart.Subject = "$($subject)"
        $MsgStart.Body = "$($body)"
        $SMTPStart.Send($MsgStart)
    }

#endregion

#region start admin server
    
    if((Test-NetConnection -ComputerName $weblogicHostname -Port $weblogicPort -WarningAction SilentlyContinue).TcpTestSucceeded -eq $False){
        Write-Host "Starting Admin Server" -ForegroundColor Cyan
        Start-Process -FilePath "$($domainPath)\bin\StartWeblogic.cmd" -Verb RunAs
    } else {
        Write-Host "Admin Server already running. Continuing.." -ForegroundColor Green
    }
    
 
#endregion

#region loop for admin server to respond

    While((Test-NetConnection -ComputerName $weblogicHostname -Port $weblogicPort -WarningAction SilentlyContinue).TcpTestSucceeded -eq $False){
        Write-Host "Waiting for Admin Server to start" -ForegroundColor DarkYellow
        sleep -Seconds 20
    }
    Write-Host "Admin Server started successfully" -ForegroundColor Green
    
#endregion

#region find all hyperion services

    $hyperionServices = Get-Service -Name "HyS*"
    $hyperionServices += Get-Service -Name "OracleProcess*"

#endregion

#region loop through all hyperion services and start
    
    if($hyperionServices.Count -gt 0){
        foreach($i in $hyperionServices){
            if($i.Status -ne 'Running'){
                Write-Host "Starting $($i.DisplayName)." -ForegroundColor Cyan
                Start-Service -Name $i.Name
            } else {
                Write-Host "$($i.DisplayName) already running. Continuing.." -ForegroundColor Green
            }
        }
    }

#endregion

#region get server status and loop through state (START)

    While((get-WeblogicServerStatus -server $weblogicHostname -port $weblogicPort -user $weblogicUsername -password $weblogicPassword).state -contains 'unknown' -or (get-WeblogicServerStatus -server $weblogicHostname -port $weblogicPort -user $weblogicUsername -password $weblogicPassword).state -contains 'shutdown' -or (get-WeblogicServerStatus -server $weblogicHostname -port $weblogicPort -user $weblogicUsername -password $weblogicPassword).state -contains 'starting' -or (get-WeblogicServerStatus -server $weblogicHostname -port $weblogicPort -user $weblogicUsername -password $weblogicPassword).state -contains 'stopping' ){
        Write-Host "Waiting for EPM Services to start." -ForegroundColor DarkYellow
        Sleep -Seconds 60
    }
    Write-Host "EPM Services have started successfully" -ForegroundColor Green

#endregion

#region stop admin server

    Start-Process -FilePath "$($domainPath)\bin\StopWeblogic.cmd" -Verb RunAs
 
#endregion

#region loop for admin server to stop responding

    While((Test-NetConnection -ComputerName $weblogicHostname -Port $weblogicPort -WarningAction SilentlyContinue).TcpTestSucceeded -eq $True){
        Write-Host "Waiting for Admin Server to stop" -ForegroundColor DarkYellow
        sleep -Seconds 20
    }
    Write-Host "Admin Server stopped successfully" -ForegroundColor Green
    
#endregion

#region prepare body of email

    $body = get-WeblogicServerStatus -server $weblogicHostname -port $weblogicPort -user $weblogicUsername -password $weblogicPassword
    $body = $body | ConvertTo-Html @HTMLParameters

#endregion

#region send start email

    Send-Email -sender $sender -recipient $distributionList -subject $subject -smtpServer $smtpServer -body $body

#endregion
