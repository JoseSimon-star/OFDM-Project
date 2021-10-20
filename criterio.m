function [Out,est,vector_mlsd_int]=criterio(camino_1,camino_2,fft_out,HL_est,pos,cam_1,cam_2,data_mlsd_1,data_mlsd_2,vector_mlsd,vector_mlsd_int)

% Evaluate the two possible paths FROM where that state can be reached.
% And calculates which path is more likely, this is done with the criteria 
%of the MLSD (Maximum Likelihood Sequence Detection).In this way, we always
%evaluate the path that go to the same place, then we only save one,
%(The most likely).

    com_1 = 0;
    com_2 = 0;
    
    cn__1 = cam_1(pos)*HL_est(pos);         %We multiply for the channel in the same possitions
    cn__2 = cam_2(pos)*HL_est(pos);
        
    aux = (abs(fft_out(pos)-cn__1)^2);      %We calcule the MLSD that this possitions
    aux_2 = (abs(fft_out(pos)-cn__2)^2);
    
    com_1 = vector_mlsd(data_mlsd_1)+aux;   %We add the MLSD that this possitions with the MLSD all the way 
    com_2 = vector_mlsd(data_mlsd_2)+aux_2;

    
    
    if com_1 < com_2                        %We compare the 2 MLSD and we only save one.
        Out = camino_1;
        est = cam_1;
        vector_mlsd_int(data_mlsd_1) = com_1;
    else
       Out = camino_2;
       est = cam_2; 
       vector_mlsd_int(data_mlsd_2) = com_2;

    end
       
end