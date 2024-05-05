<h1> Своя почта </h1>

- Bat:  почтовый клиент
- Postfix: smtp сервер
- Dovecot: IMAP сервер

<h2> Postfix (smtp server)</h2>

применим первичные настройки: <br>
```shell
dpkg-reconfigure postfix
```
- тип почты
- название почты
- поддерживаемы сети
- проверим, что прослушиваются нужные порты
<br>



![Текст с описанием картинки](./pics/internet_site.jpg)

![Текст с описанием картинки](./pics/mail_name.jpg)

![Текст с описанием картинки](./pics/networks.jpg)


<br>
укажем куда почта будет складываться
для каждого почтового пользователя заведем пользователя в системе (нужно, так как туда складывается их почта)

```shell
sudo postconf -e 'home_mailbox= mail/'
sudo adduser user1
sudo adduser user2
sudo postconf -e 'virtual_alias_maps= hash:etc/postfix/virtual'
```
пропишем таблица соответствия адресов и пользователей
<br> и применим таблицу соответствия
```shell
sudo nano /etc/postfix/virtual
sudo postmap /etc/postfix/virtual
sudo systemctl restart postfix
```

![Текст с описанием картинки](./pics/postmap.jpg)

проверим дополнительно, что открылся нужный порт
```shell
netstat -tlpn
```

![Текст с описанием картинки](./pics/ports.jpg)

<h2> Dovecot (imap server)</h2>

раскомментировать listen: - чтобы слушал нужные ip
```shell
sudo apt install dovecot-core dovecot-pop3d
sudo nano /etc/dovecot/dovecot.conf
```
сделаем следующее, чтобы траффик был нагляднее:
disable_plain_text =no (10)
auth = plain login (100)
```shell
sudo nano -l /etc/dovecot/conf.d/10-auth.conf
```
maildir (30) - пропишем, куда будет складываться почта
```shell
sudo nano -l /etc/dovecot/conf.d/10-mail.conf
```
то откуда прослушивать получаемые сообщения
<br> связка postfix-dovecot
<br> unix_listener = /var/spool/postfix/virtual/auth (100)
```shell
sudo nano -l /etc/dovecot/conf.d/10-master.conf
sudo systemctl restart dovecot
```

<h2> The Bat (mail client)</h2>

- заведем пользователей с указанием smtp и imap сервера

![Текст с описанием картинки](./pics/bat.jpg)

- начнем записывать траффик wireshark 
- отправим письмо
![Текст с описанием картинки](./pics/bat1.jpg)
- не будем нажимать кнопку принять почту на другом пользователе (как видно письма нет)
![Текст с описанием картинки](./pics/bat2.jpg)
- залезем на imap сервере в /home/user1/mail/new (сюда складывается входящая почта для пользователя)
![Текст с описанием картинки](./pics/letter.jpg)
- заметим, что есть письмо, которое еще не было доставлено юзеру
- залезем в него и увидим наши "9"
![Текст с описанием картинки](./pics/letter2.jpg)
- загрузим на клиенте почту
![Текст с описанием картинки](./pics/letter3.jpg)

<h2> Wireshark</h2>

- применим фильтр для траффика 

![Текст с описанием картинки](./pics/wiresharks.jpg)

- найдем наше сообщение в траффике исходящей почты (smtp)
![Текст с описанием картинки](./pics/wiresharks2.jpg)
- найдем наше сообщение в траффике входящей почты (imap)
![Текст с описанием картинки](./pics/wiresharks3.jpg)