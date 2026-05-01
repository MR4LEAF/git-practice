

N = 256; % Example size

A = dctmtx(N);

random_index= randperm(N,20);

PhiT= A(random_index,:);

Phi= PhiT';

PhiPhiT= PhiT*Phi;

imagesc(PhiPhiT)

