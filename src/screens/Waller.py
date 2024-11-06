import pdb
import sys

def wallScript(input_file, output_file):
    coords = [[0, 17, 19], [0, 21, 25], [1, 18, 26], [2, 19, 25], [3, 18, 24],
              [4, 19, 20], [9, 13, 13], [10, 12, 14], [11, 10, 10], [11, 13, 15],
              [11, 18, 19], [12, 7, 13], [12, 19, 20], [13, 6, 14], [14, 6, 13],
              [15, 7, 10]]

    cor_index = 0

    y = 0
    x = 0
    strCount = "static mapProp +"

    with open(input_file, "r+") as file:
        lines = file.readlines()
        
    #pdb.set_trace()
    with open(output_file, "w") as file:
        for line in lines:
            if strCount in line:
                if cor_index < len(coords) and y == coords[cor_index][0] and coords[cor_index][1] <= x <= coords[cor_index][2]:
                    line = f"{line.split(', ')[0]}, #3\n"
                    
                    if x == coords[cor_index][2]:
                        cor_index += 1

                x += 1
                if x == 40:
                    y += 1
                    x = 0
            file.write(line)

wallScript(sys.argv[1], sys.argv[2])