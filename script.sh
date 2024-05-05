# скачаем Postfix - smtp сервер (исходящая почта)
sudo apt install postfix
# сделаем первичные настройки
dpkg-reconfigure postfix
# укажем куда почта будет складываться
sudo postconf -e 'home_mailbox= mail/'
# для каждого почтового пользователя заведем пользователя в системе (нужно, так как туда складывается их почта)
sudo adduser user1
sudo adduser user2
sudo postconf -e 'virtual_alias_maps= hash:etc/postfix/virtual'
# таблица соответствия адресов и пользователей
sudo nano /etc/postfix/virtual
#применим таблицу соответствия
sudo postmap /etc/postfix/virtual
sudo systemctl restart postfix
# проверим дополнительно, что открылся нужный порт
netstat -tlpn

#Dovecot - imap сервер
sudo apt install dovecot-core dovecot-pop3d
sudo nano /etc/dovecot/dovecot.conf
# раскомментировать listen: - чтобы слушал нужные ip
sudo nano -l /etc/dovecot/conf.d/10-auth.conf
# сделаем следующее, чтобы траффик был нагляднее:
# disable_plain_text =no (10)
# auth = plain login (100)
sudo nano -l /etc/dovecot/conf.d/10-mail.conf
# maildir (30) - пропишем, куда будет складываться почта
sudo nano -l /etc/dovecot/conf.d/10-master.conf
# то откуда прослушивать получаемые сообщения
# связка postfix-dovecot
# unix_listener = /var/spool/postfix/virtual/auth (100)
sudo systemctl restart dovecot
# порт
netstat -tlpn