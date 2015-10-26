#! /bin/bash

config=$1
output=$config.json  
prevSlot=0
primed=false

if [ -f $config ]
then
   while read line
   do
      # spin until serial is found
      while [ "$systemSerial" == "" -a "$line" != "" ]
      do
         systemSerial=`echo $line | grep "System Serial Number" | cut -d':' -f2 | cut -d'(' -f1`
         read line
      done
   
      # find the model number
      while [ "$model" == "" -a "$line" != "" ]
      do
         model=`echo $line | grep -e 'FAS[0-9][0-9][0-9][0-9]' | cut -d':' -f2`
         read line
      done
      echo "{\"system\":[{\"serialnumber\":\"$systemSerial\", \"model\":\"$model\"" > $output

      # loop through the PCI cards by Slot
      while read line 
      do
         slot=`echo $line | grep "slot"`
         if $primed
         then
            slot=$slotNew
         fi

         if [ "$slot" != "" ]
         then
            # get the port and slot number for this card
            port=`echo $slot | awk '{print $6}' | grep -e '[0-9][a-z]'`
            slotNumber=`echo $slot | awk '{print $2}' | cut -d':' -f1`

            # check if this is a new slot number and only add it if it's new
            if [ $slotNumber -ne $prevSlot ]
            then
               echo "},{\"slot\":\"$slot\"" >> $output
               prevSlot=$slotNumber
            fi
           
            # ignore slot 0
            if [ $slotNumber -ne 0 ]
            then
               count=0
               counting=true

               # count the number of HDD's
               while $counting
               do
                 read line 
                 slotNew=`echo $line | grep "slot"`

                 # we have moved n the the next slot
                 if [ "$slotNew" != "" -o "$line" == "" ] 
                 then
                    if [ $count -ne 0 ]
                    then
                       echo "     ,\"port\":\"$port\", \"hddcount\":\"$count\"" >> $output
                    fi
                    counting=false
                    primed=true

                 # look for a HDD and count it
                 else
                    HDD=`echo $line | grep NETAPP`
                    if [ "$HDD" != "" ]
                    then
                       count=$(( $count + 1 ))
                    fi
                 fi
               done
            fi
         fi
      done
   done <$config
echo "}]}" >> $output
fi

