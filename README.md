# JTAG
*Additional Documentation Still in Progress*

## Overview
Joint Test Action Group (JTAG) is an industry standard for testing PCBs after they are manufactured. In a complicated electrical chip, it can be difficult to
test individually the functionality of different components and the validity of inter-component connections. Therefore, JTAG implements chains of boundary scan registers to serially shift in/out test data into different locations on the chip. The input data is accepted through the Test Data In (TDI) port, and the output data is read from the Test Data Out (TDO) port.

A series of additional instruction registers are used to update user instructions to the instruction decoder. The decoder will then synchronously provide the current test mode and chain selection information to the boundary scan chains. A TAP (Test Access Port) module controls the operation of both the boundary scan registers and the instruction registers (shifting, clocking, updating), and sends control signals accordingly when different operations are requested through the Test Mode Select (TMS) port.

## Improvements Made
### 1. Bypass Registers
Motivation: the original intention of the bypass registers is to provide a shortest serial path for data when only certain parts of the board need to be tested. In other words, bypass registers can provide quicker access to specific components on the board. However, in the JTAG module in this repository, the scan chains for different components are not all connected serially. Instead, these scan chains are generated in parallel and are selected by the BSR decoder and the BSR mux (further description is provided in the "BSR Decoder" section below). Therefore, only one scan chain will be enabled at a time, and the shortest serial path is always guaranteed. Therefore, the bypass registers is simply implemented as a bypass function in this JTAG module. Specifially, when the TAP controller is in the Test-Logic-Reset state, the data at TDI port is directly forwarded to the TDO port.

### 2. BSR Decoder


### 3. Instruction Registers

## Acknowledgements
All the SystemVerilog code files in this repository are my project as an undergraduate research assistant at PSyLab (Processing Systems Lab) with Prof. Visvesh Sathe. The original JTAG code was provided by my supervisor Yuan Liao, who also provided me ample guidance through the process of learning the functionality of the JTAG module and implementing the improvements. 
