//       1         2         3         4         5         6         7
//34567890123456789012345678901234567890123456789012345678901234567890
//////////////////////////////////////////////////////////////////////
//
// Title: Calculate eigenvalue and eigenvector using QR Decomposition.
//
// The purpose of this program, is to calculate the eigenvalues and
// eigenvectors, specifically for Computer Vision (Eigenface).
// So, I can't say my calculations will give 100% correct answer
// for all possible matrices.
//
//--------------------------------------------------------------------
//       Author: Nik Mohamad Aizuddin bin Nik Azmi
// Date Created: 03-APR-2015
//--------------------------------------------------------------------
//
//                  MIT Licensed. See LICENSE file
//
//////////////////////////////////////////////////////////////////////

function[] = eigen()

    //////////////////////////////////////////////////////////////////
    // Let A = sample covariance matrix.
    //////////////////////////////////////////////////////////////////

    A = [ 11.4445 -18.5556   7.1111
         -18.5556  34.4444 -15.8889
           7.1111 -15.8889   8.7778];
    disp("Sample covariance matrix =");disp(A);

    B = A;


    //////////////////////////////////////////////////////////////////
    // Perform 20 iterations of QR Decomposition, to find the
    // eigenvalues and eigenvectors.
    // I think 20 iterations are already good, but you can increase
    // the number of iterations for extra accuracy.
    //////////////////////////////////////////////////////////////////

    [Q,R] = qr_decomposition(B);
    B = Q*R;
    S = Q;

    for i=2:1:20
        B = R*Q;
        [Q,R] = qr_decomposition(B);
        B = Q*R;
        S = S*Q;
    end


    //////////////////////////////////////////////////////////////////
    // Normalize eigenvectors to 1.0, so that the range of the vector
    // is between 0.0 -> 1.0.
    //////////////////////////////////////////////////////////////////

    for i=1:1:size(B,'c')
        S(:,i) = S(:,i)./max(abs(S(:,i)));
    end


    //////////////////////////////////////////////////////////////////
    // Show results
    //////////////////////////////////////////////////////////////////

    disp("Eigenvalues = ");disp(diag(B));
    disp("Eigenvectors = ");disp(S);


endfunction