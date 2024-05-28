%% CFDAC_script.m


%% Import data and compute autoCFDAC matrix 
% Establish folder, parameters, reference part
% points = [1:2:41, 44:2:92, 95, 97 98 101 102 105 106 109 110 113 114 116, 119:2:141, 142 146 150, 154:2:188];
 datPathIn = 'data\processed\'; 
datAll = string(ls(datPathIn)); datAll(1:2) = []; datAll = strtrim(datAll);
% NInd = contains(datRaw,'PLA'); datNominal = datRaw(NInd); 
RefPartNo = '28'; datRef = datAll(contains(datAll,RefPartNo)); 
% datPartsRaw = datNominal(~contains(datNominal,RefPartNo)); % All .svd files in 'data\raw' that are PLA##, except PLA28
datNominal = datAll(~contains(datAll,RefPartNo))
% defPartsRaw = datRaw(contains(datRaw,'C')); % .svd files in 'data\raw' that contain 'C' (defect parts)

% RefPart = importdata('data\processed\N28.mat'); 
%% 
clear RefPart
df = 15;
fVec = [100:df:25000]; 

%  Reference part
tic
% dat = load(strcat(datPathIn,datRef));
% part = strcat('N',RefPartNo);
RefPart = importdata('data\processed\N28.mat'); 

    ind = interp1(RefPart.f,1:length(RefPart.f),fVec,'nearest'); 
    RefPart.fCFDAC = RefPart.f(ind);  

    N = length(ind); RefPart.autoCFDAC = zeros(N,N); RefPart.refCFDAC = zeros(N,N);
    
   for jj = 1:N
        for kk = 1:N

            RefPart.autoCFDAC(jj,kk) = cMAC(RefPart.H1(:,ind(jj)),RefPart.H1(:,ind(kk)));   

        end % (kk) 
    end % (jj)

    RefPart.refCFDAC = RefPart.autoCFDAC; % ONLY for reference part! 

    % saveNm = strcat('data\processed\',datRef);
    % save(saveNm,'-struct','dat')

elapsedTime_Ref = toc
clear jj kk

% NOMINAL PARTS 
tic
X_Hz = 2500;

fInfo = strcat(string(df),'Hz-df_',string(fVec(1)),'-',string(fVec(end)),'Hz');
    xlFNm_NomAll = strcat('documents\N_All_',fInfo,'_189pts','.xlsx');
    xlFNm_NomBand = strcat('documents\N_',string(X_Hz),'Hz-Band_',fInfo,'_189pts','.xlsx');

M = zeros(30,10); RE = zeros(30,10); IM = zeros(30,10); RowNm = strings(30,1);
DM = zeros(30,5); DRE = zeros(30,5); DIM = zeros(30,5); 

for fNm = datNominal.' % datParts = just Nominal parts

    dat = load(strcat(datPathIn,fNm));
    part = erase(fNm,'.mat')
    n = regexp(part,'\d*','match');
    
    ind = interp1(dat.(part).f,1:length(dat.(part).f),fVec,'nearest'); 
    dat.(part).fCFDAC = dat.(part).f(ind);

    N = length(ind); dat.(part).autoCFDAC = zeros(N,N); dat.(part).refCFDAC = zeros(N,N);
    
    for jj = 1:N
        for kk = 1:N

            dat.(part).autoCFDAC(jj,kk) = cMAC(dat.(part).H1(:,ind(jj)),dat.(part).H1(:,ind(kk)));   
            dat.(part).refCFDAC(jj,kk) = cMAC(dat.(part).H1(:,ind(jj)),RefPart.H1(:,ind(kk)));   
                    % RefPart MUST BE SECOND FUNCTION INPUT/ARGUMENT

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
            % XX = number of sub/super diagonals - should be the same value
            % in Hz, regardless of freq. res. 
            X = round(X_Hz/(dat.(part).fCFDAC(50)-dat.(part).fCFDAC(49))); 
       [DM(ii,:), DRE(ii,:), DIM(ii,:), DVarNms] = evalComplexMetricsAroundDiagonal(RefPart.autoCFDAC,dat.(part).autoCFDAC,dat.(part).refCFDAC,X); 
   
    % saveNm = strcat('data\processed\',string(part));
    % save(saveNm,'-struct','dat')
    
    clear dat part jj kk freq FRF N p saveNm dat ind X

end % (fNm)

elapsedTime_Nom = toc 
 
M(ii+1,:) = mean(M); RE(ii+1,:) = mean(RE); IM(ii+1) = mean(IM);
DM(ii+1,:) = mean(DM); DRE(ii+1,:) = mean(DRE); DIM(ii+1,:) = mean(DIM); 
RowNm(ii+1) = "Mean"; 

L = logical(ones(length(RowNm),1));  L(28) = 0; % Remove row 28

tM = array2table(round(M(L,:),5),'RowNames',RowNm(L,:),'VariableNames',VarNms); writetable(tM,xlFNm_NomAll,'Sheet','Magnitude','WriteRowNames',true)
tRE = array2table(round(RE(L,:),5),'RowNames',RowNm(L,:),'VariableNames',VarNms); writetable(tRE,xlFNm_NomAll,'Sheet','Real','WriteRowNames',true)
tIM = array2table(round(IM(L,:),5),'RowNames',RowNm(L,:),'VariableNames',VarNms); writetable(tIM,xlFNm_NomAll,'Sheet','Imaginary','WriteRowNames',true)

tDM = array2table(round(DM(L,:),5),'RowNames',RowNm(L,:),'VariableNames',DVarNms); writetable(tDM,xlFNm_NomBand,'Sheet','Magnitude','WriteRowNames',true)
tDRE = array2table(round(DRE(L,:),5),'RowNames',RowNm(L,:),'VariableNames',DVarNms); writetable(tDRE,xlFNm_NomBand,'Sheet','Real','WriteRowNames',true)
tDIM = array2table(round(DIM(L,:),5),'RowNames',RowNm(L,:),'VariableNames',DVarNms); writetable(tDIM,xlFNm_NomBand,'Sheet','Imaginary','WriteRowNames',true)

metricsSaveNm = strcat('data\metrics\Nominal_',fInfo,'.mat');
save(metricsSaveNm,'tM','tRE','tIM','tDM','tDRE','tDIM','RowNm');

clear ii























