import sys, pdb

if len(sys.argv) != 3:
    print("wrong arguments\n")
    sys.exit(1)

def modificaArq(input_file, output_file):
    old_str = "  static mapaTotal + " 
    old_com = "  ;Linha"
    i = 0
    com = 0
    
    with open(input_file, "r+") as file:
        lines = file.readlines()
    
    with open(output_file, "w") as file:
        for line in lines:
            if old_str in line:
                line = f"  static mapaTotal + #{i}, {line.split(', ')[1]}"
                i += 1
            elif old_com in line:
                line = f"  ;Linha {com}\n"
                com += 1
            file.write(line)
        file.seek(0)
        for line in lines:
            line = f"mapaTotal : var #{i}\n"
            file.write(line)
            break

modificaArq(sys.argv[1], sys.argv[2])