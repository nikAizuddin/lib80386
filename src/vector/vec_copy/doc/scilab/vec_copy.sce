//       1         2         3         4         5         6         7
//34567890123456789012345678901234567890123456789012345678901234567890
//////////////////////////////////////////////////////////////////////
//
// Title: Copy a vector (either row vector or column vector)
//        from a matrix.
//
//--------------------------------------------------------------------
//       Author: Nik Mohamad Aizuddin bin Nik Azmi
// Date Created: 09-APR-2015
//--------------------------------------------------------------------
//
//                  MIT Licensed. See LICENSE file
//
//////////////////////////////////////////////////////////////////////

function[] = vec_copy()

    // Source matrix
    A = [1 2 3
         4 5 6
         7 8 9];

    // Destination matrix
    B = [0 0 0
         0 0 0
         0 0 0];

    B(:,2) = A(:,3);

    disp("A =");disp(A);
    disp("B =");disp(B);

endfunction