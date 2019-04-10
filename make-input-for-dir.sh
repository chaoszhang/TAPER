#/bin/bash

cat - | awk '{print $0"\n"$0".out"}'
