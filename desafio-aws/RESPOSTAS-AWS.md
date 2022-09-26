# Desafio AWS

## 1 - Setup de ambiente

```
export STACK_FILE="file://formandodevops-desafio-aws.json"
aws cloudformation create-stack --region us-east-1 --template-body "$STACK_FILE" --stack-name "$STACK_NAME" --no-cli-pager
aws cloudformation wait stack-create-complete --stack-name "$STACK_NAME"
```

## 2 - Networking

No security groups **stack-controle-WebServerSecurityGroup-xxx** não havia regra para a porta 80.
Efetuado alterações na inbound rules:

```
Port Range: 81-8080 Source: 0.0.0.0/1

Para: 

Port Range: 80-8080 Source: 0.0.0.0/0
```
![](https://github.com/psmetildes/formando-devops/blob/main/desafio-aws/imgens/sec_group.gif)

## 3 - EC2 Access

1 - acesse a EC2:

Gerado par de chaves com aws cli:

```
cd ~/.ssh
aws ec2 create-key-pair --key-name awschallenge --key-type ed25519 --query 'KeyMaterial' --output text > awschallenge.pem
chmod 400 awschallenge.pem
ssh-keygen -y -f awschallenge.pem > awschallenge.pub
cat awschallenge.pub
```
No sercurity group stack-controle-WebServerSecurityGroup-xxx, foi criado um inbound rules liberando a porta 22 origem 0.0.0.0/0.
Feito acesso via EC2 Instance Connect e adicionado a chave publica.

```
vim .ssh/authorized_keys
colado a chave publica
``` 

Acesso via ssh:

``` 
ssh -i ~/.ssh/awschallenge.pem ec2-user@ec2-54-161-182-90.compute-1.amazonaws.com
```

2 - Alterado texto da página web:

```
vim /var/www/html/index.html
sudo vim /var/www/html/index.html
<html><body><h1> Paulo Sergio - Formando ... <h1></body></html>
```

![](https://github.com/psmetildes/formando-devops/blob/main/desafio-aws/imgens/ssh.gif)


## 4 - EC2 troubleshooting

Ao utilizar o EC2 Instance Connect, não foi necessário desligar a instancia.
Realizado o ajuste para que na proxima etapa o apache2 inicie automaticamente após a reinicialização. 

```
sudo systemctl status httpd
 Loaded: loaded (/usr/lib/systemd/system/httpd.service; disabled; vendor preset: 

sudo systemctl enable httpd
```

![](https://github.com/psmetildes/formando-devops/blob/main/desafio-aws/imgens/apache2_enable.gif)


## 5 - Balanceamento

Criando uma imagem:

```
No console AWS Incances -> selecionado Intancia -> Clicar em Actions -> Image -> Create Image

Image Name: aws-chellenge-ami
```
![](https://github.com/psmetildes/formando-devops/blob/main/desafio-aws/imgens/ami.gif)

Crianto Template:

```
No console AWS Incances -> selecionado Intancia -> Clicar em Actions -> Create template from instance.

Launch template name: aws-chellenge-template
Selecionado a imagem: aws-chellenge-ami
Selecionado a key pair: awschallenge

Advanced details: 
Nas opções referente ao Metadata foi colocado a opção "Don't include in launch template"
No User data foi removido o script, pois a imagem já contém o apache2 e a personalização do index.html

Launch instance from template 
Source: Template aws-chellenge-template
``` 

![](https://github.com/psmetildes/formando-devops/blob/main/desafio-aws/imgens/template.gif)


Criando Load Balancing:

```
Create Load Balancer -> Application Load Balancer 

Name: aws-challenge-lb 
Scheme: internet-facing
IP address type: ipv4
VPC:  Formando DevOps - AWS Challenge
Subnet:  Formando DevOps - AWS Challenge Public Subnet (AZ1)
Subnet:  Formando DevOps - AWS Challenge Public Subnet (AZ2)

Security Groups: stack-controle-WebServerSecurityGroup-xxx

Target group: New target group

Target group name: aws-challenge-tg
Target type: Instance
Protocol HTTP:
Port: 80
Protocol version: HTTP1

Health checks:
Protocol: HTTP 
Path: /index.html
Advanced health check settings: dexei Default 

Registered targets:

Add to registered -> Selecinado as Instancias 
on porta: 80
```
![](https://github.com/psmetildes/formando-devops/blob/main/desafio-aws/imgens/load_balancer.gif)

## 6 - Segurança

Foi criado um security groups para o load balancer:

```
Nome: aws-challenge-sec-lb
inbound rules:
Range Port: 80 - Source: 0.0.0.0/0

No security groups stack-controle-WebServerSecurityGroup-xxxx 
inbound rules:

Range Port: 81-8080 - Source: 0.0.0.0/0
Range Port: ssh - Source: My IP
Range Port: HTTP - Source: aws-challenge-sec-lb

No Load Balancer foi alterado o security groups stack-controle-WebServerSecurityGroup-xxxx para aws-challenge-sec-lb.

```
![](https://github.com/psmetildes/formando-devops/blob/main/desafio-aws/imgens/sec_group_lb.gif)
