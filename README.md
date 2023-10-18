# AXI_Stream_Parallel_to_Serial_Converter
parameterized parallel to serial converter which is used in many modern devices.

# What is AXI?
AXI (Advanced eXtensible Interface) is a popular and widely-used high-performance communication protocol (Bus architecture) in the field of **digital system design**, especially in the context of designing complex integrated circuits, system-on-chip (SoC) architectures, and FPGAs (Field-Programmable Gate Arrays).
It has **valid** and **ready** _interfaces._
- module is receiving the **valid** as input if you're giving data you have to keep the **valid** **high** in the **same** clock of sampling.
- if valid is low data is a trash
- module is giving the output **ready** if he is ready to accept.
- if both valid and ready are high the transaction will happen.

### **Master-Slave Communication:**

AXI operates in a master-slave configuration. Masters are the components that initiate transactions, while slaves respond to these transactions. 
Transactions can include 
- reads,
- writes,
- and other control signals.

# This is the module, we are going to implement

![image](https://github.com/CroosJJSE/AXI_Stream_Parallel_to_Serial_Converter/assets/141708783/56f66ea7-e32d-4247-87b5-8d93718d6d42)

we can explain it as two states
# 1. RX  if p_valid is high
1. we set **p_ready** as **high**,  // acknoledge that sender can send the data
2. 2.**s_valid** as **low**            // acknowledge that the reader cant read now
3. and we **copy** p_data to a shift register

# 2. TX 
1. s_valid is high //tellig that we are sending data
2. p_reeady is low // telling that cant take input right now.

```
if s_ready is high // if can send data 
then we can shift the data // because the last bit of the shift register will be connected to output
else, we can wait. // no shifting
```

for more understanding 

![image](https://github.com/CroosJJSE/AXI_Stream_Parallel_to_Serial_Converter/assets/141708783/ca4e747d-1127-41a8-baac-98b88d256edc)



here we are following the three stage coding style which is suitable for high complex logic


![image](https://github.com/CroosJJSE/AXI_Stream_Parallel_to_Serial_Converter/assets/141708783/b1cec71e-064d-4ed6-aff1-248a10f1aef9)

# NEXT STATE DECODER
state is a register to store the current state value and state_next is combinational wire. In Next state decorder we calculate the next state using the inputs. we check the par_valid,ser_ready to determine the next state


![image](https://github.com/CroosJJSE/AXI_Stream_Parallel_to_Serial_Converter/assets/141708783/e717c199-3c60-42e6-8d01-455562a93266)

# STATE SEQUENCER
in this block, in each clock cycle the data in the next_state will be copied to state register.


![image](https://github.com/CroosJJSE/AXI_Stream_Parallel_to_Serial_Converter/assets/141708783/8e85c05e-c1f0-44ab-ac27-c62ff35c4036)
# OUTPUT DECODER
after we receive the value of the state, we will execute the action or output which has to be done in that state.


![image](https://github.com/CroosJJSE/AXI_Stream_Parallel_to_Serial_Converter/assets/141708783/87b9a61c-2a31-4d01-bab3-1a2920292e19)

# simulation analysis

we copy the 8 bit input to the shift register only when par_valid is high.

![image](https://github.com/CroosJJSE/AXI_Stream_Parallel_to_Serial_Converter/assets/141708783/f55c87a7-1301-4c9d-9fd5-66b4d346a776)



we are sending data only when is ser_valid is high to avoid conjestion 

![image](https://github.com/CroosJJSE/AXI_Stream_Parallel_to_Serial_Converter/assets/141708783/8b961b34-aeb6-4ee4-abce-18c9d00454a4)
