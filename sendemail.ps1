$SMTPServer = "smtp.gmail.com"
$SMTPPort = "587"
$Username = "notices@tmbs.org.sg"
$Password = "******"

$to = "bruceliu2008@gmail.com"
$subject = "Email Subject with attachment"
$body = @"
<html>
<body>
<p>Testing mass email with bcc feature and attachmet.</p>
<p>Pls feedback how it works to bro Beegsoon.</p><br>
Thanks, Jian hong <br>
<img src="cid:image1.jpg">
</body>
</html>
"@

$currentPath = get-location
$attachment = New-Object System.Net.Mail.Attachment -ArgumentList "$currentPath/Avalokitesvara-Bodhisattvas-Puja1.jpg"

$attachment.ContentDisposition.Inline = $True
$attachment.ContentDisposition.DispositionType = "Inline"
$attachment.ContentType.MediaType = "image/jpg"
$attachment.ContentId = "image1.jpg"


$message = New-Object System.Net.Mail.MailMessage
$message.subject = $subject
$message.body = $body
$message.IsBodyHTML = $true  
$message.from = $username

$csv = Import-Csv "$currentPath/email.list.csv"
foreach ($line in $csv) {
    write-host "Email: $line.email"
    $message.bcc.add($line.email)
}
$message.attachments.Add($attachment)

$smtp = New-Object System.Net.Mail.SmtpClient($SMTPServer, $SMTPPort);
$smtp.EnableSSL = $true
$smtp.Credentials = New-Object System.Net.NetworkCredential($Username, $Password);
$smtp.send($message)
write-host "Mail Sent"