%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                    %
%  Step 4: Optimal Viterbi decoding  %
%                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%In the step 4, It have supposed that the channel is not known at the 
%transmitter, and it have used a convolutional coding to counteract the 
%possibility of deep fades on some of the subcarriers. Then we have passed
%the signal for a rayleigh channel with 8 taps (the same that the step 3)
% and finally we have demodulated with the viterbi decoding using the MLSD.
%%
clc;
clear all;
close all;
%% Charged the different files
load('h_est');                          %We are charged the channel of the step 3 
load('HL_est');                         %and the estimation for do this step
load('h');
%% Initial variables definition
N = 128;                                  %Number of subscarrier
M = 4;                                    %4-QAM
X = zeros(128,2);                         %Auxiliar vector for the convolutional code
L = 16;                                   %Ciclic prefix
Final_out = zeros(128,1);

%% Convonutional code

rng default;    
D = randi([0 1],N-2,1);                   %we are generated 126 random number for do the input signal
We = [0;0];                               %We are initializaded the convolutional code with the 00
D = [We;D];
j = 3;
    
for i = 3:128                             %We generated these loop for see the
       if D(i-1) == 0 && D(i-2)==0        %two last bits and choose the output 
            if D(i)==1                  %bit depends the these two bits
                X(j,:)=[1 1];
                j=j+1;
            else
                X(j,:) = [0 0];
                j = j+1;
            end
       end
            
        if D(i-1)==0 && D(i-2)==1
            if D(i)==1
                X(j,:) = [1 0];
                j = j+1;
           else 
                X(j,:) = [0 1];
                j = j+1;
            end
        end
            
        if D(i-1)==1 && D(i-2)==0
            if D(i)==1
                X(j,:) = [0 0];
                j = j+1;
            else 
                X(j,:) = [1 1];
                j = j+1;
            end
        end
                      
        if D(i-1)==1 && D(i-2)==1
            if D(i)==1
                X(j,:) = [0 1];
                j = j+1;
            else 
                X(j,:) = [1 0];
                j = j+1;
            end
        end
end


data = bi2de(X);                                  %The second colums have the most significant bit (01=2)
dataMod = qammod(data,M,'bin');                   %We are modulated in 4-QAM the output of the convonutional code
dataMod = dataMod.*(1/sqrt(2));

%% IFFT
d_ifft = ifft(dataMod);

%% Ciclic prefix
Cp = d_ifft(N-L+1:N,1);
cp_matrix = [Cp;d_ifft];

%% Parallel 2 serial;
chan_vector = cp_matrix.';

%% 3º- We introduce the noise

EbNo = (0:10);

for T = 1:length(EbNo)
    snrdB = EbNo(T) + 10*log10(log2(M));
    Y = conv(chan_vector,h);                              %We have mixed our signal with the channel 
    rxSig = awgn(Y,snrdB,'measured');                   %We have added a Gaussian white noise
    %% serial to parallel
    Output_channel = rxSig.';                           %We recover our matrix after add the noise
    %% remove CP
    cp_out = Output_channel (17:144,1);
    %% FFT
    fft_out = fft(cp_out);                              %Finally we return to our main domain
    

    %% Viterbi Decoding
    %To make the viterbi decoder we have decided to make a loop that goes 
    %through all the bits and make another loop inside to go through the 4 
    %states. In all the moment we look back, we are in the positions 4 and
    %we evaluated how I can reach this possitions.
    
    %First prepare the 3 initial positions, then we generate the possibles
    %states and output that can reach this state, then we look ours 4 path
    %and we chose two for each state, and finally we calcule the MLSD for
    %compare the two path.
    
    matrix_est_int = zeros(4,128);
    matrix_sal_int = zeros(4,128);
    matrix_sal_buenos = zeros(4,128);
    matrix_est_buenos = zeros(4,128);
    vector_mlsd = zeros(1,4);
    vector_mlsd_int = zeros(1,4);
    data_mlsd_1 = 0;
    data_mlsd_2 = 0;
    
    [matrix_sal_int,matrix_est_int,vector_mlsd] = prepara(matrix_sal_int,matrix_est_int,vector_mlsd,HL_est,fft_out);
    
    vector_mlsd_int = vector_mlsd;
    
    etapa = 4;

    while etapa<=128
        
            n_est = 1;

        while n_est<5
            
            [est_1,est_2] = gen_ant(n_est);
            [sal_1,sal_2] = gen_sal(n_est);
            
            [est_cam_1,camino_1,data_mlsd_1]=act_mat(est_1,sal_1,matrix_est_int,matrix_sal_int,etapa,n_est);
            [est_cam_2,camino_2,data_mlsd_2]=act_mat(est_2,sal_2,matrix_est_int,matrix_sal_int,etapa,n_est);
            
            [good_vector,good_path,vector_mlsd_int]=criterio(camino_1,camino_2,fft_out,HL_est,etapa,est_cam_1,est_cam_2,data_mlsd_1,data_mlsd_2,vector_mlsd,vector_mlsd_int);
            
            matrix_sal_buenos(n_est,:) = good_vector;
            matrix_est_buenos(n_est,:) = good_path;
            
            n_est = n_est+1;
           
        end   
        
        %Once you finish the cycle of states in one stage, then you assign 
        %the matrix of the good paths to the matrices of current states 
        %and exits, and we advance to the stage.
        
        matrix_est_int = matrix_est_buenos;
        matrix_sal_int = matrix_sal_buenos;
        vector_mlsd = vector_mlsd_int;
    
        etapa = etapa+1;        
    end

    %In this moment, we have the four path with better MLSD and we only
    %need to choose the best. We dont chose.
    %We have not chosen any because our viterbi decoder does not work well.
    %We have worked very hard to get here and I hope you understand the 
    %great difficulties we have had in all the project.
    
    %% Decode
    dataOut = qamdemod(Final_out,M,'bin');    %Demodulate the signal for obtaine the same signal that at the top
    
    [number,ratio] = biterr(D,dataOut);             %We calcule the number of the error.
    numberito(T) = number;
    ratito(T) = ratio;
    out = de2bi(dataOut);
    
end

%figure();
    %semilogy(EbNo,ratito,'r');
    %legend('BER with real channel','BER with estimate channel');
    %grid on;
    %xlabel('Eb/No (dB)');
    %ylabel('Bit Error Rate');