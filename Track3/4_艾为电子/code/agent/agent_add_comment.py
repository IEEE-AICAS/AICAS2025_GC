import os
# import asyncio

from common_method import callmodel_async
from common_method import read_prompt_file
from common_method import read_result_file
from common_method import read_netlist_file
from common_method import write_string_to_file
from common_method import str2spice
from common_method import simulation
from common_method import backup_file

async def addComment(round_num):
    """
    Asynchronously adds comments to a circuit design based on AI-generated results.

    This function reads a prompt from a file, obtains a netlist based on the round number,
    and uses an AI model to generate new content. It then writes the processed netlist string
    to a file and backs up the final netlist file.

    Parameters:
    - round_num (int): The round number of the circuit design, used to locate the corresponding netlist file.

    Returns:
    None
    """
    # Read the prompt content for adding comments from the file
    prompt_add_comment = await read_prompt_file("prompt_add_comment.txt")
    
    # get netlist
    netlist = await get_netlist(round_num)
    # Call the AI model to generate content based on the prompt and netlist
    ai_result = await callmodel_async(prompt_add_comment, netlist)
    # Convert the generated AI result to a SPICE netlist string format
    netlist_str = await str2spice(ai_result)
    # Write the processed netlist string to a file
    write_result = await write_string_to_file("../netlist/AMP.cir", netlist_str)
    # Get the path of the last version of the netlist file
    last_netlist = os.path.join(os.path.dirname(__file__), '..', 'netlist', 'AMP.cir')
    # Back up the final version of the netlist file
    await backup_file(last_netlist, "Final")
    
# get netlist
async def get_netlist(round_num):
    """
    Asynchronously retrieves the netlist for a specific round.

    This function reads the netlist file corresponding to the round number and returns its content.

    Parameters:
    - round_num (int): The round number of the circuit design, used to locate the corresponding netlist file.

    Returns:
    - netlist (str): The content of the netlist file.
    """
    # Read and return the netlist content based on the round number
    netlist = await read_netlist_file(f"AMP_{round_num}.cir")
    
    return netlist
