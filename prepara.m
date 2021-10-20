function [matriz_sal_int,matriz_est_int,mlsd] = prepara(matriz_sal_int,matriz_est_int,mlsd,HL_est,fft_out)

%The Viterbi decoding start when you reach the 4 possible state, this
%function prepare the 3 initial state and the 3 initial output for the 4
%possible path. 

    for i=1:4
        matriz_est_int(i,1)= -0.71 +0.7i;
    end
    
    matriz_est_int(1,2) = -0.71 +0.71i;
    matriz_est_int(3,2) = -0.71 +0.71i;
    matriz_est_int(2,2) = +0.71 +0.71i;
    matriz_est_int(4,2) = +0.71 +0.71i;
    
    matriz_est_int(1,3) = -0.71 +0.71i;
    matriz_est_int(2,3) = -0.71 -0.71i;
    matriz_est_int(3,3) = +0.71 +0.71i;
    matriz_est_int(4,3) = +0.71 -0.71i;

    matriz_sal_int(1,1) = -0.71 +0.71i;
    matriz_sal_int(2,1) = -0.71 +0.71i;
    matriz_sal_int(3,1) = -0.71 +0.71i;
    matriz_sal_int(4,1) = -0.71 +0.71i;
    
    matriz_sal_int(1,2) = -0.71 +0.71i;
    matriz_sal_int(2,2) = +0.71 -0.71i;
    matriz_sal_int(3,2) = -0.71 +0.71i;
    matriz_sal_int(4,2) = +0.71 -0.71i;
    
    matriz_sal_int(1,3) = -0.71 +0.71i;
    matriz_sal_int(2,3) = +0.71 -0.71i;
    matriz_sal_int(3,3) = +0.71 -0.71i;
    matriz_sal_int(4,3) = -0.71 +0.71i;
    
        
    for i=1:4
        for j=1:3
            cn__1 = matriz_sal_int(i,j)*HL_est(j);
            aux = (abs(fft_out(j)-cn__1)^2);
            mlsd(i) = mlsd(i) + aux;
        end 
    end   
end

