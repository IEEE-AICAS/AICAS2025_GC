from config import config_arg
from Agent_simulation import gene_scr_result_path, update_scr, get_simulation_result
import time 


start_time = time.time()
args = config_arg()
results = {}
for corner in ['ff', 'fs', 'sf', 'ss', 'tt']:
    paths = gene_scr_result_path(args, corner, 'over_test', None)
    update_scr(paths, args, corner)
    results = get_simulation_result(args, paths, 'over_test', None, results, corner)
    print(results)
end_time = time.time()
print(end_time - start_time)