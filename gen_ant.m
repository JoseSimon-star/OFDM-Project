function [est_1,est_2] = gen_ant(est_post)
 
%This function analyses your state and give you the 2 possible state since 
%you can reach this state. For exemple if you are in the 3 possitions 
%(state c) this function give you est_1 = -0.71 +0.71i; 
%est_2 = -0.71 -0.71i; the two possible values of the last state path.

a=1;    %a = -0.71 +0.71i; 
b=2;    %b = -0.71 -0.71i;
c=3;    %c = +0.71 +0.71i;
d=4;    %d = +0.71 -0.71i;

if est_post == a
    est_1 = -0.71 +0.71i;
    est_2 = -0.71 -0.71i;
end

if est_post == b
    est_1 = +0.71 +0.71i;
    est_2 = +0.71 -0.71i;
end

if est_post == c
    est_1 = -0.71 +0.71i;
    est_2 = -0.71 -0.71i;
end

if est_post == d
    est_1 = +0.71 +0.71i;
    est_2 = +0.71 -0.71i;
end

end