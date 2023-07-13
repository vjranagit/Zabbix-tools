#!/bin/bash

# Set the MySQL credentials
DB_USER="your_username"
DB_PASS="your_password"
DB_NAME="zabixdb"

# Set the number of days to keep the data
DAYS_TO_KEEP=90

# Construct the SQL queries
QUERY_HISTORY_UINT="DELETE FROM history_uint WHERE clock < UNIX_TIMESTAMP(DATE_SUB(NOW(), INTERVAL $DAYS_TO_KEEP DAY));"
QUERY_HISTORY="DELETE FROM history WHERE clock < UNIX_TIMESTAMP(DATE_SUB(NOW(), INTERVAL $DAYS_TO_KEEP DAY));"
QUERY_TRENDS_UINT="DELETE FROM trends_uint WHERE clock < UNIX_TIMESTAMP(DATE_SUB(NOW(), INTERVAL $DAYS_TO_KEEP DAY));"
QUERY_TRENDS="DELETE FROM trends WHERE clock < UNIX_TIMESTAMP(DATE_SUB(NOW(), INTERVAL $DAYS_TO_KEEP DAY));"
QUERY_EVENTS="DELETE FROM events WHERE clock < UNIX_TIMESTAMP(DATE_SUB(NOW(), INTERVAL $DAYS_TO_KEEP DAY));"
QUERY_ALERTS="DELETE FROM alerts WHERE clock < UNIX_TIMESTAMP(DATE_SUB(NOW(), INTERVAL $DAYS_TO_KEEP DAY));"

# Function to execute a SQL query and track progress
execute_query() {
  local query="$1"
  local query_name="$2"
  echo "Executing $query_name..."
  mysql -u "$DB_USER" -p"$DB_PASS" -D "$DB_NAME" -e "$query"
  local exit_code=$?
  if [ $exit_code -eq 0 ]; then
    echo "$query_name executed successfully."
  else
    echo "Error executing $query_name. Exit code: $exit_code"
  fi
}

# Execute the SQL queries in parallel and track progress
execute_query "$QUERY_HISTORY_UINT" "Query 1" &
pid1=$!
execute_query "$QUERY_HISTORY" "Query 2" &
pid2=$!
execute_query "$QUERY_TRENDS_UINT" "Query 3" &
pid3=$!
execute_query "$QUERY_TRENDS" "Query 4" &
pid4=$!
execute_query "$QUERY_EVENTS" "Query 5" &
pid5=$!
execute_query "$QUERY_ALERTS" "Query 6" &
pid6=$!

# Wait for all background processes to finish and track progress
echo "Waiting for all queries to complete..."
num_finished=0
num_queries=6

while [ $num_finished -lt $num_queries ]; do
  for pid in $pid1 $pid2 $pid3 $pid4 $pid5 $pid6; do
    if ps -p $pid > /dev/null; then
      sleep 1
    else
      wait $pid
      num_finished=$((num_finished + 1))
    fi
  done
  echo "Progress: $num_finished/$num_queries queries completed."
done

echo "All queries completed."
