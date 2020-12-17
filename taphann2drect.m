function [W]=taphann2drect(M,N,h_r_S,h_r_ul)
%PROGRAM NAME: taphann2d.m
% This code designs a tapered 2-D Hanning window 

Mt =fix(h_r_S*M); %Row taper pixels 10%
m = 1:Mt;
Nt = fix(h_r_ul*N);%Column taper pixels
n = 1:Nt;
W = ones(M,N);
% Taper left and right edges
wr = 0.5*(1+cos(pi*m/Mt)); % taper function
for j = 1:M
    W(j,N-Mt+1:N) = wr.*W(j,N-Mt+1:N);% taper the right part
    W(j,1:Mt) = fliplr(wr).*W(j,1:Mt);% taper the left part
end
% Taper upper and lower edges
wl = 0.5*(1+cos(pi*n'/Nt)); 
for k = 1:N
    W(M-Nt+1:M,k) = wl.*W(M-Nt+1:M,k);
    W(1:Nt,k) = flipud(wl).*W(1:Nt,k);
end


%  contour(W)
%  xlabel('pixel number')
%  ylabel('pixel number')
%  title('2-D 10% Hanning Taper Window')

