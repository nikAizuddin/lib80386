##       1         2         3         4         5         6         7
##34567890123456789012345678901234567890123456789012345678901234567890
######################################################################
## This is a debugscript for automated debugging the program.
##
## Author: Nik Mohamad Aizuddin bin Nik Azmi
##   Date: 11-APR-2015
######################################################################

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
######################################################################

break exit
run

printf "\nSample covariance matrix, A = \n"
print_matrix dataMatrix_A 3 3

printf "\neigenvalue =\n"
print_matrix dataMatrix_eigenvalue 1 3

printf "\neigenvector =\n"
print_matrix dataMatrix_eigenvector 3 3

#printf "\ntempMat1 = \n"
#print_matrix dataMatrix_tempMat1 3 3

#printf "\nQ = \n"
#print_matrix dataMatrix_Q 3 3

#printf "\nR = \n"
#print_matrix dataMatrix_R 3 3

#printf "\nu = \n"
#print_matrix dataMatrix_u 3 3

#printf "\ne = \n"
#print_matrix dataMatrix_e 3 3

continue
