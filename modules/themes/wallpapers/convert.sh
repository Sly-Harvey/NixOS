#!/usr/bin/env bash

for file in *.png *.jpg *.jpeg; do
  cjxl "$file" "${file%.*}.jxl" --lossless_jpeg=1
done
rm *.png *.jpg *.jpeg
