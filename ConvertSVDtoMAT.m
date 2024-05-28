%% Import and save all .svd files as .mat files 
datPathIn = 'data\raw\'; 
datRaw = string(ls(datPathIn)); datRaw(1:2) = []; datRaw = strtrim(datRaw);
NInd = contains(datRaw,'PLA'); datNominal = datRaw(NInd); 

for fNm = datNominal.'

    p = strsplit(fNm,' '); n = regexp(p(2),'\d*','match'); 
    part = strcat('N',n)
    
    % function [x,y,usd] = GetPointData(filename, domainname, channelname, signalname, displayname, point, frame)
    [dat.(part).f, dat.(part).H1, dat.(part).usd] = GetPointData(strcat(datPathIn,fNm),'FFT','Vib & Ref1','H1 Velocity / Voltage','Real & Imag.',0,0);

    saveNm = strcat('data\full\',string(part));
    save(saveNm,'-struct','dat')

    clear p n part dat 

end