#!\bin\bash

input=$1
if [ -z $input ]
  then
  echo this file does not exist
  grep -o '([0-9]\{3\})[0-9]\{3\}-[0-9]\{4\}\|[0-9]\{10\}' data.txt > phone_data.txt
else
  grep -o '([0-9]\{3\})[0-9]\{3\}-[0-9]\{4\}\|[0-9]\{10\}' $input> phone_$input
fi





