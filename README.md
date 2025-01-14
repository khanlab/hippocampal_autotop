### Summary

This tool aims to automatically model the topological folding structure of the human hippocampus. It is currently set up to use sub-millimetric T2w MRI data, but may be adapted for other data types. This can then be used to apply the hippocampal unfolding methods presented in [DeKraker et al., 2019](https://www.sciencedirect.com/science/article/pii/S1053811917309977), and ex-vivo subfield boundaries can be topologically applied from [DeKraker et al., 2020](https://www.sciencedirect.com/science/article/pii/S105381191930919X?via%3Dihub).

![Pipeline Overview](https://github.com/jordandekraker/Hippocampal_AutoTop/blob/master/misc/pipeline_overview.png)

The overall workflow can be summarized in the following steps:

0) Resampling to a 0.3mm isotropic, coronal oblique, cropped hippocampal block

1) Automatic segmentation of hippocampal tissues and surrounding structures via deep convolutional neural network U-net ([Li _et al_., 2017](https://arxiv.org/abs/1707.01992)) _OR_ Manual segmentation of hippocampal tissues and surrounding structures using [this](https://ars.els-cdn.com/content/image/1-s2.0-S1053811917309977-mmc1.pdf) protocol

2) Post-processing via fluid label-label registration to a high resolution, topoligically correct averaged template

3) Imposing of coordinates across the anterior-posterior, proximal-distal, and laminar dimensions of hippocampal grey matter via solving the Laplace equation

4) Extraction of a grey matter mid-surface and morpholigical features (thickness, curvature, gyrification index, and, if available, quantitative MRI values sampled along the mid-surface for reduced partial-voluming)

5) Quality assurance via inspection of Laplace gradients, grey matter mid-surface, and flatmapped features

6) Application of subfield boundaries according to predifined topological coordinates


### Installation

The preferred method to run the code is through Docker or Singularity, using the container provided on docker hub https://hub.docker.com/r/khanlab/hippocampal_autotop,  `docker://khanlab/hippocampal_autotop:latest`

If you have your data in BIDS format, you can alternatively use the BIDS App wrapper at https://github.com/khanlab/hippocampal_autotop_bids, or on docker hub https://hub.docker.com/r/khanlab/hippocampal_autotop_bids.

### Usage

Running in Matlab (with all dependencies installed - see http://hub.docker.com/r/khanlab/autotop_deps):
```
singleSubject \<input T2w image\> \<output directory\> \<OPTIONAL manual tissue segmentation\> \<OPTIONAL study-specific reference atlas for cropping around the hippocampi\>
```

Running with Singularity:
```
singularity pull docker://khanlab/hippocampal_autotop:latest hippocampal_autotop_latest.sif
singularity run --nv hippocampal_autotop_latest.sif /path/to/input_data/subj01_T2w.nii.gz /path/to/output_data/output_subj01  # can leave out the --nv if not using GPU
```

#### Processing time for a single subject:

With GPU: 15 minutes (8-core, 32gb memory, Tesla T4)
Wihout GPU: ~30 minutes (8-core, 32gb memory) 

Note: the same container has both GPU and CPU versions, will run using CPU if a GPU is not found.
