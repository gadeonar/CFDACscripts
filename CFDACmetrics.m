function CFDACmetrics(dPath,ref,cfdac,fileNm)

clear x ii dat fldNms M RE MRE IM MIM VarNms1 VarNms2 Mmat REmat IMmat MREmat MIMmat RefPart PCCmat

RefPart = importdata(strcat(dPath,ref,'.mat'));
fldNms = string(fieldnames(cfdac));

ii = 1;
for x = fldNms.' 
    
    dat = load(strcat(dPath,x,'_23points.mat')); % MODIFY NAMING CONVENTION
    RowNm(ii) = x; 

    [M, RE, MRE, IM, MIM] = evalComplexDamageIndices(RefPart.CFDAC,dat.(x).CFDAC,cfdac.(x));
    Mmat(ii,:) = [M.SumNvN M.AvgValNvN M.SumRefvN M.AvgValRefvN M.DRQ M.invDRQ M.SymQ M.invSymQ M.PCC M.SCI];
    REmat(ii,:) = [RE.SumNvN RE.AvgValNvN RE.SumRefvN RE.AvgValRefvN RE.DRQ RE.invDRQ RE.SymQ RE.invSymQ RE.PCC RE.SCI];
    IMmat(ii,:) = [IM.SumNvN IM.AvgValNvN IM.SumRefvN IM.AvgValRefvN IM.DRQ IM.invDRQ IM.SymQ IM.invSymQ IM.PCC IM.SCI];
    MREmat(ii,:) = [MRE.SumNvN MRE.AvgValNvN MRE.SumRefvN MRE.AvgValRefvN MRE.DRQ MRE.invDRQ MRE.SymQ MRE.invSymQ];
    MIMmat(ii,:) = [MIM.SumNvN MIM.AvgValNvN MIM.SumRefvN MIM.AvgValRefvN MIM.DRQ MIM.invDRQ MIM.SymQ MIM.invSymQ];
    PCCmat(ii,:) = [RE.PCC IM.PCC M.PCC RE.SCI IM.SCI M.SCI];

    clear M RE MRE IM MIM dat
    ii = ii + 1;
   
end 

VarNms1 = ["Sum: N vs. N", "Avg. Value: N vs. N","Sum: Ref. vs. N","Avg. Value: Ref. vs. N","DRQ",...
    "Inverse DRQ","Symmetry Quotient","Inverse Symmetry Quotient","PCC", "SCI"];
VarNms2 = VarNms1(1:length(VarNms1)-2); 
VarNms3 = ["PCC: Real","PCC: Imag.","PCC: Mag.","SCI: Real","SCI: Imag.","SCI: Mag."];

xlFNm = fileNm;

TM = array2table(round(Mmat,5),'RowNames',RowNm','VariableNames',VarNms1); writetable(TM,xlFNm,'Sheet','Magnitude','WriteRowNames',true)
TRE = array2table(round(REmat,5),'RowNames',RowNm','VariableNames',VarNms1); writetable(TRE,xlFNm,'Sheet','Real','WriteRowNames',true)
TMRE = array2table(round(MREmat,5),'RowNames',RowNm','VariableNames',VarNms2); writetable(TMRE,xlFNm,'Sheet','|REAL|','WriteRowNames',true) 
TIM = array2table(round(IMmat,5),'RowNames',RowNm','VariableNames',VarNms1); writetable(TIM,xlFNm,'Sheet','Imaginary','WriteRowNames',true)
TMIM = array2table(round(MIMmat,5),'RowNames',RowNm','VariableNames',VarNms2); writetable(TMIM,xlFNm,'Sheet','|IMAGINARY|','WriteRowNames',true)
TPCC = array2table(round(PCCmat,5),'RowNames',RowNm','VariableNames',VarNms3); writetable(TPCC,xlFNm,'Sheet','PCC | SCI','WriteRowNames',true)

clear x ii VarNms1 VarNms2 Mmat REmat IMmat MREmat MIMmat PCCmat 

end % (function)