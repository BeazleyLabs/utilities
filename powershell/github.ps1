function DownloadFileFromGitHub([string]$githubOrg = '',
                                [string]$githubRepo,
                                [string]$githubBranch = 'main',
                                [string]$fileToRead,
                                [string]$fileDestinationPath,
                                [string]$gitHubPat)
{
    # Net to use TLS 1.2 for GitHub
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    # URL of what we want to read
    $GitUri = "https://api.github.com/repos/$githubOrg/$githubRepo/contents/$($fileToRead)?ref=$githubBranch"

    # Help diagnose any URL issues
    Write-Output "Reading file: $GitUri"

    # Read the object from GitHub
    $gitObject = Invoke-RestMethod -Method Get `
                -Uri $GitUri `
                -Headers @{'accept' = 'application/vnd.github.v3+json'; `
                            'authorization' = "Bearer $gitHubPat"}

    # Decode and write contents (force UTF-8 No BOM)
    $fileContents = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($gitObject.Content))
    New-Item -Path $fileDestinationPath -ItemType "file" -Force
    $Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
    [System.IO.File]::WriteAllLines($fileDestinationPath, $fileContents, $Utf8NoBomEncoding)
}
