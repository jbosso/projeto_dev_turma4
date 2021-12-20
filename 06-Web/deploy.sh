#!/bin/bash

# -- Variaveis AWS
uri='ssh -i /var/lib/jenkins/.ssh/id_rsa ubuntu@52.67.249.96'

export TF_VAR_vpcId=$($uri 'aws --region sa-east-1 ec2 describe-vpcs --filters Name=tag:Name,Values=vpc-Team4-JB --query "Vpcs[*].VpcId" --output text')
export TF_VAR_subnetIdPubA=$($uri 'aws --region sa-east-1 ec2 describe-subnets --filters "Name=vpc-id,Values='$TF_VAR_vpcId'" "Name=tag:Name,Values=*Pub_1a" --query "Subnets[*].SubnetId" --output text')
export TF_VAR_keyPrivate='jb-key'

export masterIP0=$($uri 'aws --region sa-east-1 ec2 describe-instances --filters Name=tag:Name,Values=k8s-master0 --query "Reservations[*].Instances[*].[PrivateIpAddress]" --output text')
export masterIP1=$($uri 'aws --region sa-east-1 ec2 describe-instances --filters Name=tag:Name,Values=k8s-master1 --query "Reservations[*].Instances[*].[PrivateIpAddress]" --output text')

echo $TF_VAR_vpcId
echo $TF_VAR_subnetIdPubA
echo $TF_VAR_keyPrivate
echo $masterIP0
echo $masterIP1
# -- 

cd 06-Web/terraform
terraform init
terraform apply -auto-approve

echo "Aguardando criação de maquinas ..."
sleep 10

echo "[ec2-web]" > ../ansible/hosts
echo "$(terraform output | grep private_ip | awk '{print $2;exit}')" | sed -e "s/\",//g" >> ../ansible/hosts

export PublicIP="$(echo "$(terraform output | grep public_ip | awk '{print $2;exit}')" | sed -e "s/\",//g")"
echo $PublicIP

echo "Aguardando criação de maquinas ..."
sleep 10

#
cd ../ansible
#

# -- Criar o apontamento no nginx

cat <<EOF > nginx/load-balancing.conf
upstream dev {
	ip_hash;
	server $masterIP0:30000;
	server $masterIP1:30000;
    }

upstream stag {
	ip_hash;
	server $masterIP0:30001;
	server $masterIP1:30001;
    }
	
upstream prod {
	ip_hash;
	server $masterIP0:30002;
	server $masterIP1:30002;
    }
	
server {
        listen 30000 default_server;
        listen [::]:30000 default_server;
         location / {
                proxy_pass  http://dev;
        }
}

server {
        listen 30001 default_server;
        listen [::]:30001 default_server;
         location / {
                proxy_pass  http://stag;
        }
}

server {
        listen 30002 default_server;
        listen [::]:30002 default_server;
         location / {
                proxy_pass  http://prod;
        }
}

server {
        listen 80 default_server;
        listen [::]:80 default_server;
        root /home/ubuntu/static/;
        index index.html index.htm index.nginx-debian.html;
        server_name _;
        location / {
                try_files \$uri \$uri/ =404;
        }
}
EOF


# -- Criar o arquivo da pagina do HTML
cat <<EOF > static/index.html
<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>Team4</title>

    <!-- Custom fonts for this template-->
    <link href="vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
    <link
        href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i"
        rel="stylesheet">

    <!-- Custom styles for this template-->
    <link href="css/sb-admin-2.min.css" rel="stylesheet">

</head>

<body class="bg-gradient-primary">

    <div class="container">

        <!-- Outer Row -->
        <div class="row justify-content-center">

            <div class="col-xl-10 col-lg-12 col-md-9">

                <div class="card o-hidden border-0 shadow-lg my-5">
                    <div class="card-body p-0">
                        <!-- Nested Row within Card Body -->
                        <div class="row">
                            <div class="col-lg-6 d-none d-lg-block bg-password-image"></div>
                            <div class="col-lg-6">
                                <div class="p-5">
                                    <div class="text-center">
                                        <h1 class="h4 text-gray-900 mb-2">Desafio final Itaú Devops</h1>
                                        <p class="mb-4">DOTI 2.0 - Turma 3 :: Grupo4</p>
                                    </div>
                                    <div class="text-center">
                                        <h1 class="h4 text-gray-900 mb-2">Qual Ambiente deseja Acessar?</h1>
                                        <p class="mb-4">Selecione entre Dev, Stage ou Prod !</p>
                                    </div>
                                    <form class="user">
                                        <div class="form-group">
                                        <a href="http://$PublicIP:30000/login" class="btn btn-primary btn-user btn-block">
                                            Development 
                                        </a>
                                    </form>
									<hr>
                                    <form class="user">
                                        <div class="form-group">
                                        <a href="http://$PublicIP:30001/login" class="btn btn-primary btn-user btn-block">
                                            Stage
                                        </a>
                                    </form>
									<hr>
                                    <form class="user">
                                        <div class="form-group">
                                        <a href="http://$PublicIP:30002/login" class="btn btn-primary btn-user btn-block">
                                            Production
                                        </a>
                                    </form>
                                    <hr>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>

        </div>

    </div>

    <!-- Bootstrap core JavaScript-->
    <script src="vendor/jquery/jquery.min.js"></script>
    <script src="vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

    <!-- Core plugin JavaScript-->
    <script src="vendor/jquery-easing/jquery.easing.min.js"></script>

    <!-- Custom scripts for all pages-->
    <script src="js/sb-admin-2.min.js"></script>

</body>

</html>
EOF

echo "Executando ansible ::::: [ ansible-playbook -i hosts provisionar.yml -u ubuntu --private-key /var/lib/jenkins/.ssh/id_rsa ]"
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i hosts provisionar.yml -u ubuntu --private-key /var/lib/jenkins/.ssh/id_rsa