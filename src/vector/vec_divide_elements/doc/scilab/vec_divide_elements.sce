//       1         2         3         4         5         6         7
//34567890123456789012345678901234567890123456789012345678901234567890
//////////////////////////////////////////////////////////////////////
//
// Title: Multiply source vector with a given factor
//
//--------------------------------------------------------------------
//       Author: Nik Mohamad Aizuddin bin Nik Azmi
// Date Created: 09-APR-2015
//--------------------------------------------------------------------
//
//                  MIT Licensed. See LICENSE file
//
//////////////////////////////////////////////////////////////////////

function[] = vec_divide_elements()

    // Column vector A
    A = [32.4012 90.3214 84.1235 90.3213 52.2014
         42.1234 49.1230 95.2314 42.2391 69.2405
         85.5213 64.2356 33.1456 63.3524 64.3777];

    // Column vector B
    B = [52.1234 97.3125 12.5512 86.3215 92.9642
         12.1524 42.5214 30.1255 42.3215 53.5124
         90.4215 50.2050 53.1246 43.6534 86.9240];

    A(:,1) = A(:,1)./B(1,1);
    disp("A =");disp(A);

    A(:,3) = A(:,3)./B(3,5);
    disp("A =");disp(A);

    A(3,:) = A(3,:)./B(2,4);
    disp("A =");disp(A);

endfunction