function fs = gdf_wake_monitor_construction(wake_length, dtsafety, mov)
% Constructs the monitor part of the gdf input file for GdfidL
%
% fs is
% wake_length is
% mov is a flag as to whether to export files for movie generation.
%
% Example: fs = gdf_wake_monitor_construction(wake_length)

if nargin < 2
    mov = 0; % defaulting to no movie generation.
end

fs = {'-fdtd'};
fs = cat(1,fs,'       -time');
fs = cat(1,fs,['       dtsafety = ',dtsafety]);
fs = cat(1,fs,'       -fmonitor');
fs = cat(1,fs,'       name = EfieldatZero');
fs = cat(1,fs,'       whattosave = ecomponents');
fs = cat(1,fs,'       doit');
fs = cat(1,fs,'       -pmonitor');
fs = cat(1,fs,'       name = TEIS');
fs = cat(1,fs,'       whattosave = energy');
fs = cat(1,fs,'       doit');
fs = cat(1,fs,'        ');
fs = cat(1,fs,'    -pmonitor');
fs = cat(1,fs,'        name = TEC');
fs = cat(1,fs,'        whattosave = pdielectrics');
fs = cat(1,fs,'        doit');
fs = cat(1,fs,'');
% fs = cat(1,fs,'    -storefieldsat');
% fs = cat(1,fs,'        name= ED');
% fs = cat(1,fs,'        whattosave = e-fields');
% % reducing the wake length as sometimes the simulation stops just before
% % the defined wake length, and then the power monitors are not triggered.
% fs = cat(1,fs,['           firstsaved= ',num2str(str2double(wake_length)-0.2),' / @clight']);
% fs = cat(1,fs,'           lastsaved= INF');
% fs = cat(1,fs,'           distance= 10 / @clight');
% fs = cat(1,fs,'        doit');
% fs = cat(1,fs,'    -storefieldsat');
% fs = cat(1,fs,'        name= EF');
% fs = cat(1,fs,'        whattosave = both');
% fs = cat(1,fs,['           firstsaved= (',num2str(str2double(wake_length)),' / @clight - 1e-9)']);
% fs = cat(1,fs,'           lastsaved= INF');
% fs = cat(1,fs,'           distance= 100e-12');
% fs = cat(1,fs,'        doit');
if mov == 1
%     fs = cat(1,fs,' define( PMLCOMPENSATION, 51e-3  / @clight )'); % for 40 PMLS
    fs = cat(1,fs,' define( FIRSTSAV, 1e-3  / @clight )');
    fs = cat(1,fs,' define( DISTSAV, 3e-3 / @clight )');
    fs = cat(1,fs,' define( MODELLENTIME, INF)');%50E-3 / @clight )');%( @zmax - @zmin) / @clight )');
    fs = cat(1,fs,'    -storefieldsat');
    fs = cat(1,fs,'        name= ALL');
    fs = cat(1,fs,'        whattosave = e');
    fs = cat(1,fs,['           firstsaved= FIRSTSAV']);
    fs = cat(1,fs,'           lastsaved= FIRSTSAV + MODELLENTIME * 1');
    fs = cat(1,fs,'           distancesaved= DISTSAV');
    fs = cat(1,fs,'        doit');
    fs = cat(1,fs,'    -storefieldsat');
    fs = cat(1,fs,'        name= IMP');
    fs = cat(1,fs,'        whattosave = jimpedance');
    fs = cat(1,fs,['           firstsaved= FIRSTSAV']);
    fs = cat(1,fs,'           lastsaved= FIRSTSAV + MODELLENTIME * 1');
    fs = cat(1,fs,'           distancesaved= DISTSAV');
    fs = cat(1,fs,'        doit');
    
%     fs = cat(1,fs,'# Store data for the Movie.');
%     fs = cat(1,fs,'    -fexport');
%     fs = cat(1,fs,'       outfile= temp_data/efields');
%     fs = cat(1,fs,'       what= e-fields');
%     % fs = cat(1,fs,'       bbylow=0'); % only recording half height.
%     fs = cat(1,fs,'       firstsaved= PMLCOMPENSATION');
%     fs = cat(1,fs,'       distancesaved= DISTSAV');
%     fs = cat(1,fs,'       lastsaved= PMLCOMPENSATION + MODELLENTIME + 200 * DISTSAV');
%     fs = cat(1,fs,'       doit');
%     fs = cat(1,fs,'    -fexport');
%     fs = cat(1,fs,'       outfile= temp_data/hfields');
%     fs = cat(1,fs,'       what= h-fields');
%     % fs = cat(1,fs,'       bbylow=0'); % only recording half height.
%     fs = cat(1,fs,'       firstsaved= PMLCOMPENSATION');
%     fs = cat(1,fs,'       distancesaved= DISTSAV');
%     fs = cat(1,fs,'       lastsaved= PMLCOMPENSATION + MODELLENTIME + 200 * DISTSAV');
%     fs = cat(1,fs,'       doit');
%     fs = cat(1,fs,'    -fexport');
%     fs = cat(1,fs,'       outfile= temp_data/honmat');
%     fs = cat(1,fs,'       what= honmat');
%     % fs = cat(1,fs,'       bbylow=0'); % only recording half height.
%     fs = cat(1,fs,'       firstsaved= PMLCOMPENSATION');
%     fs = cat(1,fs,'       distancesaved= DISTSAV');
%     fs = cat(1,fs,'       lastsaved= PMLCOMPENSATION + MODELLENTIME + 200 * DISTSAV');
%     fs = cat(1,fs,'       doit');
else
    fs = cat(1,fs,'# No movie requested... not storing additional files.');
end %if

fs = cat(1,fs,'-fdtd   ');
fs = cat(1,fs,'    doit');