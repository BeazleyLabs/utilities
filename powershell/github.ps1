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

    # Download contents
    Invoke-WebRequest -Uri $gitObject.download_url -Headers @{'authorization' = "Bearer $gitHubPat"} -OutFile $fileDestinationPath
}
