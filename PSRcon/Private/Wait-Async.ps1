function Wait-Async {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,ValueFromPipeline)]
        [System.Threading.Tasks.Task]
        $Task,

        [int]$Timeout= 60*1000, # default 1 minute timeout.

        [string]$TimeoutMessage
    )
    
    end {
        $null = $Task.Wait($Timeout)
        if ($Task.Status -lt [System.Threading.Tasks.TaskStatus]::Running){
            if ($Task.IsFaulted) {
                Write-Error -Exception $task.Exception
                return
            }
            $Task.Result
        } else {
            Write-Error -Message "Timeout waiting for task. $TimeoutMessage"
        }
    }
}