#!/bin/bash

# Initialize variables
OFFSET=0
LIMIT=50
URL="https://ic-api.internetcomputer.org/api/v3/neurons"
MASTER_FILE="master_data.json"
TEMP_FILE="temp_data.json"

# Initialize master file with an empty array
echo '[]' > "$MASTER_FILE"

while true; do
    # Fetch data from API
    curl -s -X 'GET' \
        "${URL}?limit=${LIMIT}&include_type=gtc&offset=${OFFSET}&sort_by=-created_timestamp_seconds" \
        -H 'accept: application/json' > "$TEMP_FILE"
   
    echo $OFFSET
    # Check if data is empty, if so break the loop
    if [ $(jq '.data | length' "$TEMP_FILE") -eq 0 ]; then
        break
    fi

    # Process the data, remove recent_ballots and append to master file
    jq 'del(.data[].recent_ballots)' "$TEMP_FILE" > "${TEMP_FILE}_processed"
    jq -s '.[0] + .[1].data' "$MASTER_FILE" "${TEMP_FILE}_processed" > "${MASTER_FILE}.tmp" && mv "${MASTER_FILE}.tmp" "$MASTER_FILE"
    
    # Increase the offset for next loop iteration
    OFFSET=$((OFFSET + LIMIT))
done

# Clean up
rm "$TEMP_FILE" "${TEMP_FILE}_processed"

