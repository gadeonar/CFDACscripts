function CFDAC_indiv_cmap(f,CFDACmat)
tp = [310 9660]; 

Hb = figure(); clf
Hb.Name = 'Real';
Hb.Position = [387 205 821 719];
    q(1) = pcolor(f,f,abs(real(CFDACmat))); t(1) = text(tp(1),tp(2),'Real Part'); hold on
    plot(f,f,'k-','LineWidth',1.25)

   
Hc = figure(); clf
Hc.Name = 'Imaginary';
Hc.Position = [387+15 205-15 821 719];
    q(2) = pcolor(f,f,abs(imag(CFDACmat))); t(2) = text(tp(1),tp(2),'Imaginary Part'); hold on
    plot(f,f,'k-','LineWidth',1.25)

Hd = figure(); clf
Hd.Name = 'Magnitude';
Hd.Position = [387+30 205-30 821 719];
    q(3) = pcolor(f,f,abs(CFDACmat)); t(3) = text(tp(1),tp(2),'Magnitude'); hold on
    plot(f,f,'k-','LineWidth',1.25)

    set(findobj([Hb,Hc,Hd],'type','axes'),'PlotBoxAspectRatio',[1 1 1],'FontName','Arial','FontSize',14,'CLim',[0 1],'Colormap',jet(20));
    objAx = findobj([Hb.Children,Hc.Children,Hd.Children],'type','axes'); xlabel(objAx,'Frequency (Hz)','FontWeight','Bold'); 
    ylabel(objAx,'Frequency (Hz)','FontWeight','Bold'); 
    set(findobj([Hb.Children,Hc.Children,Hd.Children],'type','surface'),'EdgeColor','None')
    set(t,'FontSize',16,'Color','White')
    
end 