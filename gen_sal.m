function [sal_1,sal_2] = gen_sal(n_est)
 
%This function analyses your state and give you the 2 possible output since 
%you can reach this state.For exemple if you are in the 3 possitions 
%(state c) this function give you sal_1 = +0.71 -0.71i; 
%sal_2 = -0.71 -0.71i; the two possible values of the last output path.

a=1;    %a = -0.71 +0.71i; 
b=2;    %b = -0.71 -0.71i;
c=3;    %c = +0.71 +0.71i;
d=4;    %d = +0.71 -0.71i;

if n_est == a
    sal_1 = -0.71 +0.71i;
    sal_2 = +0.71 +0.71i;
end

if n_est == b
    sal_1 = -0.71 -0.71i;
    sal_2 = +0.71 -0.71i;
end

if n_est == c
    sal_1 = +0.71 -0.71i;
    sal_2 = -0.71 -0.71i;
end

if n_est == d
    sal_1 = -0.71 +0.71i;
    sal_2 = +0.71 +0.71i;
end

end