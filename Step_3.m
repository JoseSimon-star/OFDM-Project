%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                   %
%      Step 3:Channel estimation    %
%                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%This code implement an OFDM transmission through a 8-tap Rayleigh channel,which is 
%created below. The code send two pilots (two OFDM symbols) known at the
%receiver so the channel can be estimated by using these pilots. Finally,
%we demodulate the signal and we compute the Mean Square Error (MSE)
%refered to our estimation (LS-Least Square)

%%
clc;
clear all;
close all;
%% Define parameters 
m = 302;              %Numbers of OFDM symbols
N = 128;              %Numbers of subcarriers
M = 4;                %Number of constellatios
E = 1;                %Pilots energy
Ncp = 16;             %Length Ciclix Prefix
L = 8;                %Numbers of the taps of the Rayleigh channel

%% ----------------------------------------------------------------------
%% Define the modulation
    dataMod = randi([0,M-1],N,300);
    Tx = qammod(dataMod,M,'bin');   
    
%% Pilot Insertion
j = 1;
for i = (1:N)
    Ik (1,i) = (-1)^j;
    j = j+1;
end

pilt_data = Ik.';

D_Mod_serial = [pilt_data Tx];

X = [pilt_data D_Mod_serial];               %we insert the pilots at the beginning of the data matrix


%% Specify Pilot & Date Locations
PLoc = 1:2;                                % location of pilots
DLoc = setxor(1:m,PLoc);                   % location of data

%% Inverse discret Fourier transform (IFFT)
%  Amplitude Modulation
d_ifft = ifft(X);                            %Ifft for change the domaind

%% Adding Cyclic Prefix
CP_part = d_ifft(end-Ncp+1:end,:);           % This is the addition of the Cyclic Prefix.
ofdm_cp = [CP_part;d_ifft];
%% Parallel to serial 
ofdm_cp = ofdm_cp.';
%% Generating random channel 

pot_rayos = [-9.7 -9.7 -9.7 -9.7 -9.7 -9.7 -9.7 -9.7];       % Power of each tap   
power = 10.^(pot_rayos/10);                                  % Power in dB
pm = power/sum(power);                                       
pm_n = sqrt(pm);
delay = [0 1 2 3 4 5 6 7];                                   % Uniform delay profil of the 8-taps
length_channel = max(delay+1);
N_rayos = length(delay);
channel = (randn(1,N_rayos)+1i*randn(1,N_rayos))./sqrt(2);   % Rayleigh channel definition
hy = channel.*pm_n;
h(delay+1) = hy;
h = h./norm(h);                                                % Normalize the channel
H = fft(h,N);                                                % Channel frequency response
channel_length = length(h);                                  % True channel and its time-domain length
H_power_dB = 10*log10(abs(H.*conj(H)));                      % True channel power in dB


%% Add noise and the channel
count = 0;
snr_vector = (0:20);
Ber_est = zeros(size(snr_vector));

for snr = 1:length(snr_vector)
    
    SNR = snr_vector(snr) + 10*log10(log2(M));
    count = count+1 ;
    disp(['step: ',num2str(count),' of: ',num2str(length(snr_vector))])
    
    for row = 1:302
    x = ofdm_cp(row,:);                             % OFDM symbol taken 1-by-1
    y = conv(x,h);                                  % Convolution with the channel
    ofdm_noisy = awgn(y,SNR,'measured');              % Add the AWGN
    vector_noisy = ofdm_noisy-y;
    % Remove Cyclic Prefix
    yt = ofdm_noisy(Ncp+1:N+Ncp);                     % Remove the CP and the last 8 numbers that were added by the convolution
    vector_noisy1(row,:) = vector_noisy(Ncp+1:N+Ncp); % Noise vector for compute the MSE
    % Serial to parallel
    yt=yt.';
    % Fft 
    Y(:,row) = fft(yt);
 
    %% Channel estimation
    
    
        if row==1 
            HL_est_1 = Y(:,1)./X(:,1);                 % Channel estimation when the first pilot is received 
            h_est_1=ifft(HL_est_1);
            h_est_1=h_est_1(1:8);
        end
    
        if row==2
            HL_est_2 = Y(:,2)./X(:,2);                 % Channel estimation when the second pilot is received
            h_est_2=ifft(HL_est_2);
            h_est_2=h_est_2(1:8);
        end
    
    
    end
    
        for i=1:128
            var_noisy(i)=var(vector_noisy1(:,i));
            var_x(i)=var(Y(:,i));
            mse_1(i)=var_noisy(i)/var_x(i);           % LS-MSE for each value 
        end
      
      
      mse_final(snr)=sum(mse_1);                      % MSE for each SNR
      
    %% Demapping removing pilots
    Out=Y(:,3:end);
    dataOut=qamdemod(Out,M,'bin'); 
    
    %% Calculating BER
   
    [~,r_LS(count)]=symerr(dataOut,Tx) ;
    h_est=(h_est_1+h_est_2)/2;
    [~,r_Hest(count)]=symerr(h,h_est.');
    [number,ratio]=biterr(dataMod,dataOut);             
    Ber_est(snr)=ratio;
    
end
         
figure()

    semilogy(snr_vector,mse_final);                        % MSE representation with y axis in logaritmic scale
    xlabel('Eb/No (dB)')
    ylabel('Means Square Error (dB)')
    legend('MSE');
    title('Means Square Errror (dB)')
    
figure()

    stem(snr_vector,mse_final,'filled');                    % MSE representation with y axis in linear scale
    xlabel('Eb/No (dB)')
    ylabel('Means Square Error')
    legend('MSE');
    title('Means Square Errror linear scale')
G = fft(h_est,N);                                             % Channel estimate frequency response
H_est_dB = 10*log10(abs(G.*conj(G)));                       % Power in dB
H_est_dB = H_est_dB.';

figure();
    hold on;
    plot(H_power_dB(1:8:end),'+k','LineWidth',3);           % Rayleigh channel power in dB taking 8 by 8 samples 
    plot(H_est_dB(1,(1:8:end)),'or','LineWidth',3);         % Estimate power in dB taking 8 by 8 samples
    title('ACTUAL AND ESTIMATED CHANNELS');
    xlabel('Time in samples');
    ylabel('Magnitude of coefficients');

