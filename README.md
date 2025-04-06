
- Commands to run ansible

```sh
ansible-playbook -i inventory.init playbook/init-script.yml

ansible-playbook -i inventory.init playbook/nginx-init.yml

ansible-playbook -i inventory.init playbook/nodejs-init.yml

ansible-playbook -i inventory.init playbook/postgres-16-init.yml

ansible-playbook -i inventory.init playbook/jenkins-init.yml

ansible-playbook -i inventory.init playbook/prometheus-init.yml

ansible-playbook -i inventory.init playbook/grafana-init.yml
```
