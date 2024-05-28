function B = MetricsAroundDiagonal(datRef,datAlt,datRefvAlt,XX)
    % XX = number of sub/super diagonals

    % diffAuto = abs(RefPart.autoCFDAC - dat.(part).autoCFDAC);
    diffAuto = abs(datRef - datAlt);
    % diffRef = abs(RefPart.autoCFDADC - dat.(part).refCFDAC); 
    diffRef = abs(datRef - datRefvAlt);
 
    % Upper matrix
    UAuto = triu(diffAuto,1) - triu(diffAuto,1+XX);
    URef = triu(diffRef,1) - triu(diffRef,1+XX); 
    UnumEl = nnz(UAuto); 

    % Lower matrix
    LAuto = tril(diffAuto,-1) - tril(diffAuto,-1-XX);
    LRef = tril(diffRef,-1) - tril(diffRef,-1-XX);
    LnumEl = nnz(LAuto);

    numEl = UnumEl + LnumEl + length(diag(diffAuto));

    % SumNvN 
        B(1) = sum(sum(UAuto)) + sum(sum(LAuto)) + trace(diffAuto);
    % AvgNvN 
        B(2) = B(1) /numEl;
    % SumRefvN 
        B(3) = sum(sum(URef)) + sum(sum(LRef)) + trace(diffRef);
    % AvgRefvN 
        B(4) = B(3)/numEl;
    % ISQ - datRefvAlt
        Uisq = triu(datRefvAlt,1) - triu(datRefvAlt,1+XX);
        Lisq = tril(datRefvAlt,-1) - tril(datRefvAlt,-1-XX); 
        B(5) = abs(1-(sum(sum(Uisq))/sum(sum(Lisq))));   

end

