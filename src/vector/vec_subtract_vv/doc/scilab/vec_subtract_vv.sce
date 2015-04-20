//       1         2         3         4         5         6         7
//34567890123456789012345678901234567890123456789012345678901234567890
//////////////////////////////////////////////////////////////////////
//
// Title: Subtract vector with a scalar
//
//--------------------------------------------------------------------
//       Author: Nik Mohamad Aizuddin bin Nik Azmi
// Date Created: 11-APR-2015
//--------------------------------------------------------------------
//
//                  MIT Licensed. See LICENSE file
//
//////////////////////////////////////////////////////////////////////

function[] = vec_subtract_vv()

    // Column vector A
    A = [32.4012 90.3214 84.1235 90.3213 52.2014
         42.1234 49.1230 95.2314 42.2391 69.2405
         85.5213 64.2356 33.1456 63.3524 64.3777];

    // Column vector B
    B = [52.1234 97.3125 12.5512 86.3215 92.9642
         12.1524 42.5214 30.1255 42.3215 53.5124
         90.4215 50.2050 53.1246 43.6534 86.9240];

    C = zeros(size(A,'r'),size(A,'c'));

    C(:,2) = A(:,3) - B(:,2);
    disp("C =");disp(C);

endfunction