<#
.SYNOPSIS
    Try and connect GPG agent
#>
function gpgAgentFix() {
    gpg-connect-agent
}

<#
.SYNOPSIS
    View last PR in browser
#>
function lastPr() {
    gh pr view --web
}

function closeAllAuthorPrComments() {
    <#
.SYNOPSIS
    Resolves all unresolved comments by a specified author on a GitHub pull request.

.DESCRIPTION
    This script uses the GitHub GraphQL API to retrieve all review threads on a
    pull request, filters them to find unresolved threads containing a comment
    from a specific author, and then uses the GitHub REST API to resolve the
    threads. This is the most reliable method for this task.

.PARAMETER PrNumber
    The number of the pull request to process. This is a required parameter.

.PARAMETER Author
    The GitHub username of the author whose comments should be resolved.
    Defaults to 'corabbit'.

.EXAMPLE
    .\resolve-pr-comments.ps1 -PrNumber 123
    This command will resolve all unresolved comments by the user 'corabbit'
    on pull request #123 in the 'zetifinance/billingservice' repository.

.EXAMPLE
    .\resolve-pr-comments.ps1 -PrNumber 123 -Author "octocat"
    This command will resolve all unresolved comments by the user 'octocat'
    on pull request #123.

.NOTES
    Requires the GitHub CLI to be installed and authenticated.
    Run 'gh auth login' to authenticate if you haven't already.
#>
    [CmdletBinding()]
    param (
        [Parameter(HelpMessage = "The number of the pull request.")]
        [int]$PrNumber = 2708,

        [Parameter(HelpMessage = "The GitHub username of the author to resolve comments for.")]
        [string]$Author = "coderabbitai"
    )

    # --- Main Script Logic ---

    # Hardcoded repository details as requested
    $repoOwner = "zetifinance"
    $repoName = "billingservice"

    Write-Host "Resolving comments for PR #$PrNumber by user '$Author' in repository '$repoOwner/$repoName'..."

    # Define the GraphQL query to get all review threads and their resolved status
    $graphqlQuery = @'
query($owner: String!, $repo: String!, $pr: Int!, $cursor: String) {
  repository(owner: $owner, name: $repo) {
    pullRequest(number: $pr) {
      reviewThreads(first: 100, after: $cursor) {
        pageInfo {
          hasNextPage
          endCursor
        }
        nodes {
          isResolved
          comments(first: 100) {
            nodes {
              author {
                login
              }
              databaseId
            }
          }
        }
      }
    }
  }
}
'@

    $variables = @{
        owner  = "zetiFinance"
        repo   = "BillingService"
        pr     = 2708
        cursor = ""
    }

    $allThreads = @()
    $endCursor = ""
    $hasNextPage = $true

    Write-Host "Fetching all review threads on PR #$PrNumber using GraphQL..."
    try {
        while ($hasNextPage) {
            $response = & gh api graphql -f query=$graphqlQuery -f variables=$variables 2>&1 | Out-String | Write-Output
            $responseObj = $response | ConvertFrom-Json

            $threads = $responseObj.data.repository.pullRequest.reviewThreads.nodes
            $allThreads += $threads

            $pageInfo = $responseObj.data.repository.pullRequest.reviewThreads.pageInfo
            $hasNextPage = $pageInfo.hasNextPage
            $endCursor = $pageInfo.endCursor
        }
    }
    catch {
        Write-Error "Failed to fetch review threads: $_.Exception.Message"
        exit 1
    }

    # Filter for unresolved threads with a comment by the specified author
    Write-Host "Filtering for unresolved threads with comments by '$Author'..."
    $unresolvedThreadsToResolve = $allThreads | Where-Object {
        -not $_.isResolved -and $_.comments.nodes.author.login -contains $Author
    }

    if ($unresolvedThreadsToResolve.Count -gt 0) {
        Write-Host "$($unresolvedThreadsToResolve.Count) unresolved threads found to resolve."

        foreach ($thread in $unresolvedThreadsToResolve) {
            # The API requires a comment ID to resolve the thread. We'll use the first one.
            $commentId = $thread.comments.nodes | Where-Object { $_.author.login -eq $Author } | Select-Object -First 1
            $commentId = $commentId.databaseId

            Write-Host "-> Attempting to resolve thread for comment ID $commentId"

            # # Use gh api to patch the comment state. This resolves the entire thread.
            # $resolveApiEndpoint = "repos/$repoOwner/$repoName/pulls/comments/$commentId"
            # try {
            #     & gh api --method PATCH $resolveApiEndpoint -f state=resolved
            #     Write-Host "   Success: Thread resolved."
            # }
            # catch {
            #     Write-Error "   Failed to resolve thread for comment ID $commentId. Error: $_.Exception.Message"
            # }
        }
    }
    else {
        Write-Host "No unresolved threads found with comments by '$Author'."
    }

    Write-Host "Script finished."

}