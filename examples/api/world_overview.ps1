# Windows PowerShell 5.1+; no modules or administrator rights required.
# Supply SIJI_API_KEY privately in this process's environment.
# Reuse SIJI_IDEMPOTENCY_KEY for this exact request; this script never retries.
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
[Console]::OutputEncoding = New-Object System.Text.UTF8Encoding($false)
$key = [Environment]::GetEnvironmentVariable('SIJI_API_KEY')
$idem = [Environment]::GetEnvironmentVariable('SIJI_IDEMPOTENCY_KEY')
if ([string]::IsNullOrEmpty($idem)) { $idem = 'my-first-world-overview-001' }
if ($key -notmatch '^[A-Za-z0-9_.-]{16,512}$' -or $idem -notmatch '^[A-Za-z0-9_.-]{1,128}$') {
    [Console]::Error.WriteLine('Missing or invalid SIJI_API_KEY / SIJI_IDEMPOTENCY_KEY.')
    exit 2
}
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
$headers = @{
    'X-API-Key' = $key
    'Accept' = 'application/json'
    'Idempotency-Key' = $idem
}
try {
    $response = Invoke-WebRequest -UseBasicParsing -Method Post `
        -Uri 'https://sijiatlas.com/v1/agent/world/overview' `
        -Headers $headers -ContentType 'application/json' `
        -Body ([Text.Encoding]::UTF8.GetBytes('{}')) `
        -TimeoutSec 35 -MaximumRedirection 0
    if ([Text.Encoding]::UTF8.GetByteCount($response.Content) -gt 1048576) {
        [Console]::Error.WriteLine('Response exceeds this example''s 1 MiB bound.')
        exit 2
    }
    [Console]::Out.Write($response.Content + "`nSIJI_HTTP_STATUS=" + [int]$response.StatusCode + "`n")
    if ([int]$response.StatusCode -ne 200) { exit 1 }
} catch {
    # Do not dump the exception: its request context may contain headers.
    [Console]::Error.WriteLine('Request did not complete successfully; retain the same idempotency key.')
    exit 2
} finally {
    $key = $null
    $headers = $null
}
