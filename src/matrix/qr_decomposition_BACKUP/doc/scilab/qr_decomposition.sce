//       1         2         3         4         5         6         7
//34567890123456789012345678901234567890123456789012345678901234567890
//////////////////////////////////////////////////////////////////////
//
// Title: Calculate QR Decomposition using Gram-Schmidt Method
//
//--------------------------------------------------------------------
//       Author: Nik Mohamad Aizuddin bin Nik Azmi
// Date Created: 02-APR-2015
//--------------------------------------------------------------------
//
//                  MIT Licensed. See LICENSE file
//
//////////////////////////////////////////////////////////////////////

function[] = qr_decomposition()

    //////////////////////////////////////////////////////////////////
    // Let A = sample matrix
    //////////////////////////////////////////////////////////////////

    A = [4.000  0.021 -7.043 21.898
         0.000  3.000  0.873  3.202
         0.000  0.000  2.000 -3.642
         0.000  0.000  0.000  1.000];


    //////////////////////////////////////////////////////////////////
    // Find Q
    //////////////////////////////////////////////////////////////////
    u(:,1) = A(:,1);
    Q(:,1) = u(:,1) / norm(u(:,1));
    j = 1;
    for i=2:1:size(A,'r')
        u(:,i) = A(:,i);
        for k=1:1:j
            u(:,i) = u(:,i) - (A(:,i)'*Q(:,k)).*Q(:,k);
        end
        Q(:,i) = u(:,i) / norm(u(:,i));
        j = j + 1;
    end


    //////////////////////////////////////////////////////////////////
    // Find R
    //////////////////////////////////////////////////////////////////

    R = zeros(size(A));
    k = 1;
    for i=k:1:size(A,'r')
        for j=k:1:size(A,'c')
            R(i, j) = A(:,j)' * Q(:,i);
        end
        k = k + 1;
    end


    //////////////////////////////////////////////////////////////////
    // Show results
    //////////////////////////////////////////////////////////////////

    disp("u = ");disp(u);
    disp("Q = ");disp(Q);
    disp("R = ");disp(R);

endfunction