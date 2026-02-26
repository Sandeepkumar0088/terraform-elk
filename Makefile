terraform:
	git pull
	terraform init
	terraform apply -auto-approve

ansible-elk:
	git pull
	ansible-playbook -e ansible_user=ec2-user -e ansible_password=DevOps321 elk.yml -i 172.31.90.249,

logstash:
	git pull
	ansible-playbook -e ansible_user=ec2-user -e ansible_password=DevOps321 logstash.yml -i 172.31.90.249,