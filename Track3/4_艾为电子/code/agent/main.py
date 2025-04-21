import asyncio
import argparse
import traceback
import platform
from agent_get_req import get_requirement
from agent_init import generatingNL_init
from agent_opt import generatingNL_optimize
from agent_index_judgment import index_judgment
from common_method import backup_directories
from common_method import comparison_sim_result_info
from common_method import delete_history_files
from agent_add_comment import addComment
import config

if __name__ == "__main__":
    """
    The entry point of the script, allowing it to run in different modes.
    Parses command line arguments to determine the running mode, initializes configurations based on the operating system,
    and executes corresponding asynchronous operations based on the mode.
    """
    
    # Initialize the command line argument parser
    parser = argparse.ArgumentParser(description="Run the script in different modes.")
    parser.add_argument("--mode", choices=["custom", "default"], required=True, help="Specify the mode to run: 'custom' or 'default'")
    args = parser.parse_args()
    
    # Call the function to delete history files, assuming this function is defined elsewhere
    delete_history_files()
    
    # Initialize the counter
    count_num = 0
    
    # Determine the current operating system and set the system version configuration
    current_os = platform.system()
    if current_os == "Windows":
        config.SYSTEMVER = "Windows"
    else:
        config.SYSTEMVER = "Linux"
    
    
    try:
        # Execute different asynchronous operations based on the command line specified mode
        if args.mode == "custom":
            asyncio.run(get_requirement(custom=True))
        elif args.mode == "default":
            asyncio.run(get_requirement(custom=False))
        else:
            parser.error("Invalid mode. Please choose either 'custom' or 'default'.")
        
        # Execute the initialization generation asynchronous operation
        asyncio.run(generatingNL_init())
        # Use a loop to repeatedly check the results and perform corresponding operations until the conditions are met or the number of attempts exceeds the limit
        while True:
            check_result = asyncio.run(comparison_sim_result_info())
            if not check_result and count_num <= 50:
                asyncio.run(index_judgment())
                asyncio.run(generatingNL_optimize(count_num))
                count_num += 1
            elif check_result:
                asyncio.run(addComment(count_num))
                break
            else:
                break
        
    except Exception as e:
        # Print the exception information
        traceback.print_exc()
        print(f"An error occurred: {str(e)}")
    finally:
        # Call the function to back up directories, assuming this function is defined elsewhere
        backup_directories()