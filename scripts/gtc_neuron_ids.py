import json
import subprocess

# File paths
input_file_path = "gtc_accounts.json"
master_file_path = "gtc_accounts_master.json"

# Load the input data
with open(input_file_path, 'r') as f:
    data = json.load(f)

# Begin with an empty master list
master_data = []

# For each item in the data, execute the given command
for item in data:
    print(item)
    # Construct the command
    cmd = [
        'dfx', 'canister', '--network=ic', 'call',
        'renrk-eyaaa-aaaaa-aaada-cai', '--candid', 'gtc.did',
        'get_account', f'("{item}")'
    ]
    
    # Execute the command and capture the output
    dfx_process = subprocess.Popen(cmd, stdout=subprocess.PIPE)
    result = subprocess.check_output(["idl2json"], stdin=dfx_process.stdout)
    dfx_process.wait()
    
    # Convert the output to JSON
    result_json = json.loads(result)
    
    # If 'Ok' is present in the result
    if "Ok" in result_json:
        # Add the item under the "account" key
        result_json["Ok"]["account"] = item
        master_data.append(result_json["Ok"])

# Save the merged data to the master file
with open(master_file_path, 'w') as f:
    json.dump(master_data, f, indent=4)

print(f"Data processing complete. Results saved to {master_file_path}.")

