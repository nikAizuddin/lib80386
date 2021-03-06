##       1         2         3         4         5         6         7
##34567890123456789012345678901234567890123456789012345678901234567890
######################################################################
## This is a debugscript for automated debugging the program.
##
## Author: Nik Mohamad Aizuddin bin Nik Azmi
##   Date: 09-APR-2015
######################################################################

## $arg0 = source matrix
## $arg1 = rows
## $arg2 = columns
define print_matrix
    set $i = 0
    while($i<($arg1*$arg2))
        set $j = 0
        while($j<$arg2)
            printf "%f ", *((&$arg0)+$i+$j)
            set $j = $j + 1
        end
        printf "\n"
        set $i = $i + $arg2
    end
end

break exit
run

## Print matrix A (3x5)
printf "\nContent of matrix A\n"
print_matrix dataMatrix_A 3 5

## Print matrix B (3x5)
printf "\nContent of matrix B\n"
print_matrix dataMatrix_B 3 5
continue
