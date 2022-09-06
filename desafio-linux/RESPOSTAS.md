## 1. Kernel e Boot loader

###### Redefinir senha root
```
Na tela do grub precionar "e" na linha do kernel adicionar:
rw init=/sysroot/bin/bash"
crtl + x 
chroot /sysroot
passwd root
exit
reboot
```

###### Adicionando usuário ao grupo sudo.

```
usermod -aG wheel vagrant
```

## 2. Usuários

### Criação de usuários

###### Criando usuário e adicionando gurpos.

```
groupadd -g 2222 getup && sudo adduser -G bin -u 1111 -g 2222 getup
```

###### Permissão do uso do `sudo` sem solicitação de senha.

```
visudo
getup   ALL=(ALL)	NOPASSWD: ALL
```

## 3. SSH

### Autenticação confiável

###### Configurando o sshd.

```
sudo vim /etc/ssh/sshd_config
PermitRootLogin prohibit-password
PasswordAuthentication no
```

### Criação de chaves

###### Gerar chave ECDSA.

```
ssh-keygen -t ecdsa -C "Desafio ecdsa:03/09/2022"
ssh-copy-id -i ~/.ssh/getup.pub vagrant@192.168.1.236
ssh-add ~/.ssh/getup
```

###### Reiniciando após envio da chave.

``` 
sudo systemctl restart sshd.service
```

### Análise de logs e configurações ssh

###### Verificando a existência do usuário no sistema.

```
sudo getent /etc/passwd
sudo cat /etc/shadow
sudo passwd devel
```

###### Decodificando a chave

```
cat id_rsa-desafio-linux-devel.gz.b64 | base64 -d | gzip -d > id_rsa
```

###### Nessario usar o PuTTYgen para converte de OpenSSH para RSA.

###### Ajuste de permissão na chave.

```
chmod 0600 id_rsa
ssh -i id_rsa devel@192.168.1.236
```

###### Verificando Log.

```
sudo tail -f /var/log/secure | grep sshd
Authentication refused: bad ownership or modes for file /home/devel/.ssh/authorized_keys
```

###### Ajustando permissão do arquivo authorized_keys.

```
sudo ls -la /home/devel/.ssh/
sudo chmod 600 /home/devel/.ssh/authorized_keys
```

## 4. Systemd

###### Ajustando erros de configuração do nginx.

```
sudo vim /etc/nginx/nginx.conf
Linha 39 alterar porta de 90 para 80
Linha 45 adicionar ";" no final da linha

sudo nginx -t
```

###### Removendo confiugração invalida no nginx.service.

```
sudo vim /lib/systemd/system/nginx.service
Linha 13 remover -BROKEN
```

###### Restart do Nginx e habilitando na inicialização.

```
sudo systemctl enable nginx.service
sudo systemctl start nginx.service
```

```
curl http://127.0.0.1
Duas palavrinhas pra você: para, béns!
```

## 5. SSL

### Criação de certificados

###### Adicionando dominio no hosts

```
sudo vim /etc/hosts
192.168.1.236	www.desafio.local 	desafio
```

### Uso de certificados

###### Criando certificado e auto-assinado

```
sudo mkdir /etc/nginx/ssl

sudo openssl genrsa -out /etc/nginx/ssl/desafio.local.key 2048
sudo openssl req -new -key /etc/nginx/ssl/desafio.local.key -out /etc/nginx/ssl/desafio.local.csr
sudo openssl x509 -req -days 365 -in /etc/nginx/ssl/desafio.local.csr -signkey /etc/nginx/ssl/desafio.local.key -out /etc/nginx/ssl/desafio.local.crt
```

###### Trocando porta 80 por 443 e adicionando certificados.

```
sudo vim /etc/nginx/nginx.conf
listen       443 ssl default_server;
listen       [::]:443 ssl default_server;

ssl_certificate /etc/nginx/ssl/desafio.local.crt;
ssl_certificate_key /etc/nginx/ssl/desafio.local.key

sudo systemctl restart nginx.service
```

###### Teste do certificado.

```
curl https://www.desafio.local --cacert /etc/nginx/ssl/desafio.local.crt
Duas palavrinhas pra você: para, béns!
```

## 6. Rede

### Firewall

###### ping esta funcionando normalmente.

```
sudo ip route show

sudo firewall-cmd --list-all
```

### HTTP

###### Resultado da Headers 

```
curl -I https://httpbin.org/response-headers?hello=world

HTTP/2 200 
date: Mon, 05 Sep 2022 01:14:45 GMT
content-type: application/json
content-length: 89
server: gunicorn/19.9.0
hello: world
access-control-allow-origin: *
access-control-allow-credentials: true
```

## Logs

###### Configurando logrotate.

```
sudo vim /etc/logrotate.d/nginx

/var/log/nginx/ {
    missingok
    weekly
    create 0664 root root
    minsize 1M
    rotate 4
}
sudo systemctl restart logrotate.service

```

## 7. Filesystem

### Expandir partição LVM

###### Redimensionado a partição sdb1 de 1G para 5G e expadindo o filesystem. 

```
sudo cfdisk /dev/sdb -> Resize -> Write
sudo pvscan
sudo pvresize /dev/sdb1 
sudo lvextend -L +4G /dev/data_vg/data_lv
sudo resize2fs /dev/data_vg/data_lv
```

### Criar partição LVM

###### Criação da LVM usando a partição sdb2

```
sudo pvcreate /dev/sdb2
sudo vgcreate vg_backup /dev/sdb2
sudo lvcreate -n lv_backup -L 4.99G vg_backup
sudo mkfs.ext4 /dev/mapper/vg_backup-lv_backup 
```

### Criar partição XFS

###### Criação da partição usando XFS

```
sudo dnf install xfsprogs
sudo mkfs.xfs /dev/sdc
```