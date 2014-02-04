#!/bin/bash

# Test empty squares from simple board
ruby validator.rb files/simple_board.txt tests/sb_empty_squares.txt

# Test destination square with same color
ruby validator.rb files/simple_board.txt tests/sb_destination_samecolor.txt

