import pandas as pd
import numpy as np
import sys

# Parsing user input
try:
    in1 = sys.argv[1]
    out1 = sys.argv[2]
except:
    print __doc__
    sys.exit(1)

with open(in1, "r") as file:
    num = 0
    with open(out1, "w") as f:
        for line in file:
            content = line.split()
            RNA_structure = RNA_structure_new = content[10] # RNA structure -- .() --
            Sequence = Sequence_new = content[9] #RNA bases  -- AUGC --
            Pre_sRNA_start = content[6] #Pre_sRNA_start_position
            pre_sRNA_end = content[7] #sRNA_start_position
            sRNA_end = content[1] #sRNA_start_position
            sRNA_end = content[2] #sRNA_start_position
            Strand = content[3] #strand_direction
            count = 0
            maxl = maxr = -1
            flag = -1
            max_l = 0
            for i in range(0, len(RNA_structure)):  #iter RNA structure
                if RNA_structure[i] == "." or RNA_structure[i] == "(":  # when not meet ), go on iterating structures
                    l = i
                    while i < len(RNA_structure) and RNA_structure[i] != ")":
                        i = i + 1
                    while i < len(RNA_structure) and RNA_structure[i] != "(":  # when meeting ), go on, find the right (, meaning the former is a circle.
                        i = i + 1
                    r = i
                if max_l < r - l:
                    max_l = r - l
                    maxl = l
                    maxr = r

            if max_l < len(RNA_structure):
                count = count + 1
            if Strand == '+':  # basing on the strand, transform the algorithm to suit.
                print(pre_sRNA_end,maxr)
                pre_sRNA_end = int(Pre_sRNA_start) + maxr
                Pre_sRNA_start = int(Pre_sRNA_start) + maxl
                RNA_structure_new = RNA_structure[maxl:maxr]
                Sequence_new = Sequence[maxl:maxr]
            else:
                pre_sRNA_end = int(pre_sRNA_end) - maxl
                Pre_sRNA_start = int(Pre_sRNA_start) + 100 - maxr
                RNA_structure_new = RNA_structure[maxl:maxr]
                Sequence_new = Sequence[maxl:maxr]
            new_conent = content[0] + "\t" + content[1] + "\t" + content[2] + "\t" + content[3] + "\t" + content[4] + "\t" + content[5] + "\t" + str(Pre_sRNA_start) + "\t" + str(pre_sRNA_end) + '\t' + Strand + "\t" + Sequence_new + '\t' + RNA_structure_new + '\n'
            # print(num, max_l, maxr)
            f.write(new_conent)
            num = num + 1
