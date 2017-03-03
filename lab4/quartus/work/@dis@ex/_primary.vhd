library verilog;
use verilog.vl_types.all;
entity DisEx is
    port(
        D               : out    vl_logic;
        E               : out    vl_logic;
        U               : in     vl_logic;
        P               : in     vl_logic;
        C               : in     vl_logic
    );
end DisEx;
