function W_shifted= getFFTmatrix(N)
    W = dftmtx(N);
    P_ifftshift = speye(N);
    P_ifftshift = P_ifftshift(ifftshift(1:N), :);

    P_fftshift = speye(N);
    P_fftshift = P_fftshift(fftshift(1:N), :);

    W_shifted = P_fftshift * W * P_ifftshift;

   
end