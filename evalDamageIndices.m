function out = evalDamageIndices(datRef,datAlt,datRefvsAlt)

    % datRef = REFERENCE vs. REFERENCE FDAC/CFDAC matrix
    % datAlt = Altered vs. Altered FDAC/CFDAC matrix
    % datRefvsAlt = FDAC matrix of dat1 v. dat2

   % SumNvN 
        out(1,1) = sum(sum(abs(datRef - datAlt)));
   % AvgValNvN 
        out(1,2) = mean(mean(abs(datRef - datAlt)));

   % SumRefvN 
        out(1,3) = sum(sum(abs(datRef - datRefvsAlt)));
   % AvgValRefvN 
        out(1,4) = mean(mean(abs(datRef - datRefvsAlt)));

   % DRQ 
        out(1,5) = mean(diag(datRefvsAlt));
   % IDRQ 
        out(1,6) = 1 - mean(diag(datRefvsAlt));

    U = sum(triu(datRefvsAlt,1)); 
    L = sum(tril(datRefvsAlt,-1)); 
        
   % SymQ 
        out(1,7) = sum(U)/sum(L);
   % invSymQ 
        out(1,8) = abs(1-(sum(U)/sum(L)));

end
