function Wait-Async {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,ValueFromPipeline)]
        [System.Threading.Tasks.Task]
        $Task
    )
    
    end {
        try {
            $Task.Wait()
            $Task.Result
        } catch {
            Write-Error -Message $_.Exception.Message
        }
    }
}