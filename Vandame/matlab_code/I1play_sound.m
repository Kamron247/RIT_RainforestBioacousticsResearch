for i = 1 : size(sons_moy,1)
 % sound(sons_moy{i}(1:min(end,44100*3))*1000,Data.wavinfo.SampleRate/2);
    audiowrite(['resultat/source' num2str(i) '.wav'],sons_moy{i}/max(sons_moy{i})*0.5,Data.wavinfo.SampleRate);
  % pause()
  % clear sound
  %  disp(i)
end
