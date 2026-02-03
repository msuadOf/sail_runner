WORK_DIR=workdir

SAIL=sail
SAILRISCV=sail-riscv
SAILARM=sail-arm
ISLA=isla
ISLA1=isla1
ISLASNAPSHOTS=isla-snapshots
SAILOR_ARTIFACT=sailor_artifact
RISCV_UNIFIED_DB=riscv-unified-db
ISLA_TESTGEN=isla-testgen
ISLA_TESTGEN_SAIL=isla-testgen-sail
ISLA_TESTGEN_CHERIoT=isla-testgen-cheriot-sail
ISLA_TESTGEN_RANDOM_GENERATOR=isla-testgen-sail-riscv-test-generation

SAIL_DIR=$(WORK_DIR)/$(SAIL)
SAILRISCV_DIR=$(WORK_DIR)/$(SAILRISCV)
SAILARM_DIR=$(WORK_DIR)/$(SAILARM)
ISLA_DIR=$(WORK_DIR)/$(ISLA)
ISLA1_DIR=$(WORK_DIR)/$(ISLA1)
ISLASNAPSHOTS_DIR=$(WORK_DIR)/$(ISLASNAPSHOTS)
SAILOR_ARTIFACT_DIR=$(WORK_DIR)/$(SAILOR_ARTIFACT)
RISCV_UNIFIED_DB_DIR=$(WORK_DIR)/$(RISCV_UNIFIED_DB)
ISLA_TESTGEN_DIR=$(WORK_DIR)/$(ISLA_TESTGEN)
ISLA_TESTGEN_SAIL_DIR=$(WORK_DIR)/$(ISLA_TESTGEN_SAIL)
ISLA_TESTGEN_CHERIoT_DIR=$(WORK_DIR)/$(ISLA_TESTGEN_CHERIoT)
ISLA_TESTGEN_RANDOM_GENERATOR_DIR=$(WORK_DIR)/$(ISLA_TESTGEN_RANDOM_GENERATOR)

ifeq ($(wildcard $(SAIL_DIR)/README.md),)
  $(shell git clone git@github.com:rems-project/sail.git $(SAIL_DIR))
endif

ifeq ($(wildcard $(SAILRISCV_DIR)/README.md),)
  $(shell git clone git@github.com:riscv/sail-riscv.git $(SAILRISCV_DIR))
endif

ifeq ($(wildcard $(ISLA_DIR)/README.md),)
  $(shell git clone git@github.com:rems-project/isla.git $(ISLA_DIR))
endif

ifeq ($(wildcard $(ISLA1_DIR)/README.md),)
  $(shell git clone git@github.com:ariscv/isla.git $(ISLA1_DIR))
endif

ifeq ($(wildcard $(ISLASNAPSHOTS_DIR)/README.md),)
  $(shell git clone git@github.com:rems-project/isla-snapshots.git $(ISLASNAPSHOTS_DIR))
endif

ifeq ($(wildcard $(SAILARM_DIR)/README.md),)
  $(shell git clone git@github.com:rems-project/sail-arm.git $(SAILARM_DIR))
endif

ifeq ($(wildcard $(SAILOR_ARTIFACT_DIR)/README.md),)
  $(shell git clone git@github.com:neeluk7/sailor_artifact.git $(SAILOR_ARTIFACT_DIR) --recursive)
endif

ifeq ($(wildcard $(RISCV_UNIFIED_DB_DIR)/README.md),)
  $(shell git clone git@github.com:riscv-software-src/riscv-unified-db.git $(RISCV_UNIFIED_DB_DIR))
endif

ifeq ($(wildcard $(ISLA_TESTGEN_DIR)/README.md),)
  $(shell git clone --recurse-submodules git@github.com:rems-project/isla-testgen.git $(ISLA_TESTGEN_DIR))
endif

ifeq ($(wildcard $(ISLA_TESTGEN_SAIL_DIR)/README.md),)
  $(shell git clone git@github.com:rems-project/sail.git $(ISLA_TESTGEN_SAIL_DIR) && cd $(ISLA_TESTGEN_SAIL_DIR) && git checkout bfdeb8cc)
endif

ifeq ($(wildcard $(ISLA_TESTGEN_CHERIoT_DIR)/README.md),)
  $(shell git clone git@github.com:bacam/2025-lowrisc-cheriot-sail.git $(ISLA_TESTGEN_CHERIoT_DIR))
endif

ifeq ($(wildcard $(ISLA_TESTGEN_RANDOM_GENERATOR_DIR)/README.md),)
  $(shell git clone git@github.com:rems-project/sail-riscv-test-generation.git $(ISLA_TESTGEN_RANDOM_GENERATOR_DIR))
endif

all: empty

sail:
	opam switch create 5.1.0
	eval $(opam config env)
	sudo apt-get install build-essential libgmp-dev z3 pkg-config
	cd $(SAIL_DIR) && opam install . --deps-only
	$(MAKE) -C $(SAIL_DIR) 
sail:
	sudo apt-get install -y build-essential libgmp-dev z3 pkg-config \
		&& opam install sail

init-isla:
	cd workdir/isla-snapshots && gzip -d ./*.ir.gz

# ======isla-gen======
islagen-sail:
	cd $(ISLA_TESTGEN_SAIL_DIR) && opam install .

islagen-isla-testgen:
	cd $(ISLA_TESTGEN_DIR) && cargo build --release && cd isla/isla-sail && $(MAKE)

export PATH:=$(PATH):$(PWD)/$(ISLA_TESTGEN_DIR)/isla/isla-sail
islagen-cheriot-sail:
	echo $(PATH)
	$(MAKE) -C $(ISLA_TESTGEN_CHERIoT_DIR) generated_definitions/riscv_model_RV32.ir

init-islagen: islagen-sail islagen-isla-testgen islagen-cheriot-sail

empty:
	echo "Nothing to do"

clean:
	$(MAKE) -C $(SAIL_DIR) clean
	$(MAKE) -C $(SAILRISCV_DIR) clean
	$(MAKE) -C $(ISLA_DIR) clean

distclean:
	rm -rf $(WORK_DIR)