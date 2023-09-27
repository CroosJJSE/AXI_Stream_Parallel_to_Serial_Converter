module p2s #(N = 8)(
  input logic clk, rstn, s_ready, p_valid, 
  input logic [N-1:0] p_data,
  output logic p_ready, s_data, s_valid
);
  enum logic {RX=0, TX=1} state, next_state;
  logic [$clog2(N)-1:0] count;
always_comb
  unique case (state)
    RX: next_state = p_valid ? TX : RX;
    TX: next_state = count==N-1 && s_ready ? RX : TX;
  endcase
always_ff @(posedge clk or negedge rstn)
    state <= !rstn ? RX : next_state;
  
logic [N-1:0] shift_reg;
assign s_data = shift_reg[0];
assign p_ready = (state == RX);
assign s_valid = (state == TX);
always_ff @(posedge clk or negedge rstn)
    if (!rstn) count <= '0;
  else
      unique case (state)
      RX: shift_reg <= p_data;
      TX: if (s_ready) begin
      shift_reg <= shift_reg >> 1;
      count <= count + 1’d1;
      end
endcase
endmodule
