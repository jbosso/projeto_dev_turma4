# Aplicação em Kubernetes e Pipeline em Jenkins

![Capa do Projeto](http://www.logicadomercado.com.br/wp-content/uploads/2019/02/shutterstock-1133982038.png)

# Sobre o Projeto

Projeto com 3 pipelines de deploy via Jenkins para aplicação JAVA rodando em Kubernets com banco de dados My SQL.

# Índice/Sumário

* [Sobre](#sobre-o-projeto)
* [Sumário](#índice/sumário)
* [Requisitos Funcionais](#requisitos-funcionais)
* [Tecnologias Usadas](#tecnologias-usadas)
* [Contribuição](#contribuição)
* [Autores](#autores)
* [Licença](#licença)
* [Agradecimentos](#agradecimentos)


# Requisitos Funcionais 

- [x] Aplicação em rede isolada na AWS
- [x] Criação da rede utilizando Terraform
- [x] Criação de AMI para servidores do cluster Kubernets utilizando pipeline Jenkins
- [x] Subir o cluster Multi Master
- [x] Subir o banco de dados MySQL e realizar o dump de um database inicial
- [x] Subir a aplicação Java
- [x] Subir um NGINX para direcionar aos ambientes: DEV, STAGE e PROD

# Tecnologias Usadas

- Shell Script
- Terraform
- Ansible
- NGINX
- Kubernetes
- JAVA
- MYSQL
- JENKINS

# Contribuição

Aprendizado dos colaboradores da DOTI para ferramentas de provisionamento de infraestrutura

# Autores

- Layane Viana Brito
- Julia Cechinato
- Jose Roberto Montanhez Junior
- Jhonatan Alessandro Bosso
- Julio Rodrigo de Almeida Filho

# Licença

Esse projeto foi criado utilizando conta AWS sandbox provida pelo Itaú Unibanco.

# Agradecimentos

Agradecemos a Gama e ao Itaú por nos propiciarem esse treinamento e as nossas familias pelo apoio nas 3 semanas de estudos.