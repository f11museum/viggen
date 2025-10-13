target_properties = ["_top_s1", "_top_s2", "_top_t1", "_top_t2","_bot_s1", "_bot_s2", "_bot_t1", "_bot_t2"]
wing_numbers = [1,3,5,7,9]

def collect_target_wing_data(filename, target_properties):
    """Collect values for target properties from odd-numbered wings."""
    wing_data = {}
    with open(filename, 'r') as file:
        for line in file:
            parts = line.strip().split()
            if len(parts) >= 3 and "_wing/" in parts[1]:
                wing_split = parts[1].split('/')
                if len(wing_split) > 2 and wing_split[1].isdigit():
                    wing_num = int(wing_split[1])
                    prop_name = wing_split[-1]
                    if wing_num % 2 == 1 and prop_name in target_properties and wing_num in wing_numbers:
                        if wing_num not in wing_data:
                            wing_data[wing_num] = {}
                        wing_data[wing_num][prop_name] = parts[2]
    return wing_data

def replace_target_wing_data(input_file, output_file, wing_data, target_properties):
    """Replace values in even-numbered wings for target properties."""
    with open(input_file, 'r') as infile, open(output_file, 'w') as outfile:
        for line in infile:
            parts = line.strip().split()
            if len(parts) >= 3 and "_wing/" in parts[1]:
                wing_split = parts[1].split('/')
                if len(wing_split) > 2 and wing_split[1].isdigit():
                    wing_num = int(wing_split[1])
                    prop_name = wing_split[-1]
                    if wing_num % 2 == 0 and prop_name in target_properties:
                        source_wing = wing_num + 1
                        if source_wing in wing_data and prop_name in wing_data[source_wing]:
                            new_value = wing_data[source_wing][prop_name]
                            line = f"{parts[0]} {parts[1]} {new_value}\n"
            outfile.write(line)


def process_wing_file(input_file, output_file):
    
    wing_data = collect_target_wing_data(input_file, target_properties)
    replace_target_wing_data(input_file, output_file, wing_data, target_properties)

# Example usage
process_wing_file('B37_xp12.acf', 'output.txt')
