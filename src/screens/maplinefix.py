import sys, pdb

if len(sys.argv) != 3:
    print("wrong arguments\n")
    sys.exit(1)

def modificaArq(input_file, output_file):
    old_str = "static mapCoord +" 
    i = 0
    
    with open(input_file, "r+") as file:
        lines = file.readlines()
    
    with open(output_file, "w") as file:
        for line in lines:
            if old_str in line:
                line = f"  static mapCoord + #{i}, #0\n"
                i += 1
            file.write(line)

modificaArq(sys.argv[1], sys.argv[2])