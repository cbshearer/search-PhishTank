## Search PhishTank for a URL
## Chris Shearer
## 20-AUG-2020
## Phishtank API information: https://www.phishtank.com/api_info.php
## Github repository for this module: https://github.com/cbshearer/search-PhishTank

Function Search-PhishTank {
    ## Accept CLI parameters 
        param (
            # U is the URL which is mandatory
                [Parameter(Mandatory=$true)] [array]$u
            )
    
    ## Set TLS 1.2
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    
    ## Null variables are happy variables!
        $Invoke = $null
        $PTresult = $null
        
    ## API Key
        $key    = "xxxxxxxxxxxxxxxxxx"
            ## Get your own PhishTank API key here: https://www.phishtank.com/register.php
        $URI    = "https://checkurl.phishtank.com/checkurl/"
        $format = "json"
        $agent  = "PLACEHOLDER"
            ## User Agent String - If blank or generic, you may get rate limited. 

    ## If variable assigned by parameter, then pass it through here.
        if ($u) {
            ## make sure supplied url it starts with "http"
                if ($u -notlike "http*") {$u = "http://" + $u}
                $url = $u}

    ## If variable not provided we are done here.
        else {}

    ## Create header and body
        $header = @{"User-Agent" = $agent}    
        $body = $null
        $body = @{
                    app_key = "$key";
                    format = "$format";
                    url = "$url"
                }
       
    ## Display what we are submitting:
        Write-Host "======================="
        Write-Host "Submitting  : "; Write-Host -f cyan "  " $url
        Write-Host "======================="
    
    ## Submit
        try {
            $Invoke = Invoke-WebRequest -Uri $URI -Method POST -Headers $header -Body $body  -ContentType "application/x-www-form-urlencoded"            
        }
        catch {
            $result = $_.errorDetails #| ConvertFrom-Json
            Write-Host $result
        }
    ## We requested JSON, so we are converting from JSON and storing in $PTResults 
        $PTResults = $Invoke | ConvertFrom-Json

    ## Analyze response        
        if ($invoke.StatusCode -eq "200" -and $PTResults.results.in_database -eq $true)
            # If request was successful and it was in the database, lets show some more information
            {
                    write-host "In the tank? : " -NoNewline; Write-Host -f green $true

                if ($PTResults.results.valid -eq $true) {      
                    # if it is a phish, then say so in red!          
                    Write-Host "Phish?       : " -NoNewline; write-host -f red $true
                    Write-Host "Verified?    : " -NoNewline; write-host -f green $true
                }
                elseif ($PTResults.results.valid -eq $false -and $PTResults.results.verified -eq $true)  {
                    # if it is not confirmed to be a phish, and it has been verified not to be a phish, say so in green!
                    Write-Host "Phish?       : " -NoNewline; write-host -f green $false
                    Write-Host "Verified?    : " -NoNewline; write-host -f green $true
                }
                elseif ($PTResults.results.valid -eq $false -and $PTResults.results.verified -eq $false)  {
                    # if it is not confirmed to be a phish, and has not been verified, then say so in yellow!
                    Write-Host "Phish?       : " -NoNewline; write-host -f yellow "Unknown"
                    Write-Host "Verified?    : " -NoNewline; write-host -f red $false
                }
                    # Since it was in the database, let's return the detail page
                    Write-Host "Phish detail : " -NoNewline; write-host -f cyan $PTResults.results.phish_detail_page

            }
        ## If the request was successful and it wasn't in the database, say so, 
            elseif ($invoke.StatusCode -eq "200" -and $PTResults.results.in_database -eq $false)
                {
                    write-host "In the tank? : " -NoNewline; Write-Host -f red $false
                    Write-Host "Phish?       : " -NoNewline; write-host -f yellow "unknown"
                } 
            
            elseif ($invoke.StatusCode -ne "200")
                {Write-Host "Status code  : " -NoNewline; Write-Host -f red $invoke.StatusCode}
        
        Write-Host "======================="
        }

Export-ModuleMember -Function Search-PhishTank