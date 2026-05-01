clear;clc

AddPath();

% Define the first row
blockSize= 21;

numRowsBlocks= 3;
numColsBlocks= 3;

for i=1:numRowsBlocks
    for j=1:numColsBlocks
        firstRow= rand(1,blockSize);
        firstCol= rand(blockSize,1);
        block= toeplitz(firstCol, firstRow);
        A((i-1)*blockSize+1:i*blockSize, (j-1)*blockSize+1:j*blockSize)= block;
    end
end

isCirculant(A);

isToeplitz(A);

isToeplitzCirculant(A);

isBTTB(A,blockSize);

