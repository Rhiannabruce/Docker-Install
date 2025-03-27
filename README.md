# Docker-Install
Docker Containers installation on Ubuntu VM deployed with ansible

# Disable CSRF in Jenkins so Jobs can be triggered Manage Jenkins>Scritpt Console
import jenkins.model.Jenkins
def instance = Jenkins.instance
instance.setCrumbIssuer(null)

# RUN THIS IN DEV TOOLS SO IT CAN EXRACT FROM MESSAGE

PUT jenkins-tcp-logs-*/_mapping
{
  "properties": {
    "message": {
      "type": "text",
      "fielddata": true
    }
  }
}


# pipeline_duration_sec_extracted_value  - number
painless
CopyEdit
for (def line : params._source['message']) {
  if (line.contains('pipeline_duration_sec')) {
    def m = /"pipeline_duration_sec":\s*(\d+)/.matcher(line);
    if (m.find()) {
      return Integer.parseInt(m.group(1));
    }
  }
}
return null;


# lead_time_sec_extracted_value  - number
painless
CopyEdit
for (def line : params._source['message']) {
  if (line.contains('lead_time_sec')) {
    def m = /"lead_time_sec":\s*(\d+)/.matcher(line);
    if (m.find()) {
      return Integer.parseInt(m.group(1));
    }
  }
}
return null;


# mttr_sec_extracted_value  - number
painless
CopyEdit
for (def line : params._source['message']) {
  if (line.contains('mttr_sec')) {
    def m = /"mttr_sec":\s*(\d+)/.matcher(line);
    if (m.find()) {
      return Integer.parseInt(m.group(1));
    }
  }
}
return null;


# job_status_extracted_value  - string

for (def line : params._source['message']) {
  if (line.contains('"status"')) {
    def m = /"status":\s*"(\w+)"/.matcher(line);
    if (m.find()) {
      return m.group(1);
    }
  }
}
return null;


# Add to Pipeline Script for Log Spike
for i in $(seq 1 100000); do echo "line $i"; done

