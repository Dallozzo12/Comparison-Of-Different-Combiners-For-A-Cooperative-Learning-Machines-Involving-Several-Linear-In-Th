function [e, y, F] = fnct_AF_NLMS(x, d, F)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ON-LINE FUNCTION: NORMALIZED LEAST MEAN SQUARES (NLMS) ADAPTIVE FILTER.

% INPUT PARAMETERS:
%   x: input signal sample at n-th time instant
%   d: desired signal sample at n-th time instant
%   F.w0: impulse response
%   F.M: filter length
%   F.mu: step size
%   F.delta: regularization factor
%   F.xBuff: input buffer vector at time instant n-1 [M,1]
%   F.w: filter vector at time instant n-1 [M,1]
%
% OUTPUT PARAMETERS:
%   e: error signal sample at n-th time instant
%   y: output signal sample at n-th time instant
%   F.w0: impulse response
%   F.M: filter length
%   F.mu: step size
%   F.delta: regularization factor
%   F.xBuff: input buffer vector at time instant n [M,1]
%   F.w: filter vector at time instant n [M,1]
%
%
% REFERENCES: 
%   [1] A. Uncini, "Elaborazione Adattativa dei Segnali", Aracne Editrice,
%       ISBN: 978:88-548-3142-I, 2010.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%----------Update input signal buffer-----------------------------------------------%
if length(x) == 1
    F.xBuff(2:F.M) = F.xBuff(1:F.M-1);                                              % Shift temporary input signal buffer down
    F.xBuff(1) = x;                                                                 % Assign current input signal sample
elseif length(x) == F.M
    F.xBuff = x;                                                                    % Assign current input signal samples
else
    error('Input buffer length error!')
end
normX = F.xBuff'*F.xBuff + F.delta;                                                 % Update the input signal vector norm

%----------Compute output and residual signals--------------------------------------%
y = F.xBuff'*F.w;                                                                   % Compute and assign the current residual signal sample
e = d - y;                                                                          % Compute and assign the current error signal sample
    
%----------Compute filter coefficients update---------------------------------------%
F.w = F.w + F.mu/normX*e*F.xBuff;                                                   % Update the filter coefficient vector