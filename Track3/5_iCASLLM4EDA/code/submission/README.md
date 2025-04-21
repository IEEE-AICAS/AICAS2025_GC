# README for Reproduction and Test
### Team:iCASLLM4EDA 
### Organization: Shanghai Jiao Tong University

Our scripts are in the /root/submission folder. Before running the scripts, please activate the environment:
>conda activate qwenagent

Then run different codes through basic requirement reproduction (See Section I) and arbitrary requirements reproduction of one of five metrics (See Section II).

Please don't delete any of the folders or files under /root.

## Section I. Basic Requirement Reproduction

This section is to describe how to generate the submit.zip file satisfying all metric requirements. The corresponding script is /root/submission/agent/main.py, however, since its runtime is measured by /root/submission/monitor.py, **please run the script under /root/submission instead of /root/submission/agent**, or some path errors will occur.

Run these commands:
>cd /root/submission  
python monitor.py --mode final

Then wait for about five or six minutes to generate the AMP.cir and monitor_results.json under /root/submission. Then run the command

> zip submit.zip AMP.cir monitor_results.json

to get the submission format.


## Section II. Arbitrary Requirements Reproduction of One of Five Metrics

For testing the performance with specific ungiven requirements of five metrics, the script is slightly different from above but still use the same prompts as Section I. The python script is /root/submission/agent/main_givenMetrics.py. To run this, **please first go to the /root/submission/agent folder.**
>cd /root/submission/agent

Then run
>python main_givenMetric.py

**If run this under /root/submission, some path errors may occur.**

In this script, users can determine one of five metrics in Gain, GBW, PM, SR and IDC. The input hint is like:
>"Please set Gain（Please make sure its unit is：dB，if this metric is not to be set, directly press ENTER to skip）："

**Please only set one of the five metrics in one run.**
If this metric doesn't need to be set, just press ENTER to skip it. 

The units of the given metrics are:
| Metric  |Unit  |
| --------| ----:|
| Gain    | dB   |
| GBW     | MHz  |
| PM      |degree|
| SR      |V/uS  |
| IDC     |uA    |

**Please make sure you give specific metrics in the correct unit.**

Please note the result of this section is under **/root/submission/agent/AMP.cir, which is different from the AMP.cir in Section I.**

Some of the indicators that work for our self-test are:
| Metric  |Available Range  |
| --------| ---------------:|
| Gain    | 60-75           |
| GBW     | 20-30           |
| PM      | 60-80           |
| SR      | 20-70           |
| IDC     | 350-400         |
If the given metric is under one of these ranges, the agent can always generate a netlist satisfying this requirement. Numbers out of these ranges may work but are not tested.

If there is any question in reproduction, please contact us.
  
**iCASLLM4EDA(Xinyue Wu, Fan Hu, Jani Babu Shaik, Zijiao Zhang and Linyu Zhu)  
2025.3.23**