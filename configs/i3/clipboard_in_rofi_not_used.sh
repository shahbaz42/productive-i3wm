#!/bin/bash

entries=$(copyq eval -- "
tab('clipboard');
var out = [];
for (var i = 0; i < size() && i < 30; ++i) {
  var text = str(read(i)).replace(/\\n/g, '⏎').replace(/\\r/g, '');
  if (text.length > 80) text = text.substring(0, 80) + '...';
  out.push(i + ': ' + text);
}
out.join('\n');
")

selected=$(echo "$entries" | rofi -dmenu -i -p "Clipboard" -show drun -theme ~/.config/rofi/themes/minimal-modern.rasi)

if [ -n "$selected" ]; then
    index=$(echo "$selected" | cut -d':' -f1)
    copyq select "$index"
    copyq paste
fi
