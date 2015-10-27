#! /bin/bash

list=$1
for i in `cat $list`
do
   echo `GET http://finance.yahoo.com/webservice/v1/symbols/$i/quote?format=json\&view=detail` > out.json
   
   price=`GET http://finance.yahoo.com/webservice/v1/symbols/$i/quote?format=json\&view=detail | grep price | cut -d'"' -f4`
   change=`GET http://finance.yahoo.com/webservice/v1/symbols/$i/quote?format=json\&view=detail | grep change | cut -d'"' -f4`
   echo "$i  $price  $change"
done
