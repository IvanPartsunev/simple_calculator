# Compiler
CC = gcc

# Directories
SRC_DIR = src
OBJ_DIR = obj
BIN_DIR = bin
IDIR = include

# Target executable
TARGET ?= calculator

# Compiler flags
CFLAGS = -Wall -Wextra -std=c11 -g -I$(IDIR) -MMD -MP
LIBS = -lm

# Find all source files recursively
SRCS = $(shell find $(SRC_DIR) -name '*.c')

# Map src/... to obj/... for object files
OBJS = $(patsubst $(SRC_DIR)/%.c,$(OBJ_DIR)/%.o,$(SRCS))

# Dependency files
DEPS = $(OBJS:.o=.d)

# Default target
all: $(BIN_DIR)/$(TARGET)

# Link step
$(BIN_DIR)/$(TARGET): $(OBJS)
	@mkdir -p $(BIN_DIR)
	$(CC) -o $@ $^ $(LIBS)

# Compile step (handles subfolders)
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(dir $@)
	$(CC) -c $< -o $@ $(CFLAGS)

# Include dependencies for headers
-include $(DEPS)

# Run program
run: all
	./$(BIN_DIR)/$(TARGET)

# Clean build files
.PHONY: clean
clean:
	rm -rf $(OBJ_DIR) $(BIN_DIR)

# Rebuild
.PHONY: re
re: clean all

# Test
TEST_SRCS = $(wildcard tests/*.c)
TEST_OBJS = $(patsubst tests/%.c, $(OBJ_DIR)/%.o, $(TEST_SRCS))
TEST_TARGET = $(BIN_DIR)/test_runner

test: $(TEST_TARGET)
	./$(TEST_TARGET)

$(BIN_DIR)/test_runner: $(TEST_OBJS) $(OBJS)
	@mkdir -p $(BIN_DIR)
	$(CC) -o $@ $^ $(CFLAGS) $(LIBS)

$(OBJ_DIR)/%.o: tests/%.c
	@mkdir -p $(dir $@)
	$(CC) -c $< -o $@ $(CFLAGS)
