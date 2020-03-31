param(
    [Parameter(Mandatory=$true)]
    [string] $connectionString,
    [Parameter(Mandatory=$true)]
    [string] $scriptFileName
)

Write-Host "Reading $PSScriptRoot\$scriptFileName"

$query = [IO.File]::ReadAllText("$PSScriptRoot\$scriptFileName")

$batches = $query -split "GO\r\n"

Write-Host "Connection to DB for update with connection info: $connectionString"

$connection = New-Object -TypeName System.Data.SqlClient.SqlConnection($connectionString)
$connection.Open()

foreach($batch in $batches)
{
    if ($batch.Trim() -ne ""){

        Write-Verbose "Executing... $batch"

        $SqlCmd = New-Object System.Data.SqlClient.SqlCommand
        $SqlCmd.CommandText = $batch
        $SqlCmd.Connection = $connection
        $SqlCmd.ExecuteNonQuery()
    }
}

Write-Host "Update completed successfully. Closing DB connection..."

$connection.Close()