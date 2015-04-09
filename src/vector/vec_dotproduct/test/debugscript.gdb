##       1         2         3         4         5         6         7
##34567890123456789012345678901234567890123456789012345678901234567890
######################################################################
## This is a debugscript for automated debugging the program.
##
## Author: Nik Mohamad Aizuddin bin Nik Azmi
##   Date: 09-APR-2015
######################################################################

break b1
break b2
break b3
run

## Print matrix A (3x5)
printf "\nContent of matrix A\n"
set $i = 0
while($i<3)
    set $j = 0
    while($j<5)
        printf "%f ", *((&A)+$i+$j)
        set $j = $j + 1
    end
    printf "\n"
    set $i = $i + 1
end

## Print matrix B (3x5)
printf "\nContent of matrix B\n"
set $i = 0
while($i<3)
    set $j = 0
    while($j<5)
        printf "%f ", *((&B)+$i+$j)
        set $j = $j + 1
    end
    printf "\n"
    set $i = $i + 1
end

## Print result

printf "\n"
printf "C = A[:,0]'*B[:,0]\n"
printf "C = %f\n", *(&C)
continue

printf "\n"
printf "C = A[:,2]'*B[:,4]\n"
printf "C = %f\n", *(&C)
continue

printf "\n"
printf "C = A[2,:]*B[:,3]\n"
printf "C = %f\n", *(&C)
continue
