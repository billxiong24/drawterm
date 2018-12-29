#!/bin/bash
# run st, full screen, then stty size. change ROWS to be first number, COLS to be the second
ROWS=75
COLS=273


read -r X Y W H < <(slop -f '%x %y %w %h')

# get resolution
res=$(xdpyinfo | grep dimension | awk '{print $2}')

# determine resolution (e.g. for 1920x1080 x_res is 1920, y_res is 1080)
x_res=$(echo $res | cut -f 1 -d 'x')
y_res=$(echo $res | cut -f 2 -d 'x')

# determine factor to convert pixels to rows/columns, 
# since st determines size with rows and cols, while slop determines size with pixels

x_scale=$(echo "scale = 5; $COLS/$x_res" | bc)
y_scale=$(echo "scale = 5; $ROWS/$y_res" | bc)

# convert pixels to rows and columns - quick hack for truncating
term_width=$(echo "scale = 0; $W * $x_scale" | bc | cut -f 1 -d '.')
term_height=$(echo "scale = 0; $H * $y_scale" | bc | cut -f 1 -d '.')

dim=${term_width}x${term_height}+${X}+${Y}
st -g $dim
