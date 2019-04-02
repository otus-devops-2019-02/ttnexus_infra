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

## Домашнее задание №6

```
testapp_IP = 35.230.151.150
testapp_port = 9292
```

### Startup скрипт для автоматического разворачивания всего что было проделано руками в ДЗ

Сам скрипт startup-script.sh в корневой директории 

Запуск gcloud
```
gcloud compute instances create reddit-app \
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure \
  --metadata-from-file startup-script=startup-script.sh
```

### Добавление правила фаервола через gcloud
```
gcloud compute firewall-rules create puma-server \
  --allow tcp:9292 \
  --priority=1000 \
  --network=default \
  --direction INGRESS
```

## Домашнее задание №8

### Самостоятельные задания
1. Переменная private_key_path определена по аналогии с остальными переменными из задания
2. По аналогии с прошлыми определена переменная zone, в variables.tf определено для нее значение по умолчанию
3. terraform fmt отработала нормально, без ошибок
4. Файл создал, скопировал туда значения по умолчанию

### Задание со *
Добавить ключ ко всему проекту можно так:
```
resource "google_compute_project_metadata" "ssh_keys" {
  metadata {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }
}
```

Если требуется внести несколько ключей для нескольких пользователей, то синтаксисом допускается вот такое:
```
sshKeys = "${var.ssh_user}:${var.ssh_key} \n${var.ssh_user1}:${var.ssh_key1}"
```
При добавлении ключа в gcp вручную после terraform apply ключ добавленный вручную был удален, так как он не входит в список ключей, описанных в тераформе

### Задание с **
Создал пул resource "google_compute_target_pool" "reddit-app" состоящий из 2х экземпляров нашего образа
Добавил проверку состояния на 9292 порту resource "google_compute_http_health_check" "reddit-healthcheck"
Добавил правило переадресации resource "google_compute_forwarding_rule" "reddit-pool"
Очень удобно было делать через self_link

