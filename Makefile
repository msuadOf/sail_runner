WORK_DIR=workdir

SAIL=sail
SAILRISCV=sail-riscv
SAILARM=sail-arm
ISLA=isla
ISLASNAPSHOTS=isla-snapshots

SAIL_DIR=$(WORK_DIR)/$(SAIL)
SAILRISCV_DIR=$(WORK_DIR)/$(SAILRISCV)
SAILARM_DIR=$(WORK_DIR)/$(SAILARM)
ISLA_DIR=$(WORK_DIR)/$(ISLA)
ISLASNAPSHOTS_DIR=$(WORK_DIR)/$(ISLASNAPSHOTS)

ifeq ($(wildcard $(SAIL_DIR)/README.md),)
  $(shell git clone git@github.com:rems-project/sail.git $(SAIL_DIR))
endif

ifeq ($(wildcard $(SAILRISCV_DIR)/README.md),)
  $(shell git clone git@github.com:riscv/sail-riscv.git $(SAILRISCV_DIR))
endif

ifeq ($(wildcard $(ISLA_DIR)/README.md),)
  $(shell git clone git@github.com:msuadOf/isla.git $(ISLA_DIR))
endif

ifeq ($(wildcard $(ISLASNAPSHOTS_DIR)/README.md),)
  $(shell git clone git@github.com:rems-project/isla-snapshots.git $(ISLASNAPSHOTS_DIR))
endif

ifeq ($(wildcard $(SAILARM_DIR)/README.md),)
  $(shell git clone git@github.com:rems-project/sail-arm.git $(SAILARM_DIR))
endif

all: empty

sail:
	opam switch create 5.1.0
	eval $(opam config env)
	sudo apt-get install build-essential libgmp-dev z3 pkg-config
	cd $(SAIL_DIR) && opam install . --deps-only
	make -C $(SAIL_DIR) 
sail:
	sudo apt-get install -y build-essential libgmp-dev z3 pkg-config \
		&& opam install sail

empty:
	echo "Nothing to do"

clean:
	make -C $(SAIL_DIR) clean
	make -C $(SAILRISCV_DIR) clean
	make -C $(ISLA_DIR) clean

distclean:
	rm -rf $(WORK_DIR)