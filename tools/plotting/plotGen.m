%% Quality Assurance metrics and images
% Please inspect these prior to interpreting any results! Errors in
% manually or automatically generated labelmaps can lead to incorrect
% unfolding. Use this tool to ensure measures are correct.

try
    sampleprefix = out_filename; %sometimes used this as variable name, catch it just in case
end
mkdir([sampleprefix '/plots']);

load([sampleprefix 'unfold.mat']);%, '-regexp', '^(?!sampleprefix)\w');
load([sampleprefix 'surf.mat'], '-regexp', '^(?!sampleprefix)\w');
T2w = ls([sampleprefix 'img.nii.gz']);
T2w(end) = [];
T2w = load_untouch_nii(T2w);
T2w = T2w.img;

% load generic
load('misc/BigBrain_ManualSubfieldsUnfolded.mat');
subfields_avg = imresize(subfields_avg,0.5,'nearest');
load('../Hippocampal_AutoTop/misc/itkColours.mat');
itkColours = itkColours/255;
itkColours = [0 0 0; itkColours];

%% Midsurf mesh

Vrec = CosineRep_2Dsurf(Vmid,64,0.005); 
[i_L,j_L,k_L]=ind2sub(sz,idxgm);
t = ~ismember(round(Vrec),[i_L,j_L,k_L]);
Vrec(t) = nan;

% view mesh in 3D
% plot
figure;
v = reshape(Vmid,[APres*PDres,3]); 
p = patch('Faces',F,'Vertices',v,'FaceVertexCData',subfields_avg(:));
p.FaceColor = 'flat';
p.LineStyle = 'none';
axis equal tight off;
material dull;
light;
caxis([0 8]); colormap(itkColours);
saveas(gcf,[sampleprefix '/plots/3Dsubfields-sup.png']);
view([0,-90]); 
light('Position',[-1 -1 -1]);
saveas(gcf,[sampleprefix '/plots/3Dsubfields-inf.png']);

% view mesh in 3D
% plot
figure;
v = reshape(Vrec,[APres*PDres,3]); 
p = patch('Faces',F,'Vertices',v,'FaceVertexCData',subfields_avg(:));
p.FaceColor = 'flat';
p.LineStyle = 'none';
axis equal tight off;
material dull;
light;
caxis([0 8]); colormap(itkColours);
saveas(gcf,[sampleprefix '/plots/3DsubfieldsSmooth-sup.png']);
view([0,-90]); 
light('Position',[-1 -1 -1]);
saveas(gcf,[sampleprefix '/plots/3DsubfieldsSmooth-inf.png']);

% and in 2D
figure;
imagesc(subfields_avg');
axis equal tight off;
caxis([0 8]); colormap(itkColours);
set(gca,'ydir','normal');
saveas(gcf,[sampleprefix '/plots/unfoldedSubfields.png']);

%% 3D plots of gradients
Vuvw = reshape(Vuvw,[APres,PDres,IOres,3]);
AP = Vuvw(:,:,2,1);
PD = Vuvw(:,:,2,2);

figure;
v = reshape(Vrec,[APres*PDres,3]); 
p = patch('Faces',F,'Vertices',v,'FaceVertexCData',AP(:));
p.FaceColor = 'flat';
p.LineStyle = 'none';
axis equal tight off;
material dull;
light;
caxis([0 1]);
saveas(gcf,[sampleprefix '/plots/3DAPgradSmooth-sup.png']);
view([0,-90]); 
light('Position',[-1 -1 -1]);
saveas(gcf,[sampleprefix '/plots/3DAPgradSmooth-inf.png']);

figure;
v = reshape(Vrec,[APres*PDres,3]); 
p = patch('Faces',F,'Vertices',v,'FaceVertexCData',PD(:));
p.FaceColor = 'flat';
p.LineStyle = 'none';
axis equal tight off;
material dull;
light;
caxis([0 1]);
saveas(gcf,[sampleprefix '/plots/3DPDgradSmooth-sup.png']);
view([0,-90]); 
light('Position',[-1 -1 -1]);
saveas(gcf,[sampleprefix '/plots/3DPDgradSmooth-inf.png']);

%% plot individual slices

slices = [64 0 0; 55 0 0];
overlay = zeros(sz);
overlay(idxgm) = Laplace_AP;
overlay(sourceAP) = -0.1;
overlay(sinkAP) = 1.10;
overlayplot(T2w,overlay,slices,[sampleprefix 'plots/APgrad'])

slices = [0 64 0; 0 128 0; 0 180 0; 0 150 0];
overlay = zeros(sz);
overlay(idxgm) = Laplace_PD;
overlay(sourcePD) = -0.1;
overlay(sinkPD) = 1.10;
overlayplot(T2w,overlay,slices,[sampleprefix 'plots/PDgrad'])

slices = [0 64 0; 0 128 0; 0 180 0; 0 150 0];
overlay = zeros(sz);
overlay(idxgm) = Laplace_IO;
limsinkIO = imdilate(overlay~=0, strel('sphere',2')) & overlay==0;
overlay(limsinkIO) = 1.10;
overlay(sourceIO) = -0.1;
overlayplot(T2w,overlay,slices,[sampleprefix 'plots/IOgrad'])

%% plot tissue classes

slices = [64 0 0; 55 0 0; 0 64 0; 0 128 0; 0 180 0; 0 150 0];
overlayplot(T2w,labelmap,slices,[sampleprefix 'plots/labelmap'])


%% plot extracted features

% streamlengths(streamlengths>4) = 4;
featureview(streamlengths,Vrec,F,1,[sampleprefix 'plots/thickness']);
featureview(GI,Vrec,F,1,[sampleprefix 'plots/gyrification']);
featureview(qMap,Vrec,F,1,[sampleprefix 'plots/T2w']);
