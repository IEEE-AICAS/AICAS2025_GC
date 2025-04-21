import math

# Process Parameters
I0_uA = 9.24
S5 = 4.44

# Initialize L with the simplest integer, L=x
L = 1  # You can change this to any integer value you prefer

KP_AVG1 = 301.48
KP_AVG2 = 82.35

# Calculate IB in Amperes and convert it to microamperes
IB = I0_uA / 6
IB = IB * 1e-6

# Calculate RS using the formula
RS = math.sqrt(1 / (16 * IB * KP_AVG1 * 1e-6))

# Calculate S10, S11, S9, S12, and S13
S10 = (2 * IB * 1e-6 / (KP_AVG2 * 1e-6) / 0.04) * 1e6
S11 = S10
S9 = S10
S12 = S5
S13 = S12

# Create a dictionary to store the netlist parameters
netlist = {
    "S9": f"{S9:.2f}/{L}",
    "S10": f"{S10:.2f}/{L}",
    "S11": f"{S11:.2f}/{L}",
    "S12": f"{S12:.2f}/{L}",
    "S13": f"{S13:.2f}/{L}",
    "R2": f"{RS:.2f}"
}

# Write the netlist parameters to a file
with open("/mnt/c/llm/LLM4AMP/agent/netlist_para.txt", "w") as file:
    for key, value in netlist.items():
        file.write(f"{key}: {value}\n")