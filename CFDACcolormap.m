function Hb = CFDACcolormap(f,CFDACmat)
% fldNms = string(fieldnames(CFDAC));
tp = [310 9660]; 

% for x = fldNms.'

Hb = figure(); clf
% Hb.Name = strcat('N14 vs.',char(160),string(x));
Hb.Position = [-3821 437 2000 719];
h1 = subaxis(1,3,1,'SpacingHorizontal',0.05); 
    q(1) = pcolor(f,f,abs(real(CFDACmat))); t(1) = text(tp(1),tp(2),'(a) Real Part'); hold on
    plot(f,f,'k-','LineWidth',1.25)

h2 = subaxis(1,3,2)%,'SpacingHorizontal',0.05)%,'p',0); 
    q(2) = pcolor(f,f,abs(imag(CFDACmat)));  t(2) = text(tp(1),tp(2),'(b) Imaginary Part'); hold on
    plot(f,f,'k-','LineWidth',1.25)

h3 = subaxis(1,3,3)%,'SpacingHorizontal',0.025);%,'p',0,'MR',0.025); 
    q(3) = pcolor(f,f,abs(CFDACmat)); colorbar;  t(3) = text(tp(1),tp(2),'(c) Magnitude'); hold on 
    plot(f,f,'k-','LineWidth',1.25)

h1.Position = [0.05    0.1000    0.2500    0.8000];
h2.Position = [0.375   0.1000    0.2500    0.8000];
h3.Position = [0.7    0.1000    0.25    0.8000];
   
    set(findobj(Hb,'type','axes'),'PlotBoxAspectRatio',[1 1 1],'FontName','Arial','FontSize',14,'CLim',[0 1],'Colormap',jet(20));
    objAx = findobj(Hb.Children,'type','axes'); xlabel(objAx,'Frequency (Hz)','FontWeight','Bold'); 
    ylabel(objAx,'Frequency (Hz)','FontWeight','Bold'); 
    set(findobj(Hb.Children,'type','surface'),'EdgeColor','None')
    set(t,'FontSize',16,'Color','White')
    
end 