URL="http://www.malwaredomainlist.com/hostslist/ip.txt"
URL2="http://www.malwaredomainlist.com/mdlcsv.php"
#check for wget
if ![-x "$(command -v wget)"]; then
        echo 'Error: wget is not installed.'>&2
        exit 1
fi

#download domain list
domainlist(){
        wget -O ip1.list $1
        wget -O ip2.list $2
        fileholder='mdl.holder'
        fileholder2='mdl2.holder'
        filefinish='mdl.list'
        sed -e "s/\r//g" ip1.list  > $fileholder
        grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' ip2.list > $fileholder2
        cat $fileholder >> $filefinish
        cat $fileholder2 >> $filefinish
	sort -n mdl.list | uniq -c | sort -n | awk '{ $1=$1; $2=$2; print $2, $RANDOM%1+1, $1 }' | awk '$3>127{$3=127}3' | sed -e "s/ /,/g" | sed '/127.0.0.1/d' > $fileholder
	cat $fileholder > $filefinish

}
domainlist $URL $URL2



