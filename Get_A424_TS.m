%% Notes
% If your data are in the volume space use the following script
% If your data are in cifti user the HCP workbench in shell as follow
%    f="brainmaps/examples/fMRI"; dlabel="brainmaps/A424.dlabel.nii";
%    cmd1="wb_command -cifti-parcellate ${f}.dtseries.nii ${dlabel} COLUMN ${f}.ptseries.nii -method MEAN"
%    cmd2="wb_command -cifti-convert -to-text ${f}.ptseries.nii ${f}.dat"
%    cmd3="rm ${f}.ptseries.nii"
% 
% fMRI.dtseries.nii: wget https://github.com/emergelab/hierarchical-brain-networks/blob/master/brainmaps/fMRI.dtseries.nii
% A424.dlabel.nii: wget https://github.com/emergelab/hierarchical-brain-networks/blob/master/brainmaps/A424.dlabel.nii

%% Set variables
f = 'brainmaps/examples/fMRI'; %the preproccessed fMRI.nii.gz data in the volume sapce 
l = 'brainmaps/A424+2mm'; %standard space atlas with cortical GM expanded by 2mm in WM
% consider generating subject-specific atlas by multiplying subject-specific
% GM mask by A424+n90merged or A424+4mm
%
% fMRI.nii.gz: wget https://github.com/emergelab/hierarchical-brain-networks/blob/master/brainmaps/fMRI.nii.gz
% A424+2mm: wget https://github.com/emergelab/hierarchical-brain-networks/blob/master/brainmaps/A424%2B2mm.nii.gz
% A424+4mm: wget https://github.com/emergelab/hierarchical-brain-networks/blob/master/brainmaps/A424%2B4mm.nii.gz
% A424+n90merged: wget https://github.com/emergelab/hierarchical-brain-networks/blob/master/brainmaps/A424%2Bn90merged.nii.gz


%% Load images and labels
  fprintf('\n\nLoading 4D image from %s\n\n',f);
try
    [dts,dims,~,~,~]=read_avw(f);
    catch
    fprintf('Loading 4D File Error for %s\n',f)
    exit
end
try
    label = read_avw(l); label = label(:);
    catch
    fprintf('Loading dlabel File Error for %s\n',l)
    exit
end

    m = reshape(dts,[dims(1)*dims(2)*dims(3),dims(4)])'; clear dts
    sh = size(m,1);
    
%% get parcellated time series given a label input

  fprintf('\n\nGet parcellated time series using %s\n\n',l);

  nParcels = 424;
  pMeas = zeros(nParcels,3);
  pmTS = zeros(sh,nParcels);
  for i = 1:nParcels
    ind = (label == i);
    y = m(:,ind);
    pmTS(:,i) = mean(y,2);    
  end
    pmTS(isnan(pmTS)) = 0;

  %% Save TS
  
    fn = [f '.dat'];
    dlmwrite(fn,pmTS,'\t');
