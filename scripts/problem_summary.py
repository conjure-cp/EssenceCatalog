#!/usr/bin/python
import os, sys
from sys import argv
import pandas as pd
from pandas.core.api import DataFrame

def get_all_files(folder, filter_function)-> list:
    files = []
    try:
        files = os.listdir(folder)
    except:
        return []
    files_and_content = []
    for file in files:
        current = os.path.join(folder, file)
        if os.path.isdir(current):
            sub_content = get_all_files(current, filter_function)
            files_and_content += sub_content
        elif filter_function(current):
                files_and_content.append(current)
    return files_and_content

def get_problem_data(folder):
    instances = get_all_files(os.path.join(folder, "params"), filter_function= lambda x: ".param" in x)
    number_of_instances = len(instances)
    model_file = get_all_files(folder, filter_function= lambda x: ".essence" in x)[0].split("/")[-1]
    return {"NumberOfInstances":number_of_instances, "model":model_file}

def get_all_subfolders(folder)-> list:
    files = []
    try:
        files = os.listdir(folder)
    except:
        return []
    folders = []
    for file in files:
        current = os.path.join(folder, file)
        if os.path.isdir(current):
            folders.append(current)
    return folders

def main():
    if len(argv) != 3:
        sys.exit("please provide a folder to scan and an output filename")
    main_folder = argv[1]   
    sub_folders = get_all_subfolders(main_folder)
    data = []
    for folder in sub_folders:
        data.append(get_problem_data(folder))
    data = sorted(data, key = lambda x: x["NumberOfInstances"], reverse=True)

    dataframe = pd.DataFrame(data)
    dataframe.to_csv(argv[2], mode = 'w', index=False)
    for i in range(len(dataframe)):
        print(f"{i}) {dataframe.iloc[i,:]['model']} with {dataframe.iloc[i,:]['NumberOfInstances']} instances")
main()
