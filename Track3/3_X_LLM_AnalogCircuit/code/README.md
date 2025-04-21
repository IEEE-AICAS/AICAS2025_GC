# Operational Amplifier Circuit Design Agent

## Overview
This agent for operational amplifier circuit design simulations with configurable parameters.

## Command Line Arguments

| Argument | Type | Default Value | Description |
|----------|------|---------------|-------------|
| `--gain` | float | 60 | Gain requirement (dB) |
| `--gbw` | float | 20 | Gain bandwidth product requirement (MHz) |
| `--pm` | float | 60 | Phase margin requirement (degrees) |
| `--sr` | float | 20 | Slew rate requirement (V/μs) |
| `--idc` | float | 500 | Current requirement (μA) |

## Usage Example
```bash
python agent/main.py \
    --gain 60 \
    --gbw 20 \
    --pm 60 \
    --sr 20 \
    --idc 500
