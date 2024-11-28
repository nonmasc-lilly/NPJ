ifeq ($(origin CC), default)
CC = gcc
endif
CFLAGS ?= -std=c89 -Wpedantic

all: build/main

build/main: src/main.c
	$(CC) -o $@ $^ $(CFLAGS)
