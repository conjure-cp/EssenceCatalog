

function gen1() {
    echo "language Essence 1.3"             >  ${1}-${2}-${3}-${4}.param
    echo ""                                 >> ${1}-${2}-${3}-${4}.param
    echo "letting k be ${1}"                >> ${1}-${2}-${3}-${4}.param
    echo "letting l be ${2}"                >> ${1}-${2}-${3}-${4}.param
    echo "letting num_vertices be ${3}"     >> ${1}-${2}-${3}-${4}.param
}



# k = 2

gen1 02 02 02 UNSAT
gen1 02 02 01 SAT

gen1 02 03 03 UNSAT
for i in $(seq 2 1); do
gen1 02 03 "0${i}" SAT
done;

gen1 02 04 04 UNSAT
for i in $(seq 3 1); do
gen1 02 04 "0${i}" SAT
done;

gen1 02 05 05 UNSAT
for i in $(seq 4 1); do
gen1 02 05 "0${i}" SAT
done;

gen1 02 06 06 UNSAT
for i in $(seq 5 1); do
gen1 02 06 "0${i}" SAT
done;

gen1 02 07 07 UNSAT
for i in $(seq 6 1); do
gen1 02 07 "0${i}" SAT
done;

gen1 02 08 08 UNSAT
for i in $(seq 7 1); do
gen1 02 08 "0${i}" SAT
done;

gen1 02 09 09 UNSAT
for i in $(seq 8 1); do
gen1 02 09 "0${i}" SAT
done

gen1 02 10 10 UNSAT
for i in $(seq 9 1); do
gen1 02 10 "0${i}" SAT
done



# k = 3

gen1 03 03 06 UNSAT
for i in $(seq 5 1); do
gen1 03 03 "0${i}" SAT
done

gen1 03 04 09 UNSAT
for i in $(seq 8 1); do
gen1 03 04 "0${i}" SAT
done

gen1 03 05 14 UNSAT
for i in $(seq -w 13 1); do
gen1 03 05 ${i} SAT
done

gen1 03 06 18 UNSAT
for i in $(seq -w 17 1); do
gen1 03 06 ${i} SAT
done

gen1 03 07 23 UNSAT
for i in $(seq -w 22 1); do
gen1 03 07 ${i} SAT
done

gen1 03 08 28 UNSAT
for i in $(seq -w 27 1); do
gen1 03 08 ${i} SAT
done

gen1 03 09 36 UNSAT
for i in $(seq -w 35 1); do
gen1 03 09 ${i} SAT
done



# k = 4

gen1 04 04 18 UNSAT
for i in $(seq -w 17 1); do
gen1 04 04 ${i} SAT
done

gen1 04 05 25 UNSAT
for i in $(seq -w 24 1); do
gen1 04 05 ${i} SAT
done


