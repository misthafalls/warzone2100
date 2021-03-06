#!/bin/sh

# We need to be in the working copy's root directory
cd "`dirname "$0"`/.."

find data -name '*.json' -type f '-!' -path 'data/mp/multiplay/maps/*' -exec \
	grep '"name"\s*:\s*".*"' {} + |
	sed -r 's/.*"name"\s*:\s*"([^"]*)".*/_("\1")/' |
	grep -v -e "\*" -e "NULL" -e "CAM" |
	sort | uniq > po/custom/fromJson.txt

# Add the comment to the top of the file
cat > po/POTFILES.in << EOF
# List of source files which contain translatable strings.
EOF

find lib src data po -type f |
	grep -e '\.c\(pp\|xx\)\?$' -e 'data.*strings.*\.txt$' -e 'data.*sequenceaudio.*\.tx.$' -e '\.slo$' -e '\.rmsg$' -e 'po/custom/.*\.txt' -e '\.js$' |
	grep -v -e '\.lex\.c\(pp\|xx\)\?$' -e '\.tab\.c\(pp\|xx\)\?$' -e 'lib/netplay/miniupnpc/*' -e 'lib/betawidget/*' -e '_moc\.' -e 'po/custom/files.js' |
	grep -v -e '_lexer\.cpp' -e '_parser\.cpp' |
	sort >> po/POTFILES.in
