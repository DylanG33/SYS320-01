#!/bin/bash

# Convert report.txt to HTML and move to web directory
input="report.txt"
output="report.html"

# Write HTML headers
cat << EOF > "$output"
<html>
<head><title>IOC Access Report</title></head>
<body>
<table border="1">
<tr><th>IP</th><th>Date/Time</th><th>Page Accessed</th></tr>
EOF

# Add table rows from report.txt
while IFS= read -r line; do
    ip=$(awk '{print $1}' <<< "$line")
    datetime=$(awk '{print $2}' <<< "$line")
    url=$(awk '{for(i=3;i<=NF;i++) printf $i " "; print ""}' <<< "$line" | sed 's/ $//')
    echo "<tr><td>$ip</td><td>$datetime</td><td>$url</td></tr>"
done < "$input" >> "$output"

# Close HTML tags
cat << EOF >> "$output"
</table>
</body>
</html>
EOF

# Move to web
sudo mv "$output" /var/www/html/
