%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                    %
%     Step 1: Basic OFDM chain       %
%                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%In this step it has simulated a basic OFDM chain on an ideal AWGN channel, 
%it has generated 300 symbols OFDM and it has passed these symbols for OFDM 
%communication chain. Then, it has computed the bit error rate (BER) and it 
%has computed this for different values of SNR (Signal to Noise Ratio) and 
%finally it has compared our graph of BER VS SNR between the theorical BER.
%%
clear all;
clc;
close all;
%% Initial variables definition

N = 128;                                    %Number of subcarriers
fc = 2*10^9;                                %Carrier frequency 
sub_esp = 15000;                            %Subacarriers spacing
L = 16;                                     %Ciclic prefix
B = N*sub_esp;                              %Wideband
T_simb = 1/sub_esp;                         %Time of 1 symbol
mat_subcarrier = zeros(316,N);              %Subcarriers matrix
subcarrier = (1:N);                         %Subcarriers array
f_subcarrier = (1:N);                       %Subcarriers frenquecy matrix
f_subcarrier(1) = fc-B/2;                           
cp_out = zeros(316,128);                    %Matrix for remove the CP
x = 1;                                      %Auxiliary variable for the loop 
M = 4;                                      %4-QAM
k = log2(M);                                %Number of bits x symbol
sps = 1;                                    %Number of samples per symbol
n = 2*300*N;                                %Number of bits to process 

%% 1º- We modulate the signal
rng default;
dataIn = randi([0 M-1],N,300);              %Generate vector of binary data
dataMod = qammod(dataIn,M,'bin');           %Modulation QAM

figure ()
    plot(dataMod,'r*')
    title('Signal modulated in QAM')
    grid on;

%% 2º- We applied the IFFT and we introduce the CP

    for z = (1:128)
    
        f_subcarrier(1)   = fc - B/2;
        f_subcarrier(z+1) = f_subcarrier(z) + sub_esp;            %We fill the subcarriers frequency matrix 
        f_subcarrier(129) = 0;                                    %with the space between the subcarriers
    end
    
Q = ifft(dataMod);                                                  %Matrix to do correctly the ifft and then

CP_part = Q(end-L+1:end,:);                                         %This is the addition of the Cyclic Prefix.
mat_subcarrier = [CP_part;Q];

channel_vector = reshape(mat_subcarrier,1,[]);                      %We concatenate the results in 1 vector

%% 3º- We introduce the noise

EbNo = (-3:10);
berEst = zeros(size(EbNo));

for T = 1:length(EbNo)
    snrdB = EbNo(T) + 10*log10(k);
    rxSig = awgn(channel_vector,snrdB,'measured');
    
    
    Output_channel = reshape(rxSig,144,300);             %We recover our matrix after add the noise

    cp_out  = Output_channel (17:144,1:300);             %We remove the CP extension
    fft_out = fft(cp_out);                               %Finally we return to our main domain

    dataOut = qamdemod(fft_out,M,'bin');
  

    [number,ratio] = biterr(dataIn,dataOut);             %We compute the BER
    berEst(T) = ratio;

end
%%
berTheory = berawgn(EbNo,'qam',M);                       %We generate the theorical BER

figure ()                                               %We do the graph for compared the two BER
    semilogy(EbNo,berEst,'r')
    hold on
    semilogy(EbNo,berTheory)
    legend('Estimate BER','Theorical BER');
    grid
    xlabel('Eb/No (dB)')
    ylabel('Bit Error Rate')
    xlim([-3,10]);
    title('Step 1: BER vs Estimate BER');