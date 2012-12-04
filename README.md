record2ei
=========

Generates erl_interface code to decode erlang record based on their spec

Look at test/record01.erl, test/record01.c and test/main.c


There is record refined in test/record01.erl. When you run 

    ./record2ei.erl test/record01.erl c_src/ 

new files are generated: c_src/record01_ei.h and c_src/record01_ei.c

They contain routines read_record01 and write_record01 that pack an unpack External Term Format into C structures.

Generator is very, very limited and will help you in a small number of cases, yet it helps me.


Don't forget:

    make test
