if ($args.Count -ne 2)
{
  Write-Host 'Wrong argument count'
  Write-Host 'usage: .\create-user.PS1 <gateway_ip> <new_username>'
  exit
}

$Gateway = $args[0]
$NewUser = $args[1]
Write-Host "Creating user $($NewUser) on IoT-Lab gateway $($Gateway)"

Write-Host ' - InfluxDB'
Write-Host '   Database'
http -o remove-user.log --form POST "$($Gateway):8086/query" q='CREATE DATABASE "'$($NewUser)'"' 

Write-Host ' - Grafana'
Write-Host '   New organisation'
http -o remove-user.log -a admin:admin POST "$($Gateway)/grafana/api/orgs" "name=$($NewUser)"
$organisationId = $(http -a admin:admin -b GET "$($Gateway)/grafana/api/orgs/name/$($NewUser)" | ConvertFrom-Json).id

http -o remove-user.log -a admin:admin POST "$($Gateway)/grafana/api/user/using/$($organisationId)"

Write-Host '   New User'
http -o remove-user.log -a admin:admin POST "$($Gateway)/grafana/api/admin/users" "name=$($NewUser)" "email=$($NewUser)@iotlab-gw.io" "login=$($NewUser)" "password=$($NewUser)"
$UserId = $(http -a admin:admin GET "$($Gateway)/grafana/api/users/lookup" "loginOrEmail==$($NewUser)" | ConvertFrom-Json).id
Write-Host '   Add User to organisation'
http -o remove-user.log -a admin:admin POST "$($Gateway)/grafana/api/org/users" "loginOrEmail=$($NewUser)" "role=Admin"
Write-Host '   Remove User from default organisation'
http -o remove-user.log -a admin:admin DELETE "$($Gateway)/grafana/api/orgs/1/users/$($UserId)"
Write-Host '   New Datasource'
http -o remove-user.log -a admin:admin POST "$($Gateway)/grafana/api/datasources" "name=$($NewUser)" "type=influxdb" "url=http://influxdb:8086" "database=$($NewUser)" "isDefault:=true" "access=proxy" "typeLogoUrl=public/app/plugins/datasource/influxdb/img/influxdb_logo.svg"

http -o remove-user.log -a admin:admin POST "$($Gateway)/grafana/api/user/using/1"

Write-Host "User $($NewUser) created"
Write-Host ''
