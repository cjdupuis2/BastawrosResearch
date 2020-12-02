function [ xy,avgimg ] = clnimg( xy )
%UNTITLED2 Summary of this function goes here
%   clean the 9999 as the mean value of other points
[xpix,ypix]=size(xy);
wsize = 15;% ----kill the point outside 2 std of surrounding of window 15*15
scap=1;% 3 std 

% % ------------------------- substitude 9999 as the mean value of other
% % points
trctimg=fix(xy/100); %ty why use fix
n=0;
isum=0;
for ii=1:xpix
    for jj=1:ypix
        if trctimg(ii,jj)<=4
            n=n+1;
            isum=isum+xy(ii,jj);
        end;
    end;
end;
avgimg=isum/n;

for ii=1:xpix
    for jj=1:ypix
        if trctimg(ii,jj)>4
            xy(ii,jj)=avgimg;
        end;
    end;
end;



% --------------------------kill the point outside 2 std of surrounding
% window


for ii=1: xpix
    for jj=1: ypix
        if ii<(wsize+1)/2 
            a1=1;
        elseif (xpix-ii)<(wsize+1)/2
            a1=xpix-wsize+1;
        else 
            a1=ii-(wsize-1)/2;
        end;
        
        if jj<(wsize+1)/2 
            b1=1;
        elseif (ypix-jj)<(wsize+1)/2
            b1=ypix-wsize+1;
        else 
            b1=jj-(wsize-1)/2;
        end;  
        
      
        w1=xy(a1:a1+wsize-1,b1:b1+wsize-1);
        mwin=mean(w1(:));
        swin=std(w1(:));
        if xy(ii,jj)>mwin+scap*swin || xy(ii,jj)<mwin-scap*swin
            xy(ii,jj)=(sum(w1(:))-xy(ii,jj))/(wsize^2-1);
%             disp(ii);
%             disp(jj);
        end;
    end;
end;

        





% end

