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

printf "\nActual results\n"

printf "\nA = \n"
print_matrix dataMatrix_A 5 3

printf "\nB = \n"
print_matrix dataMatrix_B 5 3

printf "\nC = \n"
print_matrix dataVector_C 5 1

printf "\nD = \n"
print_matrix dataMatrix_D 5 3

printf "\nE = \n"
print_matrix dataMatrix_E 5 3

printf "\nF = \n"
print_matrix dataMatrix_F 5 3

continue
