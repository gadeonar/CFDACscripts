%% CFDAC_script.m


%% Import data and compute autoCFDAC matrix 
% Establish folder, parameters, reference part
points = [1:2:41, 44:2:92, 95, 97 98 101 102 105 106 109 110 113 114 116, 119:2:141, 142 146 150, 154:2:188];
fVec = [2.5:2.5:10000]; 
 
datPathIn = 'data\raw\'; 
datRaw = string(ls(datPathIn)); datRaw(1:2) = []; datRaw = strtrim(datRaw);
NInd = contains(datRaw,'PLA'); datNominal = datRaw(NInd); 
RefPartNo = '28'; datRef = datNominal(contains(datNominal,RefPartNo)); 
datPartsRaw = datNominal(~contains(datNominal,RefPartNo)); % All .svd files in 'data\raw' that are PLA##, except PLA28

defPartsRaw = datRaw(contains(datRaw,'C')); % .svd files in 'data\raw' that contain 'C' (defect parts)

RefPart = importdata('data\processed\parts\N28.mat'); 

%%  Reference part
tic
part = strcat('N',RefPartNo);

    % function [x,y,usd] = GetPointData(filename, domainname, channelname, signalname, displayname, point, frame)
    [freq,FRF,info] = GetPointData(strcat(datPathIn,datRef),'FFT','Vib & Ref1','H1 Velocity / Voltage','Real & Imag.',0,0);
    ind = interp1(freq,1:length(freq),fVec,'nearest'); 

    % Only keeping a subset of data points: 91 points, 4000 frequency lines
    dat.(part).H1 = zeros(length(points),length(ind)); dat.(part).H1 = FRF(points,ind);   
    dat.(part).f = freq(ind); dat.(part).usd = info;  
     
   N = size(dat.(part).H1,2); dat.(part).autoCFDAC = zeros(N,N); dat.(part).refCFDAC = zeros(N,N);

   for jj = 1:N
        for kk = 1:N

            dat.(part).autoCFDAC(jj,kk) = cMAC(dat.(part).H1(:,jj),dat.(part).H1(:,kk));   

        end % (kk) 
    end % (jj)

    dat.(part).refCFDAC = dat.(part).autoCFDAC; % ONLY for reference part! 

    saveNm = strcat('data\processed\parts\',string(part));
    save(saveNm,'-struct','dat')

elapsedTime_Ref = toc
clear part freq FRF info ind xx dat saveNm N xx jj kk

%% NOMINAL PARTS - Starting with RAW data (.svd files) 
tic
X_Hz = 2500; 
xlFNm_NomAll = 'CFDACMetrics_Nominal-ALL.xlsx';
xlFNm_NomBand = 'CFDACMetrics_Nominal-BAND.xlsx';
M = zeros(30,10); RE = zeros(30,10); IM = zeros(30,10); RowNm = strings(30,1);
DM = zeros(30,10); DRE = zeros(30,10); DIM = zeros(30,10); 

for fNm = datPartsRaw.' % datParts = just Nominal parts

    p = strsplit(fNm,' '); n = regexp(p(2),'\d*','match'); part = strcat('N',n); 
    
    % function [x,y,usd] = GetPointData(filename, domainname, channelname, signalname, displayname, point, frame)
    [freq,FRF,info] = GetPointData(strcat(datPathIn,fNm),'FFT','Vib & Ref1','H1 Velocity / Voltage','Real & Imag.',0,0);

    ind = interp1(freq,1:length(freq),fVec,'nearest'); 

    dat.(part).H1 = zeros(length(points),length(ind)); dat.(part).H1 = FRF(points,ind); 
    dat.(part).f = freq(ind); 
    
    dat.(part).usd = info;  
    clear freq FRF info ind xx

    N = size(dat.(part).H1,2); dat.(part).autoCFDAC = zeros(N,N); dat.(part).refCFDAC = zeros(N,N);

    for jj = 1:N
        for kk = 1:N

            dat.(part).autoCFDAC(jj,kk) = cMAC(dat.(part).H1(:,jj),dat.(part).H1(:,kk));   
            dat.(part).refCFDAC(jj,kk) = cMAC(dat.(part).H1(:,jj),RefPart.H1(:,kk));   

        end % (kk) 
    end % (jj)
 
    ii = str2num(n); % Row of matrices corresponds to part number
    RowNm(ii,1) = part; 
     % ENTIRE MATRIX
            % function [M, RE, IM, MetricNames] = evalComplexDamageIndices(datRef,datAlt,datRefvsAlt)
            % function out = evalDamageIndices(dat1,dat2,dat1v2) 
                % dat1 = FDAC matrix of dat1 v. dat1
                % dat2 = reference part: FDAC matrix of dat2 v. dat2
                % dat1v2 = FDAC matrix of dat1 v. dat2
         [M(ii,:), RE(ii,:), IM(ii,:),VarNms] = evalComplexDamageIndices(RefPart.autoCFDAC,dat.(part).autoCFDAC,dat.(part).refCFDAC);

    % BAND AROUND DIAGONAL
        % function [m, re, im, vnms] = evalComplexMetricsAroundDiagonal(datRef, datAlt,datRefvsAlt,XX)
        % function B = MetricsAroundDiagonal(datRef,datAlt,datRefvAlt,XX)
            % XX = width of band on either side of diagonal in terms of frequency lines
            X = X_Hz/(dat.(part).f(1000)-dat.(part).f(999)); 
       [DM(ii,:), DRE(ii,:), DIM(ii,:), DVarNms] = evalComplexMetricsAroundDiagonal(RefPart.autoCFDAC,dat.(part).autoCFDAC,dat.(part).refCFDAC,X); 
   
    saveNm = strcat('data\processed\parts\',string(part));
    save(saveNm,'-struct','dat')
    
    clear dat part jj kk freq FRF N p saveNm dat 

end % (fNm)

elapsedTime_Nom(ii) = toc 
clear ii 
L = logical(ones(30)); L(28) = 0; % Remove row 28

tM = array2table(round(M(L,:),5),'RowNames',RowNm(L,:),'VariableNames',VarNms); writetable(tM,xlFNm_NomAll,'Sheet','Magnitude','WriteRowNames',true)
tRE = array2table(round(RE(L,:),5),'RowNames',RowNm(L,:),'VariableNames',VarNms); writetable(tRE,xlFNm_NomAll,'Sheet','Real','WriteRowNames',true)
tIM = array2table(round(IM(L,:),5),'RowNames',RowNm(L,:),'VariableNames',VarNms); writetable(tIM,xlFNm_NomAll,'Sheet','Imaginary','WriteRowNames',true)

tDM = array2table(round(DM(L,:),5),'RowNames',RowNm(L,:),'VariableNames',DVarNms); writetable(tDM,xlFNm_NomBand,'Sheet','Magnitude','WriteRowNames',true)
tDRE = array2table(round(DRE(L,:),5),'RowNames',RowNm(L,:),'VariableNames',DVarNms); writetable(tDRE,xlFNm_NomBand,'Sheet','Real','WriteRowNames',true)
tDIM = array2table(round(DIM(L,:),5),'RowNames',RowNm(L,:),'VariableNames',DVarNms); writetable(tDIM,xlFNm_NomBand,'Sheet','Imaginary','WriteRowNames',true)

save('data\Nominal_Metrics.mat','tM','tRE','tIM','tDM','tDRE','tDIM','RowNm')
























