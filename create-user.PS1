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
Write-Host ''
http --form POST "$($Gateway):8086/query" q='CREATE DATABASE "'$($NewUser)'"'
http "$($Gateway):8086/query" q=='SHOW DATABASES'

Write-Host ' - Grafana'
Write-Host ''
Write-Host '   New Organization'
http -a admin:admin POST "$($Gateway)/grafana/api/orgs" "name=$($NewUser)"
$OrganizationId = $(http -a admin:admin -b GET "$($Gateway)/grafana/api/orgs/name/$($NewUser)" | ConvertFrom-Json).id

http -a admin:admin POST "$($Gateway)/grafana/api/user/using/$($OrganizationId)"

#Write-Host '   New User'
#http -a admin:admin POST "$($Gateway)/grafana/api/admin/users" "name=$($NewUser)" "email=$($NewUser)@iotlab-gw.io" "login=$($NewUser)" "password=$($NewUser)" "orgId:=$($OrganizationId)"
Write-Host '   Add User to Organization'
http -a admin:admin POST "$($Gateway)/grafana/api/org/users" "loginOrEmail=$($NewUser)" "role=Admin"
Write-Host '   New Datasource'
http -a admin:admin POST "$($Gateway)/grafana/api/datasources" "name=$($NewUser)" "type=influxdb" "url=http://influxdb:8086" "database=$($NewUser)" "isDefault:=true" "access=proxy" "typeLogoUrl=public/app/plugins/datasource/influxdb/img/influxdb_logo.svg"

http -a admin:admin POST "$($Gateway)/grafana/api/user/using/1"
