#! /bin/bash
logFile="/var/log/apache2/access.log.1"
iocFile="ioc.txt"

function displayAllLogs(){
	cat "$logFile"
}

function displayOnlyIPs(){
        cat "$logFile" | cut -d ' ' -f 1 | sort -n | uniq -c
}

function displayOnlyPages(){
	cat "$logFile" | awk -F'"' '{print $2}' | sort | uniq -c | sort -nr
}
# like displayOnlyIPs - but only pages

function histogram(){

	local visitsPerDay=$(cat "$logFile" | cut -d " " -f 4,1 | tr -d '['  | sort \
                              | uniq)
	# This is for debugging, print here to see what it does to continue:
	# echo "$visitsPerDay"

        :> newtemp.txt  # what :> does is in slides
	echo "$visitsPerDay" | while read -r line;
	do
		local withoutHours=$(echo "$line" | cut -d " " -f 2 \
                                     | cut -d ":" -f 1)
		local IP=$(echo "$line" | cut -d  " " -f 1)
          
		local newLine="$IP $withoutHours"
		echo "$IP $withoutHours" >> newtemp.txt
	done 
	cat "newtemp.txt" | sort -n | uniq -c
}

function frequentVisitors(){
	cat "$logFile" | cut -d ' ' -f 1 | sort | uniq -c | sort -nr | awk '$1 > 10 {print $0}'
}
 
# Only display the IPs that have more than 10 visits
# You can either call histogram and process the results,
# Or make a whole new function. Do not forget to separate the 
# number and check with a condition whether it is greater than 10
# the output should be almost identical to histogram
# only with daily number of visits that are greater than 10 

function suspiciousVisitors(){
	grep -v '^$' "$iocFile" | while read -r pattern; do
		awk -v pat="$pattern" '$0 ~ pat {print $1}' "$logFile"
	done | sort | uniq -c | sort -nr | awk '{print $1 " " $2}'
}
# Manually make a list of indicators of attack (ioc.txt)
# filter the records with this indicators of attack
# only display the unique count of IP addresses.  
# Hint: there are examples in slides

# Keep in mind that I have selected long way of doing things to 
# demonstrate loops, functions, etc. If you can do things simpler,
# it is welcomed.

while :
do
	echo "PLease select an option:"
	echo "[1] Display all Logs"
	echo "[2] Display only IPS"
	echo "[3] Display only pages visited"
	echo "[4] Histogram"
	echo "[5] Frequent visitors"
	echo "[6] Suspicious visitors"
	echo "[7] Quit"

	read userInput
	echo ""

	if [[ "$userInput" == "7" ]]; then
		echo "Goodbye"		
		break

	elif [[ "$userInput" == "1" ]]; then
		echo "Displaying all logs:"
		displayAllLogs

	elif [[ "$userInput" == "2" ]]; then
		echo "Displaying only IPS:"
		displayOnlyIPs

	elif [[ "$userInput" == "3" ]]; then
		echo "Displaying only pages visted"
		displayOnlyPages

	elif [[ "$userInput" == "4" ]]; then
		echo "Histogram:"
		histogram

	elif [[ "$userInput" == "5" ]]; then
		echo "Displaying frequent visitors >10"
		frequentVisitors

	elif [[ "$userInput" == "6" ]]; then
		echo "Displaying suspicous visitors"
		suspiciousVisitors

	elif [[ "$userInput" == "*" ]]; then
		echo "Invalid option, try again between 1-7"
	

        # Display frequent visitors
	# Display suspicious visitors
	# Display a message, if an invalid input is given
	fi
done
