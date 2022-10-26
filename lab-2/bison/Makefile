.PHONY: build

C = gcc 
B = bison 
V = @
TARGET = token_1 token_2 token_3

SRC = $(addsuffix .y,$(TARGET))

BFILE = $(SRC:%.y=%.tab.c)

SRCPATH = ./src/
TARPATH = ./target/

TARGETS = $(addprefix $(TARPATH),$(TARGET))
BFILES = $(addprefix $(TARPATH),$(BFILE))


.PHONY: test build mkdir
test: build
	$(V)./tools/test.sh
build: mkdir $(TARGETS)

mkdir:
	$(V)mkdir -p $(TARPATH)

$(TARGETS):$(BFILES)
	$(foreach f,$(TARGETS),$(C) -o $(f) $(f).tab.c;)

$(BFILES):
	$(foreach f,$(BFILE),$(B) -o $(TARPATH)$(f) $(SRCPATH)$(f:%.tab.c=%.y);)


.PHONY: clean
clean:
	-rm -r $(TARPATH)
