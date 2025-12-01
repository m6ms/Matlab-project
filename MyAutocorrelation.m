%% Compute normalized cross-correlation of x and y
%  Inputs
%       x    : Input signal
%       Fe   : Sampling frequency of x and y
%       D    : duration for computing the autocorrelation and max shift
%  Outputs
%       Cxx : autocorrelation - as a function of tx
%       tx  : time vector 
% -------------------------------------------------------------------------
function [Cxx,tx] = MyAutocorrelation(x,Fe,D)

kmax = round(D * Fe);      
Nx   = length(x);

Cxx  = zeros(1,kmax+1);

for k = 0:kmax
    xs = [x(k+1:end)  zeros(1, Nx - (Nx - k))];   
    Cxx(k+1) = sum(x .* xs)*1/Nx;  
end

tx = (0:kmax)/Fe;