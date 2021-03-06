function [est_cam,camino,mlsd_data] = act_mat(est,sal_pos,matriz_est_int,matriz_sal_int,pos,n_est)

% Look at the state matrix in reference to the paths followed and analyze
% which paths have the states generated by gen_est in the last
% position, then give the two possible paths that can lead you to that
% state.

est_cam = zeros(1,128);
camino = zeros(1,128);
i = 1;
    for i = 1:4                       %Search in matriz_est what path have the last state equal to the est.
        
        if matriz_est_int(i,pos-1) == est
                       
            est_cam = matriz_est_int(i,:);          %Save this path in one vector 
            camino = matriz_sal_int(i,:);           %Save too the output path
            camino(pos) = sal_pos;
            mlsd_data = (i);
            
            if n_est == 1
            est_cam(pos)= -0.71 +0.71i; 
            end
            if n_est == 2
            est_cam(pos)= -0.71 -0.71i; 
            end
            if n_est == 3
            est_cam(pos) = +0.71 +0.71i; 
            end
            if n_est == 4 
            est_cam(pos)= +0.71 -0.71i; 
            end
            
        end        
    end
end