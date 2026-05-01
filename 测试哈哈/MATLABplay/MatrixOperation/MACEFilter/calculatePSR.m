function psr = calculatePSR(image)
    % Get the size of the image
    [rows, cols] = size(image);
    
    % Find the index of the maximum intensity
    [~, maxIdx] = max(image(:));
    [peakRow, peakCol] = ind2sub([rows, cols], maxIdx);

    disp(['Max Response: ' num2str(max(image(:)))]);
    disp(['Peak Location: (' num2str(peakRow) ', ' num2str(peakCol) ')']);

    % Define the dimensions of the sidelobe region and the central mask
    sidelobeSize = 20;
    centralMaskSize = 5;
    
    % Calculate the indices for the sidelobe region
    startRow = max(1, peakRow - sidelobeSize/2);
    endRow = min(rows, peakRow + sidelobeSize/2);
    startCol = max(1, peakCol - sidelobeSize/2);
    endCol = min(cols, peakCol + sidelobeSize/2);
    
    % Exclude the central mask
    maskStartRow = max(startRow, peakRow - centralMaskSize/2);
    maskEndRow = min(endRow, peakRow + centralMaskSize/2);
    maskStartCol = max(startCol, peakCol - centralMaskSize/2);
    maskEndCol = min(endCol, peakCol + centralMaskSize/2);
    
    % Calculate the mean and standard deviation of the sidelobe region
    sidelobeRegion = image(startRow:endRow, startCol:endCol);
    mask = false(size(sidelobeRegion));
    mask(maskStartRow-startRow+1:maskEndRow-startRow+1, maskStartCol-startCol+1:maskEndCol-startCol+1) = true;
    sidelobeRegion(mask) = NaN;
    
    % Calculate the mean and standard deviation of the sidelobe region
    sidelobeMean = nanmean(sidelobeRegion(:));
    sidelobeStd = nanstd(sidelobeRegion(:));
    
    % Calculate the PSR
    peakIntensity = image(peakRow, peakCol);
    psr = (peakIntensity - sidelobeMean) / sidelobeStd;
end
