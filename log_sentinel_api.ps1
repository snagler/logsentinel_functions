function Write-Log {
    
    param (
    
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $actor_id,
     
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $actor_displayname,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $action,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $details
    
    )

    #You will need to input your Organization ID, Secret and Application ID below (found on the logsentinel dashboard)
    $organization_id = "INSERT ORGRANIZATION ID HERE"
    $secret = "INSERT SECRET ID HERE"
    $application_id = "INSERT APPLICATION ID HERE"

    #Converting to base64
    $convert_bytes = [System.Text.Encoding]::UTF8.GetBytes($organization_id + ":" + $secret)
    $authorization = [System.Convert]::ToBase64String($convert_bytes)

    $userinfo = "$action" + "?actorDisplayName=" + "$actor_displayname"
    $uri ="https://logsentinel.com/api/log/$actor_id/$userinfo"

    $header = @{
        
        "Application-Id" = $application_id
        "Authorization" = "Basic $authorization"
        "Content-Type" = 'application/json'
        "Accept" = 'application/json'
        "Audit-Log-Entry-Type" = 'SYSTEM_EVENT'

    }

    Invoke-RestMethod -Method POST -Uri $uri -Headers $header -Body $details

}