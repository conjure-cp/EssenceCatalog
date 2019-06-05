#!/usr/bin/env python3
# Based on Pete's psplib > eprime program.
import os
import sys

def main():
    folder = sys.argv[1]
    files=os.listdir(folder)

    files=[files[i] for i in range(len(files)) if files[i][-3:]==".sm" or files[i][-3:]==".mm"]   #  Name ends with .sm or .mm

    for f in files:
        mm_f = folder + "/" + f
        print("Converting:"+mm_f)
        lines=open(mm_f).readlines()
        jobs=int(next( (line for line in lines if line[:4]=="jobs") ).split(":")[1])
        horizon=int(next( (line for line in lines if line[:7]=="horizon") ).split(":")[1])
        renewresources=int(next( (line for line in lines if line[:13]=="  - renewable") ).split(":")[1].split()[0])
        nonrenewresources=int(next( (line for line in lines if line[:16]=="  - nonrenewable") ).split(":")[1].split()[0])
        resources=renewresources+nonrenewresources

        # Find start of precedences
        for i in range(len(lines)):
            if lines[i][:21]=="PRECEDENCE RELATIONS:":
                startprec=i+2
                break

        maxsuccessors=0
        for i in range(1, jobs+1):
            ln=startprec+i-1
            succ=int(lines[ln].split()[2])
            if succ>maxsuccessors:
                maxsuccessors=succ

        successors=[ [] for i in range(jobs) ]
        nummodes=[ 0 for i in range(jobs) ]
        for i in range(1, jobs+1):
            ln=startprec+i-1
            successors[i-1]=[int(x) for x in lines[ln].split()[3:]]
            # Pad
            # successors[i-1]+= (maxsuccessors-len(successors[i-1]))*[-1]
            nummodes[i-1]=int(lines[ln].split()[1])

        # Find start of requests
        for i in range(len(lines)):
            if lines[i][:19]=="REQUESTS/DURATIONS:":
                startrec=i+3
                break

        # Find start of availabilities
        for i in range(len(lines)):
            if lines[i][:23]=="RESOURCEAVAILABILITIES:":
                startavail=i+2
                break

        durations=[ [] for i in range(jobs)]  #  Indexed by job then mode.

        #  Indexed by job, mode, resource.
        res=[ [ [-1 for j in range(resources)] for k in range(nummodes[i]) ] for i in range(jobs) ]

        for i in range(startrec, startavail-3):
            sp=lines[i].split()
            if len(sp)==resources+2:
                sp=[str(jobnr)]+sp
            jobnr=int(sp[0])
            # print("Job: "+str(jobnr)+" mode: "+sp[1])
            assert int(sp[1])==len(durations[jobnr-1])+1  #  Modes in order.
            mode=int(sp[1])
            durations[jobnr-1].append(int(sp[2]))
            for j in range(resources):
                # print(str(jobnr-1))
                # print(str(mode-1))
                # print(str(j))
                res[jobnr-1][mode-1][j]=int(sp[3+j])


        resavail=[int(st) for st in lines[startavail].split()]

        #  Check for potential AC-CSs
        #for res1 in range(resources):
        #    for res2 in range(res1+1, resources):
        #        for job1 in range(jobs):
        #            for job2 in range(job1+1, jobs):
        #                if res[job1][res1]!=0 and res[job1][res1]==res[job1][res2] and res[job2][res1]!=0 and res[job2][res1]==res[job2][res2]:
        #                    print("Potential AC-CS in :"+f)

        # GOK Stuff
        max_mode = max(nummodes)
        job_str = enum_generator("jobs", "j", jobs)
        ren_res_str = enum_generator("renewableResources", "rr", renewresources)
        non_res_str = enum_generator("nonRenewableResources", "nr", nonrenewresources)
        mode_str = enum_generator("modes", "m", max_mode)
        durations_str = function_generator("duration", ["j", "m"], durations)
        rr, nr = split_res(res)
        rr_str = function_generator("renewableResourceUsage", ["j", "m", "rr"], rr)
        nr_str = function_generator("nonRenewableResourceUsage", ["j", "m", "nr"], nr)
        rrl_str = function_generator("renewableLimits", ["rr"], resavail[:2])
        nrl_str = function_generator("nonRenewableLimits", ["rr"], resavail[2:])
        suc_set = make_suc_sets(successors)
        suc_str = function_generator("successors", ["j"], suc_set, output_abbr="j_")
        hor_str = val_generator("horizon", horizon)
        dum_start_str = val_generator("startDummy", "j_" + str(1))
        dum_end_str = val_generator("endDummy", "j_" + str(jobs))

        # Output the param file.
        new_file_name = "params/" + f + "-essence.param"
        fout=open(new_file_name, "w")

        print("language ESSENCE 1.3", file=fout)
        print("$ Generated from file "+f, file=fout)
        print(job_str, file=fout)
        print(ren_res_str, file=fout)
        print(non_res_str, file=fout)
        print(mode_str, file=fout)
        print(durations_str, file=fout)
        print(rr_str, file=fout)
        print(nr_str, file=fout)
        print(rrl_str, file=fout)
        print(nrl_str, file=fout)
        print(suc_str, file=fout)
        print(hor_str, file=fout)
        print(dum_start_str, file=fout)
        print(dum_end_str, file=fout)



# GOK Stuff

def enum_generator(type_name, type_abbr, nb_type):
    types = [ type_abbr + "_" + str(i+1) for i in range(nb_type) ]
    line = "letting " + type_name + " be new type enum { "
    for i in range(len(types)):
        line+=types[i]+", "
    line=line[:-2]+" }"
    return line

def function_generator(f_name, input_abbr_array, input_matrix, output_abbr=""):
    line = "letting " + f_name + " be function ( "
    function_dict = get_function_dict(input_matrix, output_abbr)
    for key in function_dict:
        in_array = str(key).split(",")
        line+="( "
        for i in range(len(in_array)):
            val = int(in_array[i]) + 1
            line+= str(input_abbr_array[i]) + "_" + str(val) + ", "
        line= line[:-2] + " )" " --> " + str(function_dict[key]).replace("\'","") + ", "
    line=line[:-2] + " ) "
    return line

def val_generator(v_name, value):
    line = "letting " + v_name + " be " + str(value)
    return line

def get_function_dict(matrix, prefix=""):
    if type(matrix) is list:
        val = dict()
        for i in range(len(matrix)):
            mat = get_function_dict(matrix[i], prefix)
            if type(mat) is dict:
                for j in mat:
                    key = str(i) + "," + str(j)
                    val[key] = mat[j]
            elif type(mat) is set:
                if len(mat) == 0:
                    val[i] = "{}"
                else:
                    adj_set = set()
                    for key in mat:
                        a = prefix + str(key)
                        adj_set.add(a)
                    val[i] = adj_set
            else:
                val[i] = prefix + str(mat)
        return val
    return matrix

def split_res(res):
    rr = []
    nr = []
    for j in range(len(res)):
        rr_m = []
        nr_m = []
        for m in range(len(res[j])):
            rr_m.append(res[j][m][:2])
            nr_m.append(res[j][m][2:])
        rr.append(rr_m)
        nr.append(nr_m)
    return rr, nr

def make_suc_sets(suc):
    suc_sets = []
    for i in range(len(suc)):
        suc_sets.append(set(suc[i]))
    return suc_sets

if __name__ == "__main__":
    main()