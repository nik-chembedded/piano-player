# Serves this folder on http://localhost:8765 so the piano sounds can load,
# then opens it in your browser. Close this window to stop.
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$port = 8765
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$port/")
try { $listener.Start() } catch {
  Write-Host "Port $port is busy. If Piano Roll is already running, just open http://localhost:$port/"
  Start-Process "http://localhost:$port/"
  exit 1
}
$types = @{
  ".html" = "text/html; charset=utf-8"; ".js" = "text/javascript; charset=utf-8"; ".css" = "text/css"
  ".json" = "application/json"; ".webmanifest" = "application/manifest+json"
  ".png" = "image/png"; ".svg" = "image/svg+xml"; ".mp3" = "audio/mpeg"; ".mid" = "audio/midi"
}
Write-Host "Practice Piano Roll is running at http://localhost:$port/"
Write-Host "Close this window to stop it."
Start-Process "http://localhost:$port/"
$rootFull = [System.IO.Path]::GetFullPath($root)
while ($listener.IsListening) {
  $ctx = $listener.GetContext()
  $res = $ctx.Response
  try {
    $rel = [Uri]::UnescapeDataString($ctx.Request.Url.AbsolutePath.TrimStart("/"))
    if ($rel -eq "") { $rel = "index.html" }
    $file = [System.IO.Path]::GetFullPath((Join-Path $root $rel))
    if ($file.StartsWith($rootFull) -and (Test-Path $file -PathType Leaf)) {
      $ext = [System.IO.Path]::GetExtension($file).ToLower()
      $res.ContentType = $(if ($types.ContainsKey($ext)) { $types[$ext] } else { "application/octet-stream" })
      $bytes = [System.IO.File]::ReadAllBytes($file)
      $res.ContentLength64 = $bytes.Length
      $res.OutputStream.Write($bytes, 0, $bytes.Length)
    } else {
      $res.StatusCode = 404
    }
  } catch {
    $res.StatusCode = 500
  } finally {
    $res.Close()
  }
}
