Create flag for top 5  percent members by total cost for every group

  WPS does not support DOSUBL yet

see
https://tinyurl.com/ychv7pnx
https://communities.sas.com/t5/General-SAS-Programming/Need-to-create-flag-for-Top-5-members-by-Total-Cost-for-every/m-p/476052


INPUT
=====

  WORK.HAVE total obs=1,485

       GRP     X

       1     24
       1     38
       1     25
       1      3
       1     44
       1      3
       1      8
       1      8
    ....
      10     38
      10     38
      10     14
      10     14
      10     60
      10     76
      10     67

 EXAMPLE OUTPUT
---------------


 WORK.WANT total obs=1,485

   Group         Sorted           |  RULE
   Count    GRP    X   REC  FLG   |
                                  |
    155     1      0      1   1   |
    155     1      0      2   1   |
    155     1      0      3   1   |
    155     1      0      4   1   |
    155     1      0      5   1   |
    155     1      0      6   1   |
    155     1      0      7   1   |  155/20 = 7.75
                                     5% is first 7
    155     1      0      8   0   |
    155     1      2      9   0   |
    155     1      2     10   0   |
  ...                             |
    155     1     96    152   0   |
    155     1     96    153   0   |
    155     1     97    154   0   |
    155     1     97    155   0   |



PROCESS
========

data want;

  if _n_=0 then do;
     %let rc=%sysfunc(dosubl('
        proc sort data=have out=havSrt noequals;
           by grp x;
        run;quit;
     '));
  end;

  retain cnt 0;

  do until (last.grp);
    set havsrt;
    by grp;
    cnt=cnt+1;
  end;

  do rec=1 by 1 until (last.grp);
    set havsrt;
    by grp;
    if rec <= cnt/20 then flg=1;
    else flg=0;
    output;
  end;

  cnt=0;

run;quit;


OUTPUT
======

 WORK.WANT total obs=1,485

  CNT    GRP     X    REC    FLG

  155     1      0      1     1
  155     1      0      2     1
  155     1      0      3     1
  155     1      0      4     1
  155     1      0      5     1
  155     1      0      6     1
  155     1      0      7     1
  155     1      0      8     0
  155     1      2      9     0
  155     1      2     10     0
  155     1      3     11     0
  155     1      3     12     0
  155     1      3     13     0
  155     1      6     14     0
  155     1      8     15     0
  155     1      8     16     0
  155     1      8     17     0
  155     1      8     18     0
  155     1     10     19     0
  155     1     10     20     0
  155     1     11     21     0
 ....

*                _               _       _
 _ __ ___   __ _| | _____     __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \   / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/  | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|   \__,_|\__,_|\__\__,_|

;

data  have;
   do grp=1 to 10;
     do rec=1 to 100;
       x=int(100*uniform(1234));
       if uniform(5678) > .5 then output;
     output;
     end;
   end;
   drop rec;
run;quit;

*          _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __
/ __|/ _ \| | | | | __| |/ _ \| '_ \
\__ \ (_) | | |_| | |_| | (_) | | | |
|___/\___/|_|\__,_|\__|_|\___/|_| |_|

;

see process;


