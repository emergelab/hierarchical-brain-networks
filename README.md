# Hierarchical Brain Networks

**Determining the Hierarchical Architecture of the Human Brain Using Subject-Level Clustering of Functional Networks** 
Teddy J. Akiki, Chadi G. Abdallah
Scientific Reports 9, 19290 (2019) doi: [10.1038/s41598-019-55738-y](https://doi.org/10.1038/s41598-019-55738-y)

## Installation 

The code relies on [HierarchicalConsensus](https://github.com/LJeub/HierarchicalConsensus) and [GenLouvain](https://github.com/GenLouvain/GenLouvain).


## Usage

This will help you generate a group-representative community organization starting from regional (parcellated fMRI) time series. 

#### Mapping community organization at the subject level

Before running the [hierarchical consensus clustering algorithm](https://github.com/LJeub/HierarchicalConsensus), we first need to map the community organization from individual subjects. Functional MRI time series can be loaded in a `nindiv x dtpoints x nroi` MATLAB array, where `nindiv` is the number of individuals, `dtpoints` is the number of datapoints in the time series, and `nroi` is the number of ROIs. The null model here is based on [Random Matrix Theroy](https://www.mathworks.com/matlabcentral/fileexchange/49011-random-matrix-theory-rmt-filtering-of-financial-time-series-for-community-detection). After you make sure that all relevant files have been added to the path, you can run

```Matlab
for i=1:nindiv
    all_ci{ii,1}=RMT_com(squeeze(TS_all(i,:,:)),n);
end
```

This will generate a cell array `all_ci` containing subject-level hierarchical community organization. Note that the number of hierarchies can vary between subjects. 

Optional: to reassign singletons, you can use

```Matlab
for i=1:nindiv
    tmptmp_ci=all_ci{i,1};
    newtmp_ci=ci_restoresingleton(tmptmp_ci);
    all_ci{i,1}=newtmp_ci;
end
```

To organize the data in the cell arrays into an easier to use contactenated array, you can use

```Matlab
all_ci_combined=all_ci{1,1};
for i=2:nindiv
    tmp_ci=all_ci{i,1};
    all_ci_combined=horzcat(all_ci_combined,tmp_ci);
end
```

#### Generating a group-level consensus

Now you can use [HierarchicalConsensus](https://github.com/LJeub/HierarchicalConsensus) to generate a co-classification matrix followed by the concensus clustering algorithm.

```Matlab
C=coclassificationMatrix(all_ci_combined);
[Sc,Tree]=hierarchicalConsensus(all_ci_combined,0.05);
[Sall,thresholds]=allPartitions(Sc,Tree);
consensusPlot(C,Sc,Tree);
```
## Brain maps

You will find the hierarchical community partition solutions described in the study in the brainmaps folder.
