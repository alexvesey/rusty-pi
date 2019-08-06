#!/bin/sh

cargo xrustc --target $TARGET

cargo objcopy -- --strip-all -O binary $CARGO_OUTPUT kernel8.img
