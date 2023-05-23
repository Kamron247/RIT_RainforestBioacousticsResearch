function [D2] = distcorr(ZI,ZJ)
global Data
distmax = 0.005*Data.spectroinfo.s(1);
[NB_obs,~] = size(ZJ);
ZI = ZI.';
D2 = zeros(NB_obs,1);

main_obj = Data.directory(ZI(1)).obj(ZI(2)).Source{ZI(3)};
for i = 1 : NB_obs
    second_obj = Data.directory(ZJ(i,1)).obj(ZJ(i,2)).Source{ZJ(i,3)};
    if abs(ZI(end-2)-ZJ(i,end-2)) > distmax
        
        D2(i) = 180 ;
    else
        corr=abs(xcorr2(main_obj,second_obj));
        D2(i) = acos(round(max(corr(:))/(norm(main_obj(:))*norm(second_obj(:))),5))*180/pi;
        D2(i) = D2(i);
    end
end
end

