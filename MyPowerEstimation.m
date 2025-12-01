% Compute the mean power on sliding windows
%  Inputs
%       x    : Input signal
%       Fe   : Sampling frequency of x and y
%       D    : duration for computing the mean power
%  Outputs
%       p    : mean power 
% -------------------------------------------------------------------------

function p = MyPowerEstimation(x,Fe,D)

N = length(x);
K = round((D*Fe -1 )/2);        % Number of samples in a window will be 2K+1

p = zeros(1,N);

for n = 1:N
    kmin = max(1,n-K);
    kmax = min(N,n+K);
    p(n) = mean( x(kmin:kmax).^2 );
end