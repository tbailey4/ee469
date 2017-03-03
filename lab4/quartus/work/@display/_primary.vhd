library verilog;
use verilog.vl_types.all;
entity Display is
    generic(
        B               : vl_logic_vector(0 to 6) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi1);
        C               : vl_logic_vector(0 to 6) := (Hi1, Hi0, Hi0, Hi0, Hi1, Hi1, Hi0);
        E               : vl_logic_vector(0 to 6) := (Hi0, Hi0, Hi0, Hi0, Hi1, Hi1, Hi0);
        F               : vl_logic_vector(0 to 6) := (Hi0, Hi0, Hi0, Hi1, Hi1, Hi1, Hi0);
        G               : vl_logic_vector(0 to 6) := (Hi0, Hi0, Hi1, Hi0, Hi0, Hi0, Hi0);
        H               : vl_logic_vector(0 to 6) := (Hi0, Hi0, Hi0, Hi1, Hi0, Hi0, Hi1);
        I               : vl_logic_vector(0 to 6) := (Hi1, Hi0, Hi0, Hi1, Hi1, Hi1, Hi1);
        O               : vl_logic_vector(0 to 6) := (Hi1, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0);
        P               : vl_logic_vector(0 to 6) := (Hi0, Hi0, Hi0, Hi1, Hi1, Hi0, Hi0);
        S               : vl_logic_vector(0 to 6) := (Hi0, Hi0, Hi1, Hi0, Hi0, Hi1, Hi0);
        blank           : vl_logic_vector(0 to 6) := (Hi1, Hi1, Hi1, Hi1, Hi1, Hi1, Hi1)
    );
    port(
        UPC             : in     vl_logic_vector(2 downto 0);
        HEX0            : out    vl_logic_vector(6 downto 0);
        HEX1            : out    vl_logic_vector(6 downto 0);
        HEX2            : out    vl_logic_vector(6 downto 0);
        HEX3            : out    vl_logic_vector(6 downto 0);
        HEX4            : out    vl_logic_vector(6 downto 0);
        HEX5            : out    vl_logic_vector(6 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of B : constant is 1;
    attribute mti_svvh_generic_type of C : constant is 1;
    attribute mti_svvh_generic_type of E : constant is 1;
    attribute mti_svvh_generic_type of F : constant is 1;
    attribute mti_svvh_generic_type of G : constant is 1;
    attribute mti_svvh_generic_type of H : constant is 1;
    attribute mti_svvh_generic_type of I : constant is 1;
    attribute mti_svvh_generic_type of O : constant is 1;
    attribute mti_svvh_generic_type of P : constant is 1;
    attribute mti_svvh_generic_type of S : constant is 1;
    attribute mti_svvh_generic_type of blank : constant is 1;
end Display;
