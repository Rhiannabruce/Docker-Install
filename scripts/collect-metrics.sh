# #!/bin/bash

# echo "Collecting system metrics..."

# # Get CPU and Memory usage
# CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
# MEMORY_USAGE=$(free -m | awk 'NR==2{printf "%.2f", $3*100/$2 }')

# # Get Jenkins pipeline execution time
# PIPELINE_TIME=$(curl -s http://jenkins:8080/job/Test_pipeline/lastBuild/api/json | jq '.duration')

# # Get log ingestion rate from ELK (adjust as per your ELK setup)
# LOG_RATE=$(curl -s -XGET "http://elasticsearch:9200/_cat/indices?v" | grep "jenkins-metrics" | awk '{print $4}')

# # Send metrics to Elasticsearch
# curl -X POST "$ELASTICSEARCH_URL/jenkins-metrics/_doc" -H "Content-Type: application/json" -d '{
#     "pipeline_execution_time": "'"$PIPELINE_TIME"'",
#     "cpu_usage": "'"$CPU_USAGE"'",
#     "memory_usage": "'"$MEMORY_USAGE"'",
#     "log_ingestion_rate": "'"$LOG_RATE"'",
#     "timestamp": "'"$(date -u +%Y-%m-%dT%H:%M:%SZ)"'"
# }'

# echo "Metrics collected successfully!"

#!/bin/bash

echo "Collecting system metrics..."

# Define URLs
LOGSTASH_URL="http://logstash:5044"  # Adjust if using Elasticsearch directly
ELASTICSEARCH_URL="http://elasticsearch:9200"

# Get CPU and Memory usage
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
MEMORY_USAGE=$(free -m | awk 'NR==2{printf "%.2f", $3*100/$2 }')

# Get Jenkins pipeline execution time (in seconds)
PIPELINE_TIME=$(curl -s http://jenkins:8080/job/Test_pipeline/lastBuild/api/json | jq '.duration / 1000')

# Get Log ingestion rate (logs/sec)
LOG_RATE=$(curl -s -XGET "$ELASTICSEARCH_URL/_cat/indices?v" | grep "jenkins-metrics" | awk '{print $4}')

# Get Query response time from Elasticsearch
QUERY_TIME=$(curl -s -w "%{time_total}\n" -o /dev/null "$ELASTICSEARCH_URL/_search")

# Fetch Deployment Frequency (builds per day)
DEPLOYMENT_FREQUENCY=$(curl -s "http://jenkins:8080/job/Test_pipeline/api/json" | jq '[.builds[].timestamp] | map(. / 1000 | strftime("%Y-%m-%d")) | unique | length')

# Calculate Lead Time for Changes (time from commit to deployment)
LATEST_COMMIT_TIME=$(curl -s "http://jenkins:8080/job/Test_pipeline/lastBuild/api/json" | jq '.changeSet.items[0].timestamp / 1000')
LEAD_TIME=$(( $(date +%s) - $LATEST_COMMIT_TIME ))

# Calculate Change Failure Rate (failed builds / total builds)
TOTAL_BUILDS=$(curl -s "http://jenkins:8080/job/Test_pipeline/api/json" | jq '.builds | length')
FAILED_BUILDS=$(curl -s "http://jenkins:8080/job/Test_pipeline/api/json" | jq '[.builds[].result] | map(select(. == "FAILURE")) | length')
CHANGE_FAILURE_RATE=$(awk "BEGIN {print ($FAILED_BUILDS / $TOTAL_BUILDS) * 100}")

# Calculate Mean Time to Recovery (MTTR)
LAST_FAILURE=$(curl -s "http://jenkins:8080/job/Test_pipeline/api/json" | jq '[.builds[] | select(.result=="FAILURE")][0].timestamp / 1000')
LAST_SUCCESS=$(curl -s "http://jenkins:8080/job/Test_pipeline/api/json" | jq '[.builds[] | select(.result=="SUCCESS")][0].timestamp / 1000')
MTTR=$((LAST_SUCCESS - LAST_FAILURE))

# Send metrics to Logstash (recommended) or Elasticsearch
curl -X POST "$LOGSTASH_URL" -H "Content-Type: application/json" -d '{
    "deployment_frequency": "'"$DEPLOYMENT_FREQUENCY"'",
    "lead_time_for_changes": "'"$LEAD_TIME"'",
    "change_failure_rate": "'"$CHANGE_FAILURE_RATE"'",
    "mttr": "'"$MTTR"'",
    "log_ingestion_rate": "'"$LOG_RATE"'",
    "query_response_time": "'"$QUERY_TIME"'",
    "pipeline_execution_time": "'"$PIPELINE_TIME"'",
    "cpu_usage": "'"$CPU_USAGE"'",
    "memory_usage": "'"$MEMORY_USAGE"'",
    "timestamp": "'"$(date -u +%Y-%m-%dT%H:%M:%SZ)"'"
}'

echo "Metrics collected successfully and sent to Logstash!"
