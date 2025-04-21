import math

L = 1  # Initialize L with the simplest integer

CL_pF = 2
SR_value = 20e6
GBW = 20e6
VDD = 1.8 
VSS = 0  
K_PN = 279e-6 
K_PP = 76e-6
V_THP_MAX = 0.98
V_THN_MAX = 0.76
V_THN_MIN = 0.66
V_CM_min = 0.8
V_CM_max = 1.6
CL = 2e-12

netlist = {}

C_C_pF = 0.22 * CL_pF
C_C = C_C_pF * 1e-12
C1 = C_C_pF

I0 = C_C * SR_value
I0_uA = I0 * 1e6

voltage_term = VDD - V_CM_max - abs(V_THP_MAX) + V_THN_MIN
S3 = I0 / (K_PP * voltage_term**2)
S4 = S3

gm1 = 2 * math.pi * GBW * C_C
S1 = (gm1**2) / (K_PN * I0)

S2 = S1

sqrt_term = math.sqrt(I0 / (K_PN * S1))
V_DS5 = V_CM_min - VSS - sqrt_term - V_THN_MAX
S5 = (2 * I0) / (K_PN * V_DS5**2)
S8 = S5

gm6 = 10 * gm1
CL_total = C_C + CL
R1 = 1 / (gm6 * (C_C / CL_total))

gm4 = math.sqrt(K_PP * S3 * I0)
S6 = S3 * (gm6 / gm4)

I6 = (gm6**2) / (2 * K_PP * S6)
S7 = S5 * (I6 / I0)

netlist["S1"] = f"{S1:.2f}/{L}"
netlist["S2"] = f"{S2:.2f}/{L}"
netlist["S3"] = f"{S3:.2f}/{L}"
netlist["S4"] = f"{S4:.2f}/{L}"
netlist["S5"] = f"{S5:.2f}/{L}"
netlist["S6"] = f"{S6:.2f}/{L}"
netlist["S7"] = f"{S7:.2f}/{L}"
netlist["S8"] = f"{S8:.2f}/{L}"
netlist["C1"] = f"{C1:.2f}"
netlist["R1"] = f"{R1:.2f}"
netlist["I0_uA"] = f"{I0_uA:.2f}"

with open("/mnt/c/llm/LLM4AMP/agent/netlist_para.txt", "w") as file:
    for key, value in netlist.items():
        file.write(f"{key}: {value}\n")