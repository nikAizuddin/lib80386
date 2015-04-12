//       1         2         3         4         5         6         7
//34567890123456789012345678901234567890123456789012345678901234567890
//////////////////////////////////////////////////////////////////////
//
// Title: Convert value to absolute value of a vector
//
//--------------------------------------------------------------------
//       Author: Nik Mohamad Aizuddin bin Nik Azmi
// Date Created: 11-APR-2015
//--------------------------------------------------------------------
//
//                  MIT Licensed. See LICENSE file
//
//////////////////////////////////////////////////////////////////////

function[] = vec_absolute_value()

    // Column vector A
    A = [-32.4012  90.3214 -84.1235  90.3213 -52.2014
         -42.1234 -49.1230 -95.2314  42.2391  69.2405
          85.5213  64.2356 -33.1456 -63.3524  64.3777];

    B = abs(A(:,2));
    disp("B = ");disp(B);

    C = abs(A(2,:));
    disp("C = ");disp(C);

endfunction