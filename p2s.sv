module p2s #(N = 8)
(
    input logic clk, rstn, ser_ready, par_valid, 
    input logic [N-1:0] par_data,
    output logic par_ready, ser_data, ser_valid
);

localparam N_BITS = $clog2(N); // Calculate the number of bits required to represent N
enum logic {RX=0, TX=1} next_state, state; // Define state enumeration (RX and TX)
logic [N_BITS-1:0] count; // Counter for tracking the number of bits processed
logic [N -1:0] shift_reg; // Shift register for storing parallel data

always_comb begin
    unique case (state)
        RX: next_state = par_valid ? TX : RX; // If valid parallel data is available, transition to TX state
        TX: next_state = ser_ready && count==N-1 ? RX : TX; // If serial ready and all bits transmitted, transition to RX state
    endcase
end

always_ff @(posedge clk or negedge rstn) begin
    state <= !rstn ? RX : next_state; // Synchronous state transition logic with reset
end

assign ser_data = shift_reg[0]; // Assign the first bit of the shift register as serial data
assign par_ready = (state == RX); // Parallel ready signal is high when in RX state
assign ser_valid = (state == TX); // Serial valid signal is high when in TX state

always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) count <= '0; // Reset the count if reset is active
    else begin
        unique case (state)
            RX: begin
                shift_reg <= par_data; // Load parallel data into the shift register in RX state
                count <= '0; // Reset count
            end
            TX: if (ser_ready) begin
                shift_reg <= shift_reg >> 1; // Shift right the shift register in TX state
                count <= count + 1'd1; // Increment count to track the number of bits transmitted
            end
        endcase
    end
end

endmodule
