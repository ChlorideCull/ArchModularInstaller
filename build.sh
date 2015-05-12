#!/bin/sh
sed '/STAGE2MARKER/r stage2.sh' stage1.sh > install.sh
chmod +x install.sh