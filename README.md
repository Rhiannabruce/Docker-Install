# Docker-Install
Docker Containers installation on Ubuntu VM deployed with ansible

# Disable CSRF in Jenkins so Jobs can be triggered Manage Jenkins>Scritpt Console
import jenkins.model.Jenkins
def instance = Jenkins.instance
instance.setCrumbIssuer(null)

# Add to Pipeline Script for Log Spike
for i in $(seq 1 100000); do echo "line $i"; done

# Deploy Services to the VM
ansible-playbook -i inventory.ini deploy_elk.yml

# Trigger 30 Consecutive Pipeline Builds
ansible-playbook -i inventory.ini trigger_jenkins.yml

# Simulate Resource Contraint
ansible-playbook -i inventory.ini simulate_cpu_memory.yml

# Simulate Log Spike
ansible-playbook -i inventory.ini simulate_log_spike.yml

# Restore Jenkins Container Resource Capacity
ansible-playbook -i inventory.ini restore_jenkins_resources.yml