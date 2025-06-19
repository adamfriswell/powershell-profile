. $PSScriptRoot\..\variables.ps1

<#
.SYNOPSIS
    Convert Claude JSON export to formatted Markdown
#>
function convertClaudeExportToMd() {

    # Read the JSON file
    $jsonContent = Get-Content -Path $"C:\Users\$username\Downloads\data-2025-04-10-10-10-43\conversations.json" | ConvertFrom-Json

    # Create a StringBuilder to build the markdown content
    $markdown = New-Object System.Text.StringBuilder

    # Process each conversation
    foreach ($chat in $jsonContent) {
        # Get the timestamp of the first message to use for the chat timestamp
        $firstTimestamp = ""
        if ($chat.chat_messages.Count -gt 0) {
            $firstTimestamp = $chat.chat_messages[0].created_at
            # Convert to DateTime and format it
            try {
                $dateTime = [DateTime]::Parse($firstTimestamp)
                $formattedTime = $dateTime.ToString("yyyy-MM-dd HH:mm:ss")
            }
            catch {
                $formattedTime = $firstTimestamp
            }
        }
    
        # Write chat title
        [void]$markdown.AppendLine("# Chat: $($chat.name) $formattedTime")
        [void]$markdown.AppendLine("")
    
        # Group messages by their sender and sort by timestamp
        $messages = @{}
        foreach ($message in $chat.chat_messages) {
            if ($message.sender -eq "human" -or $message.sender -eq "assistant") {
                if (-not $messages.ContainsKey($message.uuid)) {
                    $messages[$message.uuid] = @{
                        "sender"    = $message.sender
                        "text"      = $message.text
                        "timestamp" = $message.created_at
                    }
                }
            }
        }
    
        # Sort messages by timestamp
        $sortedMessages = $messages.Values | Sort-Object -Property "timestamp"
    
        # Process sorted messages
        foreach ($message in $sortedMessages) {
            $senderName = if ($message.sender -eq "human") { "Adam" } else { "Claude" }
            $timestamp = $message.timestamp
        
            # Convert to DateTime and format it
            try {
                $dateTime = [DateTime]::Parse($timestamp)
                $formattedTime = $dateTime.ToString("yyyy-MM-dd HH:mm:ss")
            }
            catch {
                $formattedTime = $timestamp
            }
        
            # Write the message header and content
            [void]$markdown.AppendLine("## *$senderName - $formattedTime*")
            [void]$markdown.AppendLine($message.text.Trim())
            [void]$markdown.AppendLine("")
        }
    
        # Add a separator between chats
        [void]$markdown.AppendLine("---")
        [void]$markdown.AppendLine("")
    }

    # Write the markdown to the output file
    $markdown.ToString() | Out-File -FilePath "conversations.md" -Encoding utf8
}