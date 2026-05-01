function [Params]= setParams()

% reflectance of reference mirror and sample
Params.referenceMirrorReflectance= 1;             % Reflectance of reference mirror
Params.sampleReflectance= 0.3;                      % Reflectance of sample

%  microscope objective
Params.pupilFieldDistribution= 1;                 % scalar field distribution at back focal pupil plane or exit pupil
Params.NA= 0.55;                                   % NA of microscope objective

% Light source
Params.lamMin= 0.2;                              %  minimum wavelengths   unit: μm
Params.lamMax= 0.9;                              %  maximum wavelengths   unit: μm

% scanning 
Params.Nz= 2^10;                                 %  scanning point along optical axis
Params.dz= 0.075;                                 %  scanning interval  unit: μm
Params.sampleHeight= 4*0.075*randn();                       %  sample Height ( relative to the virtual image of reference mirror)
Params.deltaPhi= 0;                              %  parameter that vary with wavenumber

% tolerance for modulus operation
tolerance = 1e-6; 

% Check if sampleHeight is nearly an integer multiple of dz
if abs(mod(Params.sampleHeight, Params.dz)) < tolerance
    warning('sampleHeight is nearly an integer multiple of dz');
end

% spatial coordinate or spatial frequency coordinate

[Params.z]=  FFTOperations.axis_spatial_single(Params.dz,Params.Nz);    
[Params.Kz]= FFTOperations.axis_freq_single(Params.dz,Params.Nz);

% Ensure Params.z, and Params.Kz are all column vectors
Params.z= Params.z(:);
Params.Kz= Params.Kz(:);


 

end
