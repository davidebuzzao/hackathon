def encode(column, basename=''):
    """input is a list of strings, single words separated by comma. Ouput is encoding of those strings
    as lists of 0 and 1 for presence/absence of those words in alphabetical order
    returns a Pandas dataframe where the words are marked as presence/absence"""
    import pandas as pd
    # figure out the mapping b/w vector positions and terms
    mapper = dict()
    term_set = list()
    out_column = list()
    for i in range(len(column)):
        if isinstance(column[i], str):
            terms = column[i].split(',')
            for j in range(len(terms)):
                terms[j] = terms[j].strip()
                if terms[j] not in term_set:
                    term_set.append(terms[j])
            column[i] = terms
    term_set = sorted(term_set)
    for i in range(len(term_set)):
        mapper[term_set[i]] = i

    # encode the whole thing as vectors
    for i in column:
        if isinstance(i, list):
            encoded_i = [0 for i in range(len(term_set))]
            for j in i:
                encoded_i[mapper[j]] = 1
            out_column.append(encoded_i)
        else:
            encoded_i = [0 for i in range(len(term_set))]
            out_column.append(encoded_i)
    

    # transform in pandas dataframe
    basenames = list()
    for i in term_set:
        basenames.append(basename+i)
    out_df = pd.DataFrame(out_column, columns = basenames)
    return out_df




if __name__ == '__main__':
    import pandas as pd
    import numpy as np
    df_path = '/home/mary/hackathon/data/GTEx_pancreas_liver_images_liverfat_pancreasfat.xlsx'
    gtex_noseq = pd.read_excel(df_path)
#    print(list(gtex_noseq.columns))
#    print(list(gtex_noseq['Pathology.Categories_liver']))

    encode(list(gtex_noseq['Pathology.Categories_pancreas']), basename='pancreas_')


