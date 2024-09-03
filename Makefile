#############################################
##  Processor: STM32F103
##  Author: Saurabh Kumar
##  GCC Version: 12.3
##  
##	$(error Files is [${LIBDIRC}])
##  Makefile for STM32F103 Bootloader
#############################################

#RootDirectory with the Project paths
ROOT = ./..
SRC_DIR = $(ROOT)/app
INC_DIR = $(ROOT)/app/inc

BIN_DIR = $(ROOT)/build/bin
OBJ_DIR = $(ROOT)/build/obj

#Compiler Directories
CC_DIR = $(ROOT)/tools/CC/gcc-10.3
CC_BIN = $(CC_DIR)/bin
CC_INC = $(CC_DIR)/include
CC_LIB = $(CC_DIR)/lib

#Compilar Path
CC = $(CC_BIN)/arm-none-eabi-gcc
OBJSIZE = $(CC_BIN)/arm-none-eabi-size
OBJDUMP = $(CC_BIN)/arm-none-eabi-objdump
OBJCOPY = $(CC_BIN)/arm-none-eabi-objcopy

#Project Name
PROJECT = STM32F103C6_BL

SRC = $(wildcard $(SRC_DIR)/src/*.c)
INC = $(wildcard $(INC_DIR)/*.h)
OBJ = $(patsubst $(SRC_DIR)/%.c,$(OBJ_DIR)/%.o,$(SRC))

#$(error Files is [${SRC}])

#Compiler and Linker flags

CFLAGS = -c -DSTM32F1 -mthumb -g3 -mcpu=cortex-m3 -Wall -std=gnu11 $(addprefix -I ,$(INC_DIR)) -ggdb
LDFLAGS = -T STM32F103C6_BL.ld -O0 -g3 -ggdb -Wl,-Map=$(BIN_DIR)/STM32F103C6_BL.map -nostdlib -mcpu=cortex-m3 -Wall -Werror -Wshadow $(addprefix -L ,$(CC_LIB))

#Target name with path
TARGET = $(ROOT)/build/bin/$(PROJECT)

#Makefile rules to build the project
all: $(TARGET).elf objcopytohex objcopytobin objsize

$(TARGET).elf:$(OBJ)
	@echo Linking: $@
	@$(CC) $(LDFLAGS) $^ -o $@

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	@echo Compiling: $@
	@$(CC) $(CFLAGS)  $(SRC_DIR)/$(*).c -o $(OBJ_DIR)/$(*).o

objsize: 
	@echo Size of output file is:
	@$(OBJSIZE) $(TARGET).elf

objcopytohex:
	@echo Generating .hex file....
	@$(OBJCOPY) -O ihex $(TARGET).elf $(TARGET).hex

objcopytobin:
	@echo Generating .bin file....
	@$(OBJCOPY) -O binary $(TARGET).elf $(TARGET).bin

clean:
	@echo Removing build files
	@rm -rf $(BIN_DIR)/* $(OBJ_DIR)/src/*.o
	@echo Done...

.PHONY: all clean