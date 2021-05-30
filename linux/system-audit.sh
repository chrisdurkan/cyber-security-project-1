#!/bin/bash

# exit if script is not run as root
if [ $UID -ne 0 ]; then
  echo "Please run the script as root."
  exit
fi

# some variables
OUTPUT=$HOME/research/sys_info.txt
IP=$(ip addr | grep inet | tail -2 | head -1)
EXECS=$(sudo find /home -type f -perm 777 2>/dev/null)
CPU=$(lscpu | grep CPU)
DISK=$(df -H | head -2)

# some lists
COMMANDS=(
  'date'
  'uname -a'
  'hostname -s'
)

FILES=(
  '/etc/passwd'
  '/etc/shadow'
)

# look for research directory - create if needed
if [ ! -d $HOME/research ]; then
  mkdir $HOME/research
fi

# look for OUTPUT file - empty it if it exists
if [ -f "$OUTPUT" ]; then
  "" > "$OUTPUT"
fi

# start system audit

echo "A Quick System Audit Script" >> "$OUTPUT"
echo "" >> "$OUTPUT"

for X in {0..2}; do
  RESULTS=$(${COMMANDS[$X]})
  echo "Results of "${COMMANDS[$X]}" command:" >> "$OUTPUT"
  echo "$RESULTS" >> "$OUTPUT"
  echo "" >> "$OUTPUT"
done

# print machine type
echo "Machine Type Info:" >> "$OUTPUT"
echo -e "$MACHTYPE \n" >> "$OUTPUT"

# print IP address info
echo -e "IP Info:" >> "$OUTPUT"
echo -e "$IP \n" >> "$OUTPUT"

# print memory usage
echo -e "\nMemory Info:" >> "$OUTPUT"
free >> "$OUTPUT"

# print CPU usage
echo -e "\nCPU Info:" >> "$OUTPUT"
$CPU >> "$OUTPUT"

# print disk usage
echo -e "\nDisk Usage:" >> "$OUTPUT"
$DISK >> "$OUTPUT"

# list who is logged in
echo -e "\nCurrent user login information: \n $(who -a) \n" >> "$OUTPUT"

# DNS Info
echo "DNS Servers: " >> "$OUTPUT"
cat /etc/resolv.conf >> "$OUTPUT"

# list executable files in /home dir
echo -e "\nexec Files:" >> "$OUTPUT"
for EXEC in $EXECS; do
  echo "$EXEC" >> "$OUTPUT"
done

# print top 10 processes
echo -e "\nTop 10 Processes" >> "$OUTPUT"
ps aux --sort -%mem | awk {'print $1, $2, $3, $4, $11'} | head >> "$OUTPUT"

# check permissions on /etc/shadow and /etc/passwd files
echo -e "\nThe permissions for sensitive /etc files: \n" >> "$OUTPUT"
for FILE in "${FILES[@]}"; do
  ls -l "$FILE" >> "$OUTPUT"
done
