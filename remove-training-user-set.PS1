if ($args.Count -ne 1)
{
  Write-Host 'Wrong argument count'
  Write-Host 'usage: .\cleanup-training-user-set.PS1 <gateway_ip>'
  exit
}

$Gateway = $args[0]
$UserCount = 12
Write-Host "Cleaning up $($UserCount) users on IoT-Lab gateway $($Gateway)"

for ($i = 1; $i -lt $($UserCount + 1); $i++) {
  .\remove-user.PS1 $($Gateway) "training$($i)"
}
