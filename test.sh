if [ "$(/usr/sbin/sysctl -in hw.optional.arm64)" = 1 ] && /usr/sbin/sysctl -n machdep.cpu.brand_string | /usr/bin/grep -q 'Apple' && /usr/bin/uname -v | /usr/bin/grep -q 'ARM64'
    then
        marketModel="$(/usr/libexec/PlistBuddy -c 'print 0:product-name' /dev/stdin <<< "$(/usr/sbin/ioreg -ar -k product-name)")"
    else
    if ! [ -e "$plistsp" ]
    then
        # This is a REALLY stupid way of doing it, but the model name doesn't get filled in unless
        #   'About This Mac' gets opened.
        /usr/bin/open '/System/Library/CoreServices/Applications/About This Mac.app'; /bin/sleep 1
        /usr/bin/pkill -ail 'System Information'; /bin/sleep 1
        /usr/bin/killall cfprefsd; /bin/sleep 1
    fi
    marketModel="$(/usr/libexec/PlistBuddy -c "print 'CPU Names':$srlnmbr-en-US_US" "$plistsp" 2> /dev/null)"
fi

echo "marketModel appears to be \"$marketModel\"..."
echo "changing marketModel to \"Macbook Pro (13-inch, M1, 2024)\"..."
marketModel="Macbook Pro (13inch, M1, 2024)"
echo "marketModel now appears to be \"$marketModel\"..."
echo "Just the year appears to be \"$(echo "$marketModel" | /usr/bin/sed 's/)//;s/(//;s/,//' | /usr/bin/grep -E -o '2[0-9]{3}')\"..."
modelYear="$(echo "$marketModel" | /usr/bin/sed 's/)//;s/(//;s/,//' | /usr/bin/grep -E -o '2[0-9]{3}' | /usr/bin/grep -E -o '\d{2}$' )"
echo "modelYear appears to be \"$modelYear\"..."