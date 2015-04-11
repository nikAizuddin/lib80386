##       1         2         3         4         5         6         7
##34567890123456789012345678901234567890123456789012345678901234567890
######################################################################
## This is a debugscript for automated debugging the program.
##
## Author: Nik Mohamad Aizuddin bin Nik Azmi
##   Date: 10-APR-2015
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
