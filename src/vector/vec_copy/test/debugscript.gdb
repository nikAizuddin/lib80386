##       1         2         3         4         5         6         7
##34567890123456789012345678901234567890123456789012345678901234567890
######################################################################
## This is a debugscript for automated debugging the program.
##
## Author: Nik Mohamad Aizuddin bin Nik Azmi
##   Date: 06-APR-2015
######################################################################

break exit
run

## Print matrix A
printf "\nContent of matrix A\n"
set $i = 0
while($i<81)
    printf "%f %f %f %f %f %f %f %f %f\n", \
        *((&A)+$i+0), *((&A)+$i+1), *((&A)+$i+2), \
        *((&A)+$i+3), *((&A)+$i+4), *((&A)+$i+5), \
        *((&A)+$i+6), *((&A)+$i+7), *((&A)+$i+8)
    set $i = $i + 9
end

## Print matrix B
printf "\nContent of matrix B\n"
set $i = 0
while($i<81)
    printf "%f %f %f %f %f %f %f %f %f\n", \
        *((&B)+$i+0), *((&B)+$i+1), *((&B)+$i+2), \
        *((&B)+$i+3), *((&B)+$i+4), *((&B)+$i+5), \
        *((&B)+$i+6), *((&B)+$i+7), *((&B)+$i+8)
    set $i = $i + 9
end

continue
