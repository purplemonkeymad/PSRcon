function Connect-Rcon {
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
        $connected = $client.ConnectAsync() | Wait-Async -ErrorAction Stop
        $authenticated = $client.AuthenticateAsync( ( [pscredential]::new('converter',$Password).GetNetworkCredential().Password) ) | Wait-Async -ErrorAction Stop
        if ($authenticated) {
            Write-Host "Connected, use Ctrl+C to disconnect."
            try {
                while (1) {
                    $command = Read-Host -Prompt '>'
                    $client.ExecuteCommandAsync($command,$true) | Wait-Async
                }
            } finally {
                $client.Disconnect()
            }
        } else {
            Write-Error "Authentication Failed."
        }
    }
}