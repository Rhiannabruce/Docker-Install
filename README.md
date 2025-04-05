# Docker-Install
Docker Containers installation on Ubuntu VM deployed with ansible

# Disable CSRF in Jenkins so Jobs can be triggered Manage Jenkins>Scritpt Console
import jenkins.model.Jenkins
def instance = Jenkins.instance
instance.setCrumbIssuer(null)

# Add to Pipeline Script for Log Spike
for i in $(seq 1 100000); do echo "line $i"; done

