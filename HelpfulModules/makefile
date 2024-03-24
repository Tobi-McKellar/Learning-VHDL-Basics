# Set the VHDL compiler and simulator
VHDL_COMPILER = ghdl
SIMULATOR = ghdl

#Package for pnr
PACKAGE = qn84

# Set the source files
SOURCE_FILES := $(wildcard Modules/*.vhdl)
TESTBENCH_FILES = $(wildcard Testbenches/*.vhdl)
# Set the testbench entity
TESTBENCH_ENTITY = uart_tx_tb

# Set the output VCD file
VCD_FILE = uart_tx_tb.ghw

# Default target
all: run

# Target to run the simulation
run:
	$(VHDL_COMPILER) -a --workdir=bld $(SOURCE_FILES) 
	$(VHDL_COMPILER) -a --workdir=bld $(TESTBENCH_FILES)
	$(VHDL_COMPILER) -e --workdir=bld $(TESTBENCH_ENTITY)
	$(SIMULATOR) -r --workdir=bld $(TESTBENCH_ENTITY) --wave=vcd/$(VCD_FILE)

view:
	gtkwave vcd/$(VCD_FILE)
	

# Clean target to remove generated files
clean:
	rm -f *.o *.cf $(VCD_FILE)
	rm -rf bld vcd schematics Verilog json
	mkdir bld vcd schematics Verilog json


MODULES = blinky
schematic: $(MODULES)
$(MODULES):
	cd bld;\
	ghdl -a ../Modules/$@.vhdl;\
	$(VHDL_COMPILER) --synth --out=verilog $@ > ../Verilog/$@.v;\
	yosys -p "prep -top $@; write_json ../json/$@.json" ../Verilog/$@.v;\
	netlistsvg ../json/$@.json -o ../schematics/$@.svg;\

synthesise: $(MODULES)
$(MODULES):
	cd bld;\
	ghdl -a ../Modules/$@.vhdl;\
	$(VHDL_COMPILER) --synth --out=verilog $@ > ../Verilog/$@.v;\
	yosys -p "synth_ice40 -top $@; write_json ../json/$@.json" ../Verilog/$@.v;\
	nextpnr-ice40 --lp1k --package $(PACKAGE) --json ../json/$@.json --pcf ../../pinmapping.pcf --pcf-allow-unconstrained --asc $@.asc;\
	icepack -v $@.asc $@.bin;\
	iceburn -e -v -w $@.bin;\