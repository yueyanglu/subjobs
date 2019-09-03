clear
tic;
addpath(genpath('/nethome/yxl1496/HYCOM'));
%%%%%%%%%%%%%%%  Configure  %%%%%%%%%%%%%%%
% 1. Method: auto (1) or spread (2)
wichmethd=wichFrmSh; 
% 2. Full advection: orig (0) or geo (else)
ful2geo=0; 
% 3. MeanVel Name (set from shell).
coarse_file='coarsefile';
% 4. Time interval (set from shell). The 1st day of advection is (tloops(1)-1)*10.
tstep=0;
tloops=loop_s:loop_s+tstep; 
% 5. Region to evaluate diffusivities, whose unit is bin. (Size of bin is
% set in autoORdisp_GSH.m).
bis=300;bie=1000;
bjs=200;bje=700;
% 6. Layer
klay=1;
% 7. Scale of the velocity
scale_f=4;
% 8. Dir of the mean velocity 
% MeanVelPath=['/scratch/projects/ome/yueyang/OTPT_148DEG/COARSE_SMOOTH/Z',...
%     num2str(klay,'%2.2i'),'_many/'];
MeanVelPath=['/projects2/rsmas/ikamenkovich/yxl1496/OTPT_148DEG/COARSE_SMOOTH/Z',...
    num2str(klay,'%2.2i'),'/']; % or NO 'many'   ,'/many'
% 9. Technical params 
Np=30; day_interv=90.5; precisionODE=10^(-6);

%%%%%%%%%%%%%%%  Run  %%%%%%%%%%%%%%%
autoORdisp_GSH
% autoORdisp_GSH_MESO
% EO_GSH

% Saving
if wichmethd==1
    otptfile=['/projects2/rsmas/ikamenkovich/yxl1496/OTPT_148DEG/AOTU/compscale/',...
        coarse_file(2:end-9),'_',num2str(tloops(1),'%2.2i'),'_',num2str(tloops(end),'%2.2i'),...
        '_Rtau_Z',num2str(klay,'%2.2i'),'.mat'];
    save(otptfile,'dj','di','dt','day_interv','b*','klay','Mlen','R*','Np','precisionODE',...
        'tloops','Ltraj','scale_f','K*');
else
    otptfile=['/projects2/rsmas/ikamenkovich/yxl1496/OTPT_148DEG/DISP/scalef/',...
        coarse_file(2:end-9),'_',num2str(tloops(1),'%2.2i'),'_',num2str(tloops(end),'%2.2i'),...
        '_Disp_Z',num2str(klay,'%2.2i'),'.mat'];
    save(otptfile,'dj','di','dt','day_interv','b*','klay','Mlen','Rtio*','Np','precisionODE',...
        'tloops','Ltraj','scale_f','D*');
end
disp(['Output to: ',otptfile]);
toc;
