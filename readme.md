# search-PhishTank

- Use the PhishTank API find PhishTank reputation. 
- API Documentation: https://www.phishtank.com/api_info.php.

## To use this module

- Import the module 

```powershell
PS C:\temp> Import-Module .\search-PhishTank.psm1
```

- Change parameters on the following lines:  
  - 22: Enter your API Key (If you don't have one, register for a PhishTank API key here: https://www.phishtank.com/register.php)
  - 26: Agent name
    - Should be descriptive or you may be subject to rate limiting.
    - https://www.phishtank.com/api_info.php.

- Mandatory parameter:
  - -u: URL
- Note: if URL does not begin with "http, then "http://" will be added
- Examples:

```PowerShell
search-PhishTank -u http://superfake.com/really/really/awful/  
search-PhishTank https://veryphishy.buzz/very/phishy/o365.html  
search-PhishTank -u veryphishy.buzz/very/phishy.html
```

## The following information is returned on the screen

- URL Being submitted
- Is this URL known in the PhishTank database? True/False
  - If it is in the database, return the following information:
    - Is it a Phish? True / False / Unknown
    - Is it verified to be a Phish? True / False
    - Phish detail: PhishTank web page with results.
  - If it is not in the database, return the following information:
    - Is it a Phish? Unknown
