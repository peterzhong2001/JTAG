# JTAG

## Overview
Joint Test Action Group (JTAG) is an industry standard for testing PCBs after they are manufactured. In a complicated electrical chip, it can be difficult to
test individually the functionality of different components and the validity of inter-component connections. Therefore, JTAG implements chains of boundary scan registers to serially shift in/out test data into different locations on the chip. The input data is accepted through the Test Data In (TDI) port, and the output data is read from the Test Data Out (TDO) port.

A series of additional instruction registers are used to update user instructions to the instruction decoder. The decoder will then synchronously provide the current test mode and chain selection information to the boundary scan chains. A TAP (Test Access Port) module controls the operation of both the boundary scan registers and the instruction registers (shifting, clocking, updating), and sends control signals accordingly when different operations are requested through the Test Mode Select (TMS) port.

**To load this project onto a DE1_SoC board:**\
&nbsp;&nbsp;&nbsp;&nbsp;1. Download the entire repository\
&nbsp;&nbsp;&nbsp;&nbsp;2. Open DE1_SoC.qpf in Quartus Prime\
&nbsp;&nbsp;&nbsp;&nbsp;3. Compile the project with DE1_SoC.sv as the top-level entity\
&nbsp;&nbsp;&nbsp;&nbsp;4. Power on your DE1_SoC board and connect your DE1_SoC board to your computer via USB\
&nbsp;&nbsp;&nbsp;&nbsp;5. In Quartus, go to File > Open, and open the programming file (cdf) generated by Quartus\
&nbsp;&nbsp;&nbsp;&nbsp;6. Once the programming window pops up, hit "run" to load the design onto the FPGA

## Files in the Project
### Top-Level Modules
**DE1_SoC.sv:** the top-level module for FPGA emulation. It instantiates a jtag_top module (contained in the jtag_top_new.sv file, and it also uses an input_processing module to clean up the TCK input provided by the user on KEY0.\
**jtag_top_new.sv:** top-level module that instantiates and connects all the JTAG components.
### TAP Controller
**tap_state_machine.sv:** a 18-state FSM used to control the operations of the JTAG module. It takes serial input data from the TMS port and updates control signals (clock, shift, update, etc.) accordingly.
### Boundary Scan Operation Modules
**BSC_chain.sv:** an individual boundary scan chain. It generates boundary scan cells based on the parameter chain_length.\
**singleBSC.sv:** a single boundary scan cell that is capable of both parallel loading and serial loading. It sends data into the system logics when update_dr is pulsed. \
**BSR_decoder.sv:** a parametrized decoder that is used to enable one selected scan chain. This is to make sure that the control signals only go into the selected/active scan chain in the module.\
**BSR_mux.sv:** a parametrized mux that only accepts the serial output data from the currently selected boundary scan chain.
### Instruction Registers Modules
**instr_decode.sv:** a decoder that takes in data from the instruction registers and outputs corresponding instructions to control scan chain selection and test mode. \
**instruction_register.sv:** top-level instruction register module that instantiates both instruction_cell modules and update_ir_cell modules.\
**instruction_cell.sv:** registers placed before the instruction decoder. They are mainly used to serially shift in instruction data to the instruction decoder.\
**update_ir_cell.sv:** registers placed at the outputs of the instruction decoder. They are mainly used to update instruction data when update_ir signal pulses, and they are also used to keep the outputs of the instruction decoder synchronous.
### Other Modules
**input_processing.sv:** makes the user's button press only active for one cycle regardless of hold duration.\
**test_ands.sv:** an "and" gate. It is used as a piece of system logic in the JTAG module for testing purposes.\
**test_fsm.sv:** a simple FSM. It is used as a piece of system logic in the JTAG module for testing purposes.


## Improvements Made
### 1. Bypass Functionality
The original intention of the bypass registers is to provide a shortest serial path for data when only certain parts of the board need to be tested. In other words, bypass registers can provide quicker access to specific components on the board. However, in the JTAG module in this repository, the scan chains for different components are not all connected serially. Instead, these scan chains are generated in parallel and are selected by the BSR decoder and the BSR mux (further description is provided in the "BSR Decoder" section below). Therefore, only one scan chain will be enabled at a time, and the shortest serial path is always guaranteed. Therefore, I simply implemented the bypass registers in this JTAG module as a bypass function. Specifially, when the TAP controller is in the Test-Logic-Reset state, the data at TDI port is directly forwarded to the TDO port.

### 2. BSR Decoder
Since all the scan chains operates in parallel and accepts control signals at the same time, lack of an enable signal can lead to unwanted operations in certain scan chains when they are not active. In order to only send control signals into the currently selected scan chain, I implemented the BSR decoder to take in chain selection signals output an enable signal to each of the scan chains. 

### 3. Instruction Registers
In the original implementation of the instruction registers, the clock_ir DFFs and the update_ir DFFs are all placed before the instruction decoder. This is a working design, but it can cause delay in the output signals since the instruction decoder will take some amount of time to process the input data. Therefore, the original implementation of the instruction registers and the asynchronous nature of the outputs of the instruction decoders can be potentially glitchy and cause problem to the overall operation of the JTAG module.

I reimplemented the intruction registers so that the instruction decoder is placed in between the clock_ir DFFs and the update_ir DFFs. This implementation updates the outputs of the instruction decoder immediately when update_ir is pulsed, which makes the operations of the instruction register in accordance to the IEEE standard. [Here](https://imgur.com/a/q2ro6o0) is the block diagram for an instruction register according to the IEEE standard. 

## Acknowledgements
All the SystemVerilog code files in this repository are my project as an undergraduate research assistant at PSyLab (Processing Systems Lab) with Prof. Visvesh Sathe. The original JTAG code was provided by my supervisor Yuan Liao, who also provided me ample guidance through the process of learning the functionality of the JTAG module and implementing the improvements. 
