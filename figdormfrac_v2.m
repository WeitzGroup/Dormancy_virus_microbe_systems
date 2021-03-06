clf;
clear all
% automatically create postscript whenever
% figure is drawn
set(0,'DefaultTextInterpreter', 'latex')
tmpfilename = 'figdormfrac_v2';
tmpfilebwname = sprintf('%s_noname_bw',tmpfilename);
tmpfilenoname = sprintf('%s_noname',tmpfilename);

%tmpprintname = fixunderbar(tmpfilename);
% for use with xfig and pstex
tmpxfigfilename = sprintf('x%s',tmpfilename);

set(gcf,'DefaultLineMarkerSize',10);
% set(gcf,'DefaultLineMarkerEdgeColor','k');
% set(gcf,'DefaultLineMarkerFaceColor','w');
set(gcf,'DefaultAxesLineWidth',2);

set(gcf,'PaperPositionMode','auto');
set(gcf,'Position',[12 138 763 655]);
tmppos= [0.2 0.2 0.7 0.7];
tmpa1 = axes('position',tmppos);

% main data goes here
info.p=0.5;  % cond prob of dormancy given release
info.q=0.1;  % prob of infection given contact
info.phi=10^-7; %cells/(ml*hr)
info.kminus=10^6*60*60; % per hr
info.kforw = info.kminus*info.q/(1-info.q);  % per hr
info.kplus = info.phi*info.q;
info.S0=10^7;  % cells per ml
info.V0_range=10.^(4:0.01:10);
info.M0_range=info.V0_range/info.S0;
info.delta_range=logspace(-2,2,1000);

[vM,vD]=meshgrid(info.M0_range,info.delta_range);

% 
for i=1:length(info.delta_range),
  info.delta=info.delta_range(i);
  info.Vcrit=info.S0/(1+info.delta);
  for j=1:length(info.M0_range),
    info.V0=info.V0_range(j);
    if (info.V0>info.Vcrit)
      Dout(i,j)=info.delta*info.S0/(1+info.delta);
    else
      Dout(i,j)=info.delta*info.V0;
    end
    DtoV(i,j) = Dout(i,j)/info.V0;
  end
end
imagesc(log10(info.M0_range),log10(info.delta_range),flipud(log10(DtoV)));
tmph=colorbar
set(tmph,'yticklabel',{'0.00001','0.0001','0.001','0.01', '0.1','1', '10','100'});
hold on
% Add a single contour at the critical value
[c,h]=contour(log10(info.M0_range),log10(info.delta_range),flipud(log10(DtoV)),[0 0]);
set(h,'linecolor','k','linewidth',3);
% Add the experimental data estimate
tmph=plot(log10(0.01),log10(1/45),'ko');
set(tmph,'markerfacecolor','k','markersize',14);
tmpt=text(log10(0.003),log10(1/30),'Bautista (2015)');
set(tmpt,'fontsize',14,'interpreter','latex');
info.V0_range=logspace(4,10,100);  % Viral density range
info.M0_range=info.V0_range/info.S0;
info.delta_range=logspace(-2,2,100);
set(gca,'xtick',[-2:1:2]);
set(gca,'ytick',[-2:1:2]);
set(gca,'xticklabel',{'0.01';'0.1';'1';'10';'100'});
set(gca,'yticklabel',{'100';'10';'1';'0.1';'0.01'});

% Label
xlabel('Initial virus-host ratio, $V_0/S_0$','fontsize',20,'verticalalignment','top','interpreter','latex');
ylabel('Individual cell fate ratio, $\delta$','fontsize',20,'verticalalignment','bottom','interpreter','latex');
title('Population dormancy enhancement, $D_{\infty}/V_0$','fontsize',20,'verticalalignment','bottom','interpreter','latex','horizontalalignment','center');
set(gca,'fontsize',20);

% Add the labels of the domains
tmpt = text(-2,-0.15,'$D_{\infty}/V_0>1$');
set(tmpt,'interpreter','latex','fontsize',16);
tmpt = text(-2,0.15,'$D_{\infty}/V_0<1$');
set(tmpt,'interpreter','latex','fontsize',16);


% loglog(,, '');
%
%
% Some helpful plot commands
% tmph=plot(x,y,'ko');
% set(tmph,'markersize',10,'markerfacecolor,'k');
% tmph=plot(x,y,'k-');
% set(tmph,'linewidth',2);


% for use with layered plots
% set(gca,'box','off')

% adjust limits
% tmpv = axis;
% axis([]);
% ylim([]);
% xlim([]);

% change axis line width (default is 0.5)
% set(tmpa1,'linewidth',2)

% fix up tickmarks
% set(gca,'xtick',[1 100 10^4])
% set(gca,'ytick',[1 100 10^4])

% creation of postscript for papers
% psprint(tmpxfigfilename);

% the following will usually not be printed 
% in good copy for papers
% (except for legend without labels)

% legend
% tmplh = legend('stuff',...);
% tmplh = legend('','','');
% remove box
% set(tmplh,'visible','off')
% legend('boxoff');

% title('','fontsize',24)
% 'horizontalalignment','left');

% for writing over the top
% coordinates are normalized again to (0,1.0)
tmpa2 = axes('Position', tmppos);
set(tmpa2,'visible','off');
% first two points are normalized x, y positions
% text(,,'','Fontsize',14);

% automatic creation of postscript
% without name/date
%psprintc(tmpfilenoname);
%psprint(tmpfilebwname);

tmpt = pwd;
%tmpnamememo = sprintf('[source=%s/%s.ps]',tmpt,tmpprintname);
%text(1.05,.05,tmpnamememo,'Fontsize',6,'rotation',90);
%datenamer(1.1,.05,90);
% datename(.5,.05);
% datename2(.5,.05); % 2 rows

% automatic creation of postscript
%psprintc(tmpfilename);

% set following on if zooming of 
% plots is required
% may need to get legend up as well
%axes(tmpa1)
%axes(tmplh)
clear tmp*
