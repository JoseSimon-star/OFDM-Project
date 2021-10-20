%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                   %
%     Step 2:Resource Allocation    %
%                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%This code implements the reosurce allocation problem to allocate new
%powers to each subchannel and have the maximum capacity. We first define
%the SNR that is going to be used and we set the power maximum. Then we
%compute the noise (No) and the NCR(Noise to Carrier Ratio) refered to each
%subcarrier. Next we applied the water-filling algorithm for allocate the
%powers and finally we compute the maximum capacity.
%%
clc;
clear all;
close all;
%%
load('CIR.mat');                  % Load the Channel impulse response provided 
N = 128;                          % Number of subcarriers
SNR_dB = 0;                       % SNR en dB
SNR = 10^(SNR_dB/10);             % SNR in linear units
Pe_target = 10^-5;                % Target symbol error probability per subcarrier

%% We aplied the impulse response 

H = fft(h,N);                     % Frequency response
H_abs = (abs(H)).^2;              % Module of frequency response
Pmax = 1;                         % Maximum power sent 
No = Pmax/SNR;                       
NCR = H_abs./No;                  % Noise to Carrier Ratio associated to each subcarrier


%% SNR gap

gap = 1/(3/(((erfcinv(Pe_target/2))^2)*2));     % SNR gap
gap_dB = 10*log10(gap);                         % SNR gab in dB
b1 = 1/2 * log2(1 + NCR);
b = 1/2 * log2(1 + NCR/gap);                    % Bit allocation

%% Waterfilling algorithm

sigma = 1./NCR;                                   % No/H_abs
mu = (Pmax + sum(sigma))/N;                       % Inital water filling level
P = mu-sigma;                                     % Initial power vector

while(isempty( find(P < 0 )) > 0 )               % This loop works while there are powers in the power vector lower to 0
        
        Pot_neg = find(P <= 0);
        Pot_pos = find(P >  0);
        Channel_rem = length(Pot_pos);
        P(Pot_neg) = 0;
        NCR_new = NCR(Pot_pos);
        mu_new = (Pmax + sum(1./NCR_new))/Channel_rem - 1./NCR_new;
        P(Pot_pos) = mu_new;
        
  end

Capacity = (1/2) * sum(log2(1+P.*NCR));           % Capacity formula
    
%% Graphical Observation

% By observing the figures, it is clear that the power like water fills the 
% container which is made by noise to carrier ratio in Y axis

figure();
    clf;
    set(f1,'Color',[1 1 1]);
    bar((P + sigma),1,'r')
    hold on;    
    bar(sigma,1);
    xlabel('subchannel indices');
    ylabel('Noise to Carrier Ratio');
    title('Water filling algorithm')
    legend('amount of power allocated to each subchannel',...
           'Noise to Carrier Ratio')
figure(2)
    grid
    bar(b1,1,'g');
    hold on;
    bar(b,1);
    title('b_k for all 128 subchannels');
    xlabel('Subchannels');
    ylabel('b_k');
    legend('bits without SNR gap',...
           'bits with the SNR gap')

