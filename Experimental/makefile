# Set the GHDL executable path
GHDL := ghdl

# Set the source files
SRC := blinky.vhdl blinky_tb.vhdl

# Set the top-level entity
TOP_ENTITY := blinker_tb

# Set the VCD output file
VCD_FILE := blinky.vcd

# Set the build directory
BLD_DIR := bld

# Default target
all: analyze elaborate run

# Analyze the source files
analyze:
	$(GHDL) -a  --workdir=$(BLD_DIR) $(SRC)

# Elaborate the top-level entity
elaborate:
	$(GHDL) -e  --workdir=$(BLD_DIR) $(TOP_ENTITY)

# Run the simulation and generate VCD output
run:
	$(GHDL) -r --workdir=$(BLD_DIR) $(TOP_ENTITY) --vcd=$(VCD_FILE)

# Clean generated files
.PHONY: clean
clean:
	$(GHDL) --clean
	rm -f $(VCD_FILE)
	rm -rf $(BLD_DIR)
	mkdir -p $(BLD_DIR)

.PHONY: design
design:
	$(GHDL) -a --workdir=$(BLD_DIR) $(SRC)
	$(GHDL) -e --workdir=$(BLD_DIR) $(TOP_ENTITY)
	$(GHDL) -r --workdir=$(BLD_DIR) $(TOP_ENTITY) --vcd=$(VCD_FILE) --disp-tree
