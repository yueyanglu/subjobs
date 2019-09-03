clear
tic;
addpath(genpath('/nethome/yxl1496/HYCOM'));
%%%%%%%%%%%%%%%  Configure  %%%%%%%%%%%%%%%

% 1. Time interval (set from shell). The 1st day of advection is (tloops(1)-1)*10.
tstep=0;
tloops=loop_s:loop_s+tstep; 
% 2. Region to evaluate diffusivities.
% Bins for Lagrangian method is as follows:
% bis=200;bie=1300;
% bjs=100;bje=900;
% Staggered in the ptcls method:
% -+ di/2 makes sure 'tracer-based' K centered on the same grids with former Lagr method.
di=50;dj=50;
bis=200-di/2;bie=1300+di/2;
bjs=100-dj/2;bje=900+dj/2; 
[njb,nib]=deal(length(bjs:dj:bje),length(bis:di:bie));
% 3. Layer
klay=1;
% 4. Scale of the velocity
scale_f=1;
% 5. Technical params 
day_interv=60.5; precisionODE=10^(-7);
% 6. Reshape the traj and LagVel matrices? 
IsReshape=1;
% 7. Initial distribution of ptcls (1-1 or njb-by-nib): 
Np=35.*ones(njb,nib);
% Np=ones(njb,1)*((43:-1:20)+12);  % zonal gradient 
% Np=((43:-1:26)+10)'*ones(1,nib);   % meridional gradient
if ~IsReshape
    % If no reshape, Np must be uniform
    if ~all(Np==Np(1,1),'all')
        error('No reshape, so Np must be uniform!!!');
    end
end

%%%%%%%%%%%%%%%  Run  %%%%%%%%%%%%%%%
ptclsonly_GSH

% First save configures into a seperate .mat file
confgfile='/scratch/projects/ome/yueyang/otpt_hycom/TRAJ_VEL/tracer4_precison/confg.mat';
% confgfile='/projects2/rsmas/ikamenkovich/yxl1496/OTPT_148DEG/TRAJ_VEL/tracer3/confg.mat';
if ~exist(confgfile,'file')
    save(confgfile,'dj','di','dt','day_interv','b*','klay','N*','precisionODE',...
        'Ltraj','scale_f');
end
% Saving trajs and vels to .nc file
otptfile=['/scratch/projects/ome/yueyang/otpt_hycom/TRAJ_VEL/tracer4_precison/trajs_',...
    num2str(tloops(1),'%2.2i'),'_',num2str(tloops(end),'%2.2i'),...
    '_Z',num2str(klay,'%2.2i'),'.nc'];
% otptfile=['/projects2/rsmas/ikamenkovich/yxl1496/OTPT_148DEG/TRAJ_VEL/tracer3/trajs_',...
%     num2str(tloops(1),'%2.2i'),'_',num2str(tloops(end),'%2.2i'),...
%     '_Z',num2str(klay,'%2.2i'),'.nc'];
if IsReshape
    nccreate(otptfile,'Xtr','Dimensions',{'dim1',Ltraj,'dim2',sum(Ntraj,'all')});
    nccreate(otptfile,'Ytr','Dimensions',{'dim1',Ltraj,'dim2',sum(Ntraj,'all')});
    nccreate(otptfile,'Ul','Dimensions',{'dim1',Ltraj,'dim2',sum(Ntraj,'all')});
    nccreate(otptfile,'Vl','Dimensions',{'dim1',Ltraj,'dim2',sum(Ntraj,'all')});
else
    nccreate(otptfile,'Xtr','Dimensions',{'dim1',Ltraj,'dim2',mean(Ntraj,'all'),...
        'dim3',njb,'dim4',nib});
    nccreate(otptfile,'Ytr','Dimensions',{'dim1',Ltraj,'dim2',mean(Ntraj,'all'),...
        'dim3',njb,'dim4',nib});
    nccreate(otptfile,'Ul','Dimensions',{'dim1',Ltraj,'dim2',mean(Ntraj,'all'),...
        'dim3',njb,'dim4',nib});
    nccreate(otptfile,'Vl','Dimensions',{'dim1',Ltraj,'dim2',mean(Ntraj,'all'),...
        'dim3',njb,'dim4',nib});
end
ncwrite(otptfile,'Xtr',Xtr); 
ncwrite(otptfile,'Ytr',Ytr);
ncwrite(otptfile,'Ul',Ul);
ncwrite(otptfile,'Vl',Vl); 
disp(['Output to: ',otptfile]);
toc;
