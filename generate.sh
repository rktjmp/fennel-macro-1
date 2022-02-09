#/usr/bin/env bash

fennel() {
  fennel_head_bin=$(pwd)/fennel-head

  if [[ -f "$fennel_head_bin" ]]; then
    $fennel_head_bin $@
  else
    $(which fennel) $@
  fi
}

echo "using fennel version" &&  fennel --version
echo ""
echo "Simple Test"
echo "  simple.fnl - simple test"
echo "  simple_wrapped.fnl - simple test wrapped in macrodebug"
echo "  diff simple.fnl simple_wrapped.fnl (two lines expected for macrodebug call)"
echo "  expects "macrodebug" calls in diff after here  vvvv"
diff simple.fnl simple_wrapped.fnl
echo "  expects "macrodebug" calls in diff before here ^^^^"
echo ""

echo "  Generating..."

echo "  simple.lua - compiled simple.fnl"
fennel -c simple.fnl > simple.lua

echo "  simple_wrapped_output.fnl - macrodebug output from running simple_wrapped.fnl"
fennel simple_wrapped.fnl > __temp && fnlfmt __temp > simple_wrapped_output.fnl && rm __temp

echo "  simple_wrapped.lua - compiled simple_wrapped_output.fnl"
fennel -c simple_wrapped_output.fnl > simple_wrapped.lua

echo "  diff simple.lua simple_wrapped.lua"
echo ""
echo "  expects no output after here  vvvv"
diff simple.lua simple_wrapped.lua
echo "  expects no output before here ^^^^"
echo ""

echo ""
echo "Complex Test"
echo "  complex.fnl - complex test"
echo "  complex_wrapped.fnl - complex test wrapped in macrodebug"
echo "  diff complex.fnl complex_wrapped.fnl (two lines expected for macrodebug call)"
echo ""
echo "  expects "macrodebug" calls in diff after here  vvvv"
diff complex.fnl complex_wrapped.fnl
echo "  expects "macrodebug" calls in diff before here ^^^^"
echo ""

echo "  Generating..."

echo "  complex.lua - compiled complex.fnl"
fennel -c complex.fnl > complex.lua

echo "  complex_wrapped_output.fnl - macrodebug output from running complex_wrapped.fnl"
fennel complex_wrapped.fnl > __temp && fnlfmt __temp > complex_wrapped_output.fnl && rm __temp

echo "  complex_wrapped.lua - compiled complex_wrapped_output.fnl"
fennel -c complex_wrapped_output.fnl > complex_wrapped.lua

echo "  diff complex.lua complex_wrapped.lua (no output expected)"
echo ""
echo "  expects no output after here  vvvv"
diff complex.lua complex_wrapped.lua
echo "  expects no output before here ^^^^"
echo ""
