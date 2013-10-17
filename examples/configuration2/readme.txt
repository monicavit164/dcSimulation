
This example simulates the monitoring and assessment of a data center with two servers running three virtual machines. Server S1 runs VM1 and VM3, while server S2 runs VM2.

The load has been increased separately for each VM in four steps:

- step 1: load increasing at each step for VM1, load at VM2 and VM3 is constant
- step 2: load increasing at each step for VM2, load at VM1 and VM3 is constant
- step 2: load increasing at each step for VM2, load at VM1 and VM2 is constant
- step 3: load increasing at each step for both VM1, VM2, and VM3

To run the example just run loadSimulation.m.
