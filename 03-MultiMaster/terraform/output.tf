# Outputs

output "k8s-masters" {
  value = [
    for key, item in aws_instance.k8s_masters :
      "k8s-master ${key+1} - ${item.private_ip} - ssh -i /var/lib/jenkins/.ssh/id_rsa ubuntu@${item.private_ip} -o ServerAliveInterval=60"
  ]
}

output "output-k8s_workers" {
  value = [
    for key, item in aws_instance.k8s_workers :
      "k8s-workers ${key+1} - ${item.private_ip} - ssh -i /var/lib/jenkins/.ssh/id_rsa ubuntu@${item.private_ip} -o ServerAliveInterval=60"
  ]
}

output "output-k8s_proxy" {
  value = [
    "k8s_proxy - ${aws_instance.k8s_proxy.private_ip} - ssh -i /var/lib/jenkins/.ssh/id_rsa ubuntu@${aws_instance.k8s_proxy.private_ip} -o ServerAliveInterval=60"
  ]
}

output "security-group-haproxy" {
  value = aws_security_group.acessos_haproxy.id
}

output "security-group-workers" {
  value = aws_security_group.acessos_workers.id
}

output "security-group-masters" {
  value = aws_security_group.acessos_masters.id
}