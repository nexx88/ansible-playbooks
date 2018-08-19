#### Docker Swarm Update

This playbook will upgrade a docker swarm one node at a time. Given a swarm manager it detects all nodes, then drains and upgrades them one at a time. Without any additional arguments it will simply update to the latest available version, however a specific version may be requested by setting the 'docker_version' var on the command line. It won't downgrade nodes.

This will upgrade all nodea in the m2dev swarm to 18.03:

ansible-playbook -i 'dswm01.acme.com,' -e 'docker_version=18.03' playbook.yml

This will upgrade all nodes in the m2dev swarm to the latest:

ansible-playbook -i 'dswm01.acme.com,' playbook.yml
