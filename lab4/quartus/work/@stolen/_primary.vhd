library verilog;
use verilog.vl_types.all;
entity Stolen is
    port(
        S               : out    vl_logic;
        E               : in     vl_logic;
        M               : in     vl_logic
    );
end Stolen;
