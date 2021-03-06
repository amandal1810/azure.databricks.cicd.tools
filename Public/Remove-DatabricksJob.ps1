<#
.SYNOPSIS
Delete a job from Databricks with given Job Id

.DESCRIPTION
Delete a job from Databricks with given Job Id 

.PARAMETER BearerToken
Your Databricks Bearer token to authenticate to your workspace (see User Settings in Datatbricks WebUI)

.PARAMETER Region
Azure Region - must match the URL of your Databricks workspace, example northeurope

.PARAMETER JobId
Id of the job to delete

.EXAMPLE
PS C:\> Remove-DatabricksJob -BearerToken $BearerToken -Region $Region -JobId 10

.NOTES
Author: Tadeusz Balcer
#>  

Function Remove-DatabricksJob
{ 
    [cmdletbinding()]
    param (
        [parameter(Mandatory = $true)][string]$BearerToken, 
        [parameter(Mandatory = $true)][string]$Region,
        [parameter(Mandatory = $true)][string]$JobId
    ) 

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $InternalBearerToken =  Format-BearerToken($BearerToken) 
    $Region = $Region.Replace(" ","")
    
    $Body = @{}
    $Body['job_id'] = $JobId

    $BodyText = $Body | ConvertTo-Json -Depth 10
    
    Try {
        Invoke-RestMethod -Method Post -Body $BodyText -Uri "https://$Region.azuredatabricks.net/api/2.0/jobs/delete" -Headers @{Authorization = $InternalBearerToken}
    }
    Catch {
        Write-Output "StatusCode:" $_.Exception.Response.StatusCode.value__ 
        Write-Output "StatusDescription:" $_.Exception.Response.StatusDescription
        Write-Error $_.ErrorDetails.Message
    }

    Return 
}
    