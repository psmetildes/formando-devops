# Desafio Terraform

## 1. Módulos

Escreva um módulo terraform para criar um cluster kind usando o provider `kyma-incubator/kind` com as seguintes características:

utilizado o `kubeadm_config_patches` no nodes para confiurar o nome do node e a label:

```
Node = infra com label role=infra;
Node = app com label role=app;
```

Foi definido as variaveis abaixo no arquivo terrafile.tf e dentro do modulo no varaiable.tf:
```
- cluster_name
- kubernetes_version
```

O configurado o output para retornar os seguintes atributos:
```
- api_endpoint
- kubeconfig
- client_certificate
- client_key
- cluster_ca_certificate
```

## 2. Gerenciando recursos customizados

```
```

## 3. Templates

Escreva um código para criar automaticamente o arquivo `alo_mundo.txt` a partir do template `alo_mundo.txt.tpl` abaixo:

criado um arquivo main.tf utilizando o resouce local_file:
```
resource "local_file" "create_file" {
  content = templatefile( 
    "${path.module}/templates/alo_mundo.txt.tpl", { 
      nome = "${var.nome}",
      data = formatdate("DD, M, YYYY","${timestamp()}"), 
      div = "${var.numero_divisor}",
      resto = jsonencode([ for x in range(0, 100 ) : x if x%var.numero_divisor == 0])
    } 
  )  

  filename = "${path.module}/files/alo_mundo.txt"
  
}

```

## 4. Assumindo recursos

Descreva abaixo como você construiria um `resource` terraform a partir de um recurso já existente, como uma instância `ec2`.

1ª Entrar no console web da AWS ir em EC2 e pegar o id da instancia desejada.<br />
2ª criar um resource no `main.tf` com as sguintes informaçẽos:

``` 
resource "aws_instance" "instancia1" {
  # (resource arguments)
}
```

Usar o comando para fazer o import:

```
terraform import aws_instance.webserver i-0f52c02bd0bdf4bcb
```

Fazer o pull para pesquisar o AMI e Tipo de instancia:

```
terraform state pull > import_ec2.tfstate

cat import_ec2.tfstate | egrep "ami|instance_type"
"ami": "ami-08c40ec9ead489470",
            "instance_type": "t2.micro",
```

Preencher os parametros com as informações obtida no camando acima:

```
resource "aws_instance" "webserver" {
  ami = "ami-08c40ec9ead489470"
  instance_type = "t2.micro"
}

```
Atualizar o state file
```
terraform plan -out plano
terraform apply plano 
```
