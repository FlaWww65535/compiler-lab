#!/bin/bash
echo -e "Test:"
echo -e "1)\n"
cat ./tools/test_1.in
./target/token_1 < ./tools/test_1.in
echo -e "2)\n"
cat ./tools/test_2.in
./target/token_2 < ./tools/test_2.in
echo -e "3)\n"
cat ./tools/test_3.in
./target/token_3 < ./tools/test_3.in
