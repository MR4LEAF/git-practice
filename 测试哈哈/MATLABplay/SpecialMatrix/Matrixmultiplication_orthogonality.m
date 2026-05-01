% matrix multiplication & element-wise multiplication

% Define two 2x2 matrices A and B
A = [1 2; 3 4];
B = [5 6; 7 8];

% vector
Av= A(:);
Bv= B(:);

%
Cv=[Av,Bv];

correlation_filter= Cv'*Cv;
Filter_new= Cv*inv(correlation_filter);


XX= Filter_new'*Cv;

imagesc(XX)