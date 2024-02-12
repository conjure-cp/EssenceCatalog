#!/usr/bin/env python3
import sys

def assertStartsWith(prefix,line):
    if not line.startswith(prefix):
        print("Error: Expected line to start with " + prefix +
        ".\nLine: " + line, file=sys.stderr)
        sys.exit(1)


def readValue(prefix, file):
    line = file.readline()
    assertStartsWith(prefix,line)
    return int(line.split(" ")[1].strip())

def handleInstance(name, file):
    numberItems = readValue("n ", file)
    capacity = readValue("c ", file)
    optimum = readValue("z ", file)
    assertStartsWith("time ", file.readline())
    weights = []
    profits = []
    for line in file:
        if line.startswith("---"):
            break
        prefix = str(len(weights) + 1) + ","
        assertStartsWith(prefix,line)
        csv = line.split(",")
        profits.append(int(csv[1]))
        weights.append(int(csv[2]))
    filename = name + ".param"
    print("Writing file:", filename)
    with open(filename, "w") as out:
        print("$instance size is ", numberItems,file=out)
        print("letting capacity be ", capacity, file=out)
        print("letting items be new type enum { ", file=out)
        print(",".join(["a" + str(i) for i in range(1,len(weights) + 1)]), file=out)
        print("}", file=out)
        print("letting weight be function (", file=out)
        print(",".join(['a'+str(i + 1) + " --> " + str(w) for (i,w) in enumerate(weights)]), file=out)
        print(")", file=out)
        
        print("letting gain be function (", file=out)
        print(",".join(['a'+str(i + 1) + " --> " + str(p) for (i,p) in enumerate(profits)]), file=out)
        print(")", file=out)


def main(file):
    for line in file:
        if line.startswith("knapPI_"):
            handleInstance(line.strip(), file)

if __name__ == "__main__":
    with open(sys.argv[1]) as file:
        main(file)
