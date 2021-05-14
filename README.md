# JTAG
*Additional Documentation Still in Progress*

## Overview
JTAG (Joint Test Action Group) is an industry standard for testing PCBs after they are manufactured. In a complicated electrical chip, it can be difficult to
test each component individually. Therefore, JTAG implements boundary scan registers to serially shift in/out test data into the ports on the chip. These registers form
boundary scan chains, and each chain is responsible for the I/O ports of one component on the chip.

A series of additional instruction registers are used to update instructions to the instruction decoder. The decoder will provide the current mode and chain selection information
to the boundary scan chains. A TAP (Test Access Port) module controls the operation of both the boundary scan registers and the instruction registers(shifting, clocking, 
updating, etc).

## Improvements Made
1. BSR Decoder
2. Instruction Decoder
3. 

## Acknowledgements
This is my project as an undergraduate research assistant at PSyLab (Processing Systems Lab) with Prof. Visvesh Sathe from mid February to mid May of 2021.
The original JTAG code was provided by my supervisor Yuan Liao, who also provided me ample guidance through the process of learning the functionality of the JTAG module
and implementing the improvements. 
