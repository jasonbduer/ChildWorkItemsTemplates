function Get-ChildTemplates {
<#
.SYNOPSIS
Gets a set of child work items and outputs the format into JSON for use with the child task template extension.

.DESCRIPTION
This function sends a GET request to an ADO Parent work item ID and gets all related Child work items, creating a JSON template from them.

.EXAMPLE
Get-ChildTemplates -organization "https://dev.azure.com/YOURORG" -project "YOURPROJECT" -Token "PAT" -id "ParentID" -TemplateName "NewTest"

Author: Jason Duer
Date: October 2025
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$organization,
    
    [Parameter(Mandatory=$true)]
    [string]$project,
    
    [Parameter(Mandatory=$false)]
    [string]$Token,
    
    [Parameter(Mandatory=$true)]
    [string]$id,
    
    [Parameter(Mandatory=$true)]
    [string]$TemplateName,
    
    [Parameter(Mandatory=$false)]
    [string]$ArtifactsDirectory = "$env:USERPROFILE"
)

function Get-WorkItem {
    param(
        [Parameter(Mandatory=$true)]
        [string]$id,
        
        [Parameter(Mandatory=$false)]
        [string]$organization,
        
        [Parameter(Mandatory=$false)]
        [string]$project,
        
        [Parameter(Mandatory=$false)]
        [string]$Token
    )

    $headers = @{ Authorization = "Bearer $Token" }
    $url = "$organization/$project/_apis/wit/workitems/$($id)?api-version=7.0"
    return (Invoke-RestMethod -Uri $url -Headers $headers -Method Get).fields
}

function Clean-Text {
    param([string]$text)

    $cleaned = [System.Text.RegularExpressions.Regex]::Replace($text, "<[^>]+>", "")
    $cleaned = $cleaned -replace "\\u0026nbsp;", " "
    $cleaned = $cleaned -replace "\\u0027", "'"
    $cleaned = $cleaned -replace "system\\u0027s", "system"
    $cleaned = $cleaned -replace "&nbsp;", " "
    $cleaned = $cleaned -replace "&amp;", "&"
    return $cleaned
}

$headers = @{ Authorization = "Bearer $Token" }
$url = "$organization/$project/_apis/wit/workitems/$id/?api-version=7.0&`$expand=all"
$workItem = Invoke-RestMethod -Uri $url -Headers $headers -Method Get
$childLinks = $workItem.relations | Where-Object { $_.rel -eq "System.LinkTypes.Hierarchy-Forward" }

$formattedOutput = @()

foreach ($link in $childLinks) {
    $childId = ($link.url -split "/")[-1]
    $childItem = Get-WorkItem -id $childId -organization $organization -project $project -Token $Token
    $workItemType = $childItem.'System.WorkItemType'

    $fieldsArray = @(
        @{ name = "System.Title"; value = if ($null -eq $childItem.'System.Title') { "CTT" } else { Clean-Text $childItem.'System.Title' } },
        @{ name = "System.Description"; value = if ($null -eq $childItem.'System.Description') { "CTT" } else { Clean-Text $childItem.'System.Description' } },
        @{ name = "Microsoft.VSTS.Common.Priority"; value = "2" },
        @{ name = "System.IterationPath"; value = '{System.IterationPath}' },
        @{ name = "System.AreaPath"; value = '{System.AreaPath}' },
        @{ name = "System.Tags"; value = if ($null -eq $childItem.'System.Tags') { "CTT" } else { $childItem.'System.Tags' } }
    )

    if ($workItemType -ne "Task") {
        $fieldsArray += @{
            name = "Microsoft.VSTS.Common.AcceptanceCriteria"
            value = if ($null -eq $childItem.'Microsoft.VSTS.Common.AcceptanceCriteria') { "CTT" } else { Clean-Text $childItem.'Microsoft.VSTS.Common.AcceptanceCriteria' }
        }
        $fieldsArray += @{
            name = "Microsoft.VSTS.Common.ValueArea"
            value = if ($null -eq $childItem.'Microsoft.VSTS.Common.ValueArea') { "CTT" } else { $childItem.'Microsoft.VSTS.Common.ValueArea' }
        }
    }

    $formattedOutput += [PSCustomObject]@{
        name  = Clean-Text $childItem.'System.Title'
        type  = $workItemType
        fields = $fieldsArray
    }
}

Write-Host "{"
Write-Host "`"name`": `"$TemplateName`","
Write-Host "`"tasks`":"
Write-Host ($formattedOutput | ConvertTo-Json -Depth 5)
Write-Host "}"

$fullOutput = [PSCustomObject]@{
    name  = $TemplateName
    tasks = $formattedOutput
}

$outputPath = "$ArtifactsDirectory/output"
if (-not (Test-Path $outputPath)) {
    New-Item -ItemType Directory -Path $outputPath | Out-Null
}

$fullOutput | ConvertTo-Json -Depth 5 | Out-File "$outputPath/$TemplateName.json" -Encoding utf8
Write-Host "Output file located at $($outputPath)/$($TemplateName).json"
}