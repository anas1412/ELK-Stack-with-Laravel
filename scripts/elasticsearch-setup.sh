#!/bin/bash
# Wait until Elasticsearch is fully ready (can be replaced with a proper wait-for-it or curl check)
until curl -s "http://localhost:9200/_cluster/health?wait_for_status=yellow&timeout=50s" | grep -q '"status":"yellow"'; do
  echo "Waiting for Elasticsearch to be ready..."
  sleep 5
done

# Create the Kibana service account
curl -X POST "localhost:9200/_security/service/kibana-service-account/_create" -H 'Content-Type: application/json' -d'
{
  "metadata": {
    "description": "Kibana service account"
  },
  "roles": ["kibana_system"]
}
'

# Get the token for Kibana service account
token=$(curl -X POST "localhost:9200/_security/service/kibana-service-account/_generate_token" -H 'Content-Type: application/json' -d'
{
  "expires_in": "1d"
}
' | jq -r '.token')

# Save the token to a file
echo "KIBANA_TOKEN=${token}" > /usr/share/elasticsearch/kibana_token.env

# Export the token to make it available to Kibana
export KIBANA_TOKEN=${token}

echo "Kibana service account and token created. The token is: ${KIBANA_TOKEN}"
