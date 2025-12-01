%% Compute the dsp of a signal
%  Inputs
%       x           : Input signal
%       Fe          : Sampling frequency of x and y
%       N           : Number of points to compute the fft.
%                     N=[] -> N = length(x)
%  Outputs
%       f           : frequency vector.
%       xfm         : TFD module
%       dsp_db      : dsp in db
% -------------------------------------------------------------------------

function [f,xfm,dsp_db] = MyDSPEstimation(x,Fe,N)

if isempty(N) || N<length(x)
    N = length(x);
end
xf      = fft(x, N);      % fft
xfm     = abs(xf);        % Module
dsp_db  = 10*log10(xfm.^2);        % dsp
 
f       = (0 : N-1) * (Fe / N);        % frequency vector


