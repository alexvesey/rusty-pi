#
# MIT License
#
# Copyright (c) 2018 Andre Richter <andre.o.richter@gmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

TARGET = aarch64-raspi3-none-elf

CROSS_CONTAINER = ./dockcross-linux-aarch64
CROSS_CONTAINER_OBJCOPY = aarch64-linux-gnu-objcopy

QEMU_CONTAINER = andrerichter/raspi3-qemu
DOCKER_CMD = docker run -it --rm -v $(shell pwd):/work -w /work
QEMU_CMD = qemu-system-aarch64 -M raspi3 -kernel kernel8.img

all: clean cross_cont_download kernel8.img

cross_cont_download:
ifeq (,$(wildcard $(CROSS_CONTAINER)))
	docker run --rm dockcross/linux-arm64 > $(CROSS_CONTAINER)
	chmod +x $(CROSS_CONTAINER)
endif

target/$(TARGET)/debug/kernel8: src/main.rs
	RUST_TARGET_PATH=$(shell pwd) xargo build --target=$(TARGET)
	cp $@ .

target/$(TARGET)/release/kernel8: src/main.rs
	RUST_TARGET_PATH=$(shell pwd) xargo build --target=$(TARGET) --release
	cp $@ .

ifeq ($(DEBUG),1)
kernel8: target/$(TARGET)/debug/kernel8
else
kernel8: target/$(TARGET)/release/kernel8
endif

kernel8.img: kernel8
	$(CROSS_CONTAINER) $(CROSS_CONTAINER_OBJCOPY) -O binary -S $< kernel8.img

qemu:
	$(DOCKER_CMD) $(QEMU_CONTAINER) $(QEMU_CMD) -d in_asm

clippy:
	RUSTFLAGS="-C panic=abort" xargo clippy --target=$(TARGET)

clean:
	cargo clean
	rm -f kernel8