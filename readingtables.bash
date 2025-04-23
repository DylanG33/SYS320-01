#!/bin/bash

# URL of the webpage
url="http://10.0.17.6/Assignment.html"

# Fetch the HTML content and extract the tables using simple XPath
temperatureData=$(curl -s "$url" | \
  xmlstarlet select --template \
  --value-of "//html//body//table[@id='temp']//tr/td[1]" -n | tail -n +2)

pressureData=$(curl -s "$url" | \
  xmlstarlet select --template \
  --value-of "//html//body//table[@id='press']//tr/td[1]" -n | tail -n +2)

datetimeData=$(curl -s "$url" | \
  xmlstarlet select --template \
  --value-of "//html//body//table[@id='temp']//tr/td[2]" -n | tail -n +2)

# Determine the number of rows
num_rows=$(echo "$temperatureData" | wc -l)

# Loop through the rows and print the merged data
for i in $(seq 1 "$num_rows"); do
  pressure=$(echo "$pressureData" | head -n "$i" | tail -n 1)
  temperature=$(echo "$temperatureData" | head -n "$i" | tail -n 1)
  datetime=$(echo "$datetimeData" | head -n "$i" | tail -n 1)
  echo "$pressure $temperature $datetime"
done
