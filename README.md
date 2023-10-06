# AXI_Stream_Parallel_to_Serial_Converter
parameterized parallel to serial converter which is used in many modern devices.

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


# simulation analysis

we copy the 8 bit input to the shift register only when par_valid is high.

![image](https://github.com/CroosJJSE/AXI_Stream_Parallel_to_Serial_Converter/assets/141708783/f55c87a7-1301-4c9d-9fd5-66b4d346a776)



we are sending data only when is ser_valid is high to avoid conjestion 

![image](https://github.com/CroosJJSE/AXI_Stream_Parallel_to_Serial_Converter/assets/141708783/8b961b34-aeb6-4ee4-abce-18c9d00454a4)
