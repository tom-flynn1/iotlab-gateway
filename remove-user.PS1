if ($args.Count -ne 2)
{
  Write-Host 'Wrong argument count'
  Write-Host 'usage: .\remove-user.PS1 <gateway_ip> <new_username>'
  exit
}

$Gateway = $args[0]
$UserToDelete = $args[1]
Write-Host "Removing user $($UserToDelete) from IoT-Lab gateway $($Gateway)"

Write-Host ' - Grafana'

http -o remove-user.log -a admin:admin POST "$($Gateway)/grafana/api/user/using/1"

Write-Host '   Remove User'
$UserId = $(http -a admin:admin GET "$($Gateway)/grafana/api/users/lookup" "loginOrEmail==$($UserToDelete)" | ConvertFrom-Json).id
http -o remove-user.log -a admin:admin DELETE "$($Gateway)/grafana/api/admin/users/$($UserId)"
Write-Host '   Remove organisation'
$OrganisationId = $(http -a admin:admin -b GET "$($Gateway)/grafana/api/orgs/name/$($UserToDelete)" | ConvertFrom-Json).id
http -o remove-user.log -a admin:admin DELETE "$($Gateway)/grafana/api/orgs/$($OrganisationId)" "name=$($UserToDelete)"

Write-Host ' - InfluxDB'
Write-Host '   Drop database'
http -o remove-user.log --form POST "$($Gateway):8086/query" q='DROP DATABASE "'$($UserToDelete)'"'

Write-Host "User $($UserToDelete) removed"
Write-Host ''
