library verilog;
use verilog.vl_types.all;
entity ripUp is
    port(
        b0              : out    vl_logic;
        b1              : out    vl_logic;
        b2              : out    vl_logic;
        b3              : out    vl_logic;
        clk             : in     vl_logic;
        rst             : in     vl_logic
    );
end ripUp;
