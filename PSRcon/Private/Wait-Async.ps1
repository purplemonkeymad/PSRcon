function Wait-Async {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,ValueFromPipeline)]
        [System.Threading.Tasks.Task]
        $Task,

        [int]$Timeout= 60*000 # default 1 minute timeout.
    )
    
    end {
        try {
            $null = $Task.Wait($Timeout)
            $Task.Result
        } catch {
            Write-Error -Message $_.Exception.Message
        }
    }
}