if [ "$1" = "" ]; then
    makefile=makefile.txt
else
    makefile="$1"
fi

if [ ! -f "$makefile" ]; then
    echo "Could not find file $makefile."
    exit 0
fi

(cat "$makefile" | sed $"s/\r//") > makefileUnixConvert.txt
echo "" >> makefileUnixConvert.txt

echo "Preparing to build app from relative path..."

echo "Creating app.html..."
echo "" > app.html

echo "Adding header to app.html..."
cat aluminium/header.html >> app.html

echo "Adding raw importers to app.html..."
cat app/res/rawimport.html >> app.html

echo "Adding source header to app.html..."
cat aluminium/sourceheader.html >> app.html

echo "Adding Cobalt to app.html..."
cat aluminium/cobalt.js >> app.html

echo "Adding Alumiuium to app.html..."
cat aluminium/aluminium.js >> app.html

echo "Adding script opener to app.html..."
cat aluminium/script.html >> app.html

echo "Reading $makefile..."

while read a; do
    if [ "$a" != "" ]; then
        if [[ ${a: -3} == ".al" ]]; then
            echo "Adding $a to app.html..."
            
            if [ -f "$a" ]; then
                beforeEscapeSymbols="$(cat $a)"
                escapeSymbolsFirst="${beforeEscapeSymbols/\\\`/\\\\\\\`}"
                escapeSymbolsSecond="${escapeSymbolsFirst/\`/\\\`}"
                echo $escapeSymbolsSecond >> app.html
            else
                echo "Could not find file $a."
            fi
        fi
    fi
done < makefileUnixConvert.txt

echo "End of reading $makefile."

echo "Adding res opener to app.html..."
cat aluminium/res.html >> app.html

echo "Reading $makefile..."

while read a; do
    if [ "$a" != "" ]; then
        if [[ ${a: -3} == ".co" ]]; then
            echo "Adding $a to app.html..."
            
            if [ -f "$a" ]; then
                beforeEscapeSymbols="$(cat $a)"
                escapeSymbolsFirst="${beforeEscapeSymbols/\\\`/\\\\\\\`}"
                escapeSymbolsSecond="${escapeSymbolsFirst/\`/\\\`}"
                echo $escapeSymbolsSecond >> app.html
            else
                echo "Could not find file $a."
            fi
        fi
    fi
done < makefileUnixConvert.txt

echo "End of reading $makefile."

echo "Adding jQuery opener to app.html..."
cat aluminium/jquery.html >> app.html

echo "Adding jQuery to app.html..."
cat aluminium/jquery.js >> app.html

echo "Adding footer to app.html..."
cat aluminium/footer.html >> app.html

echo Deleting temporary files...
rm makefileUnixConvert.txt

echo "Finished building."