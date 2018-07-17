if ($args.Count -ne 1)
{
  Write-Host 'Wrong argument count'
  Write-Host 'usage: .\create-training-user-set.PS1 <gateway_ip>'
  exit
}

$Gateway = $args[0]
$UserCount = 12
Write-Host "Creating $($UserCount) users on IoT-Lab gateway $($Gateway)"

for ($i = 1; $i -lt $($UserCount + 1); $i++) {
  .\create-user.PS1 $($Gateway) "training$($i)"
}
