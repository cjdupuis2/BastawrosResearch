function [xy] = clnhann(data)

%han filter for ref data.
 h_r_S = 0.1;
 h_r_ul = 0.1;
 [dwx,dwy] = size(data);
 dmw = mean(mean(data));

 xy = data - dmw;
 dW = taphann2drect(dwx,dwy,h_r_S,h_r_ul);
 xy = xy.*dW;
end
