%olympusxyzdata Summary of this function goes here
%  This program will Cut the headline off and save matrix as 1024X1024


FileNames = dir('*.csv'); %Specify Base or Tip
Mlen = length(FileNames);

for i = 1:Mlen;
    NameStr{i} = FileNames(i).name;    
end

for ai=1:Mlen
fname=char(NameStr(ai));

xy1=csvread(fname,19,1);
xy1=xy1(1:1024,1:1024);

xy3=zeros(1024,1024);
% Flip all the tip samples, this is due to the image mirror effect
if fname(5)=='T'
for i=1:1024
    xy3(i,:)=xy1(1025-i,:);
end
xy1=xy3;
end
    
% %-----------remove no data, 9999 and average it for 5 times(used for the
% zygo image that has 9999 as no date indication)
counter=0;
% while counter<2
%     xy1=refine_moved(xy1);
%        counter=counter+1;
% end;

[xy1,av11]=clnimg(xy1);%clean the 9999 as the mean value of other points window size 15*15

xlswrite([fname(1:end-4),'.xlsx'],xy1)
 end;
