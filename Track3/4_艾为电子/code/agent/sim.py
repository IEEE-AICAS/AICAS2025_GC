import asyncio

from common_method import simulation

async def sim_func():
    selections = ['CMRR', 'PSRR', 'noise']
    await asyncio.gather(*(simulation(selection, b=True) for selection in selections))
    corners = ['FF', 'FS', 'SF', 'SS', 'TT']
    selections = ['AC', 'SR', 'IDC']
    await asyncio.gather(*(simulation(selection, corner=corner, b=True) for selection in selections for corner in corners))
    
asyncio.run(sim_func())