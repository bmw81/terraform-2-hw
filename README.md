# Домашнее задание к занятию "`Основы Terraform. Yandex Cloud`" - `Белов Михаил`

### Цели задания
1. Создать свои ресурсы в облаке Yandex Cloud с помощью Terraform.
2. Освоить работу с переменными Terraform.

### Чек-лист готовности к домашнему заданию

1. Зарегистрирован аккаунт в Yandex Cloud. Использован промокод на грант.
2. Установлен инструмент Yandex CLI.

![Yandex CLI version](image.png)

3. Исходный код для выполнения задания расположен в директории [02/src](/02/src)

### Задание 0

1. Ознакомьтесь с [документацией к security-groups в Yandex Cloud](https://cloud.yandex.ru/docs/vpc/concepts/security-groups?from=int-console-help-center-or-nav). Этот функционал понадобится к следующей лекции.

Группы безопасности служат основным механизмом разграничения сетевого доступа в Yandex Cloud.

`Примеры создания групп безопасности из прошлых занятий:`
```
resource "yandex_vpc_security_group" "bastion" {
  name       = "bastion-sg-${var.flow}"
  network_id = yandex_vpc_network.develop.id
  ingress {
    description    = "Allow 0.0.0.0/0"
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }
  egress {
    description    = "Permit ANY"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}


resource "yandex_vpc_security_group" "LAN" {
  name       = "LAN-sg-${var.flow}"
  network_id = yandex_vpc_network.develop.id
  ingress {
    description    = "Allow 10.0.0.0/8"
    protocol       = "ANY"
    v4_cidr_blocks = ["10.0.0.0/8"]
    from_port      = 0
    to_port        = 65535
  }
  egress {
    description    = "Permit ANY"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}
```
---

### Задание 1

1. Изучите проект. В файле [variables.tf](./02/src/variables.tf) объявлены переменные для Yandex provider.

`Добавил значения default для переменных сloud_id и folder_id`

2. Создайте сервисный аккаунт и ключ. [service_account_key_file](https://terraform-provider.yandexcloud.net/).

![alt text](/img/Service%20account%20&%20authorized%20key.png)

3. Сгенерируйте новый или используйте свой текущий ssh-ключ. Запишите его открытую(public) часть в переменную vms_ssh_public_root_key.

`В файле variables.tf поправил имя переменной и добавил значение ключу default:`
```
###ssh vars

variable "vms_ssh_public_root_key" {
  type        = string
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEeUsauATqLdTRpLKLuDRPtOkRrnS5kM9OE+thyS2v5/ mike@mike-Perfectum-Series"
  description = "ssh-keygen -t ed25519"
}
```
`Поправил имя переменной в main.tf`

4. Инициализируйте проект, выполните код. 
```
terraform init
terraform plan
```
Исправьте намеренно допущенные синтаксические ошибки. Ищите внимательно, посимвольно. Ответьте, в чём заключается их суть.
![Bad reference](/img/bad_reference.png)
`В файле main.tf отсутствоавл указатель var. перед именем переменной:`
```
metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${var.vms_ssh_public_root_key}"
  }
```
![Syntax error](/img/syntax_error.png)
`Допущена синтаксическая ошибка в значении параметра platform_id (тип процессора). Укаазано "standart". Требуется "standard".`

`Также исправил на standard-v2, указав 2 ядра для экономии ресурсов.`

`Исправленная часть кода:`
```
resource "yandex_compute_instance" "platform" {
  name        = "netology-develop-platform-web"
    platform_id = "standard-v2"
  resources {
    cores         = 2
    memory        = 1
    core_fraction = 5
  }
  ...
}
```
![Resource created](/img/resource_created.png)
![Resource at web](/img/resource_at_web.png)

5. Подключитесь к консоли ВМ через ssh и выполните команду  `curl ifconfig.me`. Примечание: К OS ubuntu "out of a box, т.е. из коробки" необходимо подключаться под пользователем ubuntu: `"ssh ubuntu@vm_ip_address"`. Предварительно убедитесь, что ваш ключ добавлен в ssh-агент: `eval $(ssh-agent) && ssh-add` Вы познакомитесь с тем как при создании ВМ создать своего пользователя в блоке metadata в следующей лекции.

![Curl ifconfig.me](/img/ifconfig_me.png)

6. Ответьте, как в процессе обучения могут пригодиться параметры `preemptible = true` и `core_fraction=5` в параметрах ВМ.

`preemptible = true - делает машину прерываемой, что значительно экономит финансы при использовании`

`core_fraction=5 - уровень производительности ВМ составит 5% времени использования ЦП. Это также экономит финансовые затраты при обучении`

---

### Задание 2

1. Замените все хардкод-значения для ресурсов **yandex_compute_image** и **yandex_compute_instance** на отдельные переменные. К названиям переменных ВМ добавьте в начало префикс **vm_web_** . Пример: **vm_web_name**.
2. Объявите нужные переменные в файле variables.tf, обязательно указывайте тип переменной. Заполните их default прежними значениями из main.tf.
3. Проверьте terraform plan. Изменений быть не должно.

![No changes with vars](/img/no_changes_with_vars.png)

---

### Задание 3

1. Создайте в корне проекта файл [vms_platform.tf](./02/src/vms_platform.tf) . Перенесите в него все переменные первой ВМ.
2. Скопируйте блок ресурса и создайте с его помощью вторую ВМ в файле main.tf: **"netology-develop-platform-db"** , `cores  = 2, memory = 2, core_fraction = 20`. Объявите её переменные с префиксом **vm_db_** в том же файле ('vms_platform.tf'). ВМ должна работать в зоне "ru-central1-b"

`Обязательно в ресурсе каждой ВМ следует указать: для vm_db zone = var.zone_b, а для машины vm_web zone = var.default_zone. Иначе, система будет размещать vm_db в зоне доступности ru-central1-a и возникнет конфликт между ее размещением и ее сетевыми настройками`

3. Примените изменения.

![2 VM created](/img/2_vm_created.png)

---

### Задание 4

1. Объявите в файле [outputs.tf](./02/src/outputs.tf) **один** output , содержащий: instance_name, external_ip, fqdn для каждой из ВМ в удобном лично для вас формате.(без хардкода!!!)
2. Примените изменения
```
terraform output
```
![terraform output](/img/output_terraform.png)

---

### Задание 5

1. В файле [locals.tf](./02/src/locals.tf) опишите в **одном** local-блоке имя каждой ВМ, используйте интерполяцию ${..} с НЕСКОЛЬКИМИ переменными по примеру из лекции.
2. Замените переменные внутри ресурса ВМ на созданные вами local-переменные.
3. Примените изменения.

![No changes with locals](/img/no_changes_with_locals.png)

---

### Задание 6

1. Вместо использования трёх переменных ".._cores",".._memory",".._core_fraction" в блоке resources {...}, объедините их в единую map-переменную vms_resources и внутри неё конфиги обеих ВМ в виде вложенного map(object).

[Файл terraform.tfvars](./02/src/terraform.tfvars)

2. Создайте и используйте отдельную map(object) переменную для блока metadata, она должна быть общая для всех ваших ВМ.
3. Найдите и закоментируйте все, более не используемые переменные проекта.
4. Проверьте terraform plan. Изменений быть не должно.

![Nochanges tfvars](/img/tfvars_no_changes.png)

---

### Задание 7*

Изучите содержимое файла console.tf. Откройте terraform console, выполните следующие задания:

1. Напишите, какой командой можно отобразить второй элемент списка test_list.
```
local.test_list.1
# "staging"
```
2. Найдите длину списка test_list с помощью функции length(<имя переменной>).
```
length(local.test_list)
# 3
```
3. Напишите, какой командой можно отобразить значение ключа admin из map test_map.
```
local.test_map.admin
 или
local.test_map["admin"]
# "John"
```
4. Напишите interpolation-выражение, результатом которого будет: "John is admin for production server based on OS ubuntu-20-04 with X vcpu, Y ram and Z virtual disks", используйте данные из переменных test_list, test_map, servers и функцию length() для подстановки значений.

**Примечание:** если не догадаетесь как вычленить слово "admin", погуглите: "terraform get keys of map"
```
phrase = "${local.test_map.admin} is ${keys(local.test_map).0} for ${local.test_list.2} server based on OS ${local.servers.production.image} with X v${keys(local.servers.production).0}, Y ${keys(local.servers.production).1} and Z virtual ${keys(local.servers.production).3}"

# Возвращение значения переменной phrase из файла locals.tf:

local.phrase
```
![Interpolation](/img/interpolation.png)

---

### Задание 8*

1. Напишите и проверьте переменную test и полное описание ее type в соответствии со значением из terraform.tfvars:
```
test = [
  {
    "dev1" = [
      "ssh -o 'StrictHostKeyChecking=no' ubuntu@62.84.124.117",
      "10.0.1.7",
    ]
  },
  {
    "dev2" = [
      "ssh -o 'StrictHostKeyChecking=no' ubuntu@84.252.140.88",
      "10.0.2.29",
    ]
  },
  {
    "prod1" = [
      "ssh -o 'StrictHostKeyChecking=no' ubuntu@51.250.2.101",
      "10.0.1.30",
    ]
  },
]
```
```
# Проверить тип переменной, переведя содержимое в одну строку:

type([{"dev1" = ["ssh -o 'StrictHostKeyChecking=no' ubuntu@62.84.124.117", "10.0.1.7",]}, {"dev2" = ["ssh -o 'StrictHostKeyChecking=no' ubuntu@84.252.140.88", "10.0.2.29",]}, {"prod1" = ["ssh -o 'StrictHostKeyChecking=no' ubuntu@51.250.2.101", "10.0.1.30",]},])
```
```
# Результат:

tuple([
    object({
        dev1: tuple([
            string,
            string,
        ]),
    }),
    object({
        dev2: tuple([
            string,
            string,
        ]),
    }),
    object({
        prod1: tuple([
            string,
            string,
        ]),
    }),
])
```
`Описываем переменную в variables.tf:`
```
variable "test" {
  type = tuple([                                  
    object({ dev1 = tuple([ string, string ]) }), 
    object({ dev2 = tuple([ string, string ]) }),
    object({ prod1 = tuple([ string, string ]) })
  ])
}

# Тип переменной - кортеж, состоящий из 3-х объектов. Каждый объект имеет 1 ключ, значение которого представляет кортеж из 2-х строк
```

2. Напишите выражение в terraform console, которое позволит вычленить строку "ssh -o 'StrictHostKeyChecking=no' ubuntu@62.84.124.117" из этой переменной.

`Извлекаем отдельные элементы из переменной test, занеся ее значение в файл terraform.tfvars:`

![Variable test](/img/var_test.png)

---

### Задание 9*

Используя инструкцию https://cloud.yandex.ru/ru/docs/vpc/operations/create-nat-gateway#tf_1, настройте для ваших ВМ nat_gateway. Для проверки уберите внешний IP адрес (nat=false) у ваших ВМ и проверьте доступ в интернет с ВМ, подключившись к ней через serial console. Для подключения предварительно через ssh измените пароль пользователя: `sudo passwd ubuntu`

`ВМ с отключенным NAT:`

![VM without NAT](/img/vms_without_nat.png)

`Ping публичного адреса через NAT-шлюз с машины db:`

![NAT-gateway ping-1](/img/nat-gateway_ping-1.png)

`Ping публичного адреса через NAT-шлюз с машины web:`

![NAT-gateway ping-2](/img/nat-gateway_ping-2.png)


