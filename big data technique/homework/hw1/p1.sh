if ! [ -f data.txt ]
then 
  curl -OL 'https://people.orie.cornell.edu/bdg79/data.txt'
fi

head -5 data.txt > summary.txt
tail -5 data.txt >> summary.txt
