function [Out,Y] = viterbi(HL_est,N,fft_out)

    Out = zeros (128,1);
    i = 2;
    Y = 0;
    
    est_prox = -0.71 +0.71i;
    
    while (Out(N) == 0)
    
        [cn(1),cn(2)] = gen_est(est_prox);
        
        cn_1 = cn(1)*HL_est(i);
        cn_2 = cn(2)*HL_est(i);
        
        aux = (abs(fft_out(i)-cn_1)^2);
        aux_2 = (abs(fft_out(i)-cn_2)^2);
    
        if aux < aux_2
           Y = Y + aux;
           Out(i) = cn(1);
           est_prox = cn(1);
           
        else
          Y = Y + aux_2;
          Out(i) = cn(2);
          est_prox = cn(2);

        end
    
         i = i+1;
    end
end