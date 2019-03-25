# ttnexus_infra
ttnexus Infra repository

## Домашнее задание №5 

### Подключение к someinternalhost одной командой

```ssh -A -t -i ~/.ssh/appuser appuser@35.246.60.200  ssh 10.154.0.5```
 - -A - Перенаправление соединения в агенте
 - -t - Переназначение псевдотерминала
 - -i - Путь до ключа
 Далее пользователь и внешний хост и команда запускающая ssh соединение с пробросом ключа на внутренний хост

### Подключение к someinternalhost из консоли командой ssh someinternalhost

Для этого создаем файл ~/.ssh с содержимым вида:
```
Host bastion
Hostname 35.246.60.200 
IdentityFile ~/.ssh/appuser
User appuser

Host someinternalhost
ProxyCommand ssh -A bastion -W 10.154.0.5:22
```
### Подключение к someinternalhost через VPN
```
bastion_IP = 35.246.60.200
someinternalhost_IP = 10.154.0.5
```

