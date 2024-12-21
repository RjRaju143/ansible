#!/bin/sh

ansible-playbook -i inventory.init playbook/init-script.yml

ansible-playbook -i inventory.init playbook/nginx-init.yml

ansible-playbook -i inventory.init playbook/nodejs-init.yml

ansible-playbook -i inventory.init playbook/postgres-16-init.yml


