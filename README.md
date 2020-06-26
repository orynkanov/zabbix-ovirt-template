# zabbix-ovirt-template
Зависимости на сервере ovengine:<br />
jq - yum install jq<br />
<br />
Шаги установки:<br />
1 - скопировать файл zbx-ovirt.conf на сервере ovengine в директорию /etc/zabbix/zabbix_agentd.d<br />
2 - скопировать файл zbx-ovirt.sh на сервере ovengine в директорию /etc/zabbix/scripts<br />
3 - установить права на файл zbx-ovirt.sh - 755<br />
4 - создать хост (ovengine) в zabbix<br />
5 - присоединить шаблон 'Template oVirt Engine' к хосту (ovengine)<br />
6 - готово<br />
<br />
Через 1 час в zabbix создадутся объекты ovirt - hosts, vms, storage domains.
