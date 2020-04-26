import pandas as pd
import numpy as np
from scipy.cluster.hierarchy import dendrogram, linkage
from sklearn.decomposition import PCA
from matplotlib import pyplot as plt
import pickle


def clusterizer(df, leaf_labels):
    D = df.values
    if len(leaf_labels) != len(D):
        D = np.transpose(D)
    Z = linkage(D, method='complete', metric='correlation')
    
    plt.figure(figsize=(50, 20))
    ax = plt.subplot()
    plt.subplots_adjust(left=0.07, bottom=0.3, right=0.98, top=0.95,
                        wspace=0, hspace=0)     
    plt.xlabel('samples')
    plt.ylabel('distance')
    dendrogram(Z, leaf_rotation=90., leaf_font_size=10., labels=leaf_labels)
    plt.savefig('/home/mary/hackathon/data/dendrogram_rnaseq_by_attribute.png')


if __name__ == '__main__':

#    dataset = pd.read_pickle('/home/mary/hackathon/data/full_encoded_dataset.npy')
    dataset = pd.read_pickle('/home/mary/hackathon/data/encoded_samples_endowed_w_rnaseq.npy')
#    dataset = dataset.set_index('Subject.ID')
    attributes = list(dataset.columns.values)
    
    clusterizer(dataset, attributes)


