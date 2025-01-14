# Fetch all remote branches first
git fetch origin

# Get all remote branches excluding master and main
$remoteBranches = git branch -r | Where-Object { 
    $_ -notmatch '->' -and 
    $_ -notmatch 'master' -and 
    $_ -notmatch 'main' 
} | ForEach-Object { $_.Trim() }

# Store current branch
$currentBranch = git branch --show-current

# Create local tracking branches
foreach ($remote in $remoteBranches) {
    # Extract branch name without 'origin/'
    $branchName = $remote -replace 'origin/', ''
    
    # Try to create local branch tracking remote branch
    try {
        git branch --track $branchName $remote 2>$null
        Write-Host "Created local branch: $branchName"
    }
    catch {
        Write-Host "Branch $branchName already exists"
    }
}

# Switch back to original branch
git switch $currentBranch