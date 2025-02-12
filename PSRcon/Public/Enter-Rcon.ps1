function Enter-Rcon {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        [Alias('ComputerName')]
        [Alias('PSComputerName')]
        [Alias('IPAddress')]
        $Hostname,

        [Parameter()]
        [int]
        $Port=27015,

        [Parameter(Mandatory)]
        [securestring]
        $Password
    )
    
    end {
        $client = [RconSharp.RconClient]::Create($hostname,$port)
        $connected = $client.ConnectAsync() | Wait-Async -ErrorAction Stop -TimeoutMessage "Connect timed out."
        if (-not $connected) {
            Write-Error "Connection to ${hostname}:${port} failed."
            return
        }
        $authenticated = $client.AuthenticateAsync( ( [pscredential]::new('converter',$Password).GetNetworkCredential().Password) ) | Wait-Async -ErrorAction Stop -TimeoutMessage "Authentication timed out."
        if (-not $authenticated) {
            Write-Error "Authentication Failed."
            return
        }
        
        Write-Host "Connected, use Ctrl+C to disconnect."
        try {
            while (1) {
                $command = Read-Host -Prompt '>'
                $client.ExecuteCommandAsync($command,$false) | Wait-Async  -TimeoutMessage "Timeout on command: $command"
            }
        } finally {
            $client.Disconnect()
        }

    }
}