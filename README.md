# Readme

Requirements
---

- `fennel` in your path or as `fennel-head` in working directory
- `fnlfmt` in your path

Problem
---

The macro is not generating a correct `for a b in p` in the *second* `(it ...)`
in complex test, it outputs in incorrect iterator, `for a in b`.

This is only present when running the code **not** output by `macrodebug`.

About
---

Two examples are included, `simple.fnl` and `complex.fnl`. They both have a
paired `simple_wrapped.fnl` and `complex_wrapped.fnl` that just wraps the code
in `(macrodebug)` calls.

`macro.fnl` is the macro that exhibits the bug (see also [Intention](#intention) below).

`simple.fnl` does not exhibit the issue, `complex.fnl` does.

To view the test, run `./generate.sh`. It will check the current directory for
a `fennel-head` file, which it assumes to be a built fennel executable. If not
present it will attempt to run the test via whatever `which fennel` resolves
to.

See below an example output. The `simple` test produces the same output in both
the naked and wrapped forms. The `complex` test produces different output depending on
whether the macro call is wrapped in `macrodebug`, **additionally the code
generated without `macrodebug` is incorrect, resulting in `for a in b` instead
of `for a,b in p`.**

```
./generate.sh

using fennel version
Fennel 1.0.1-dev on PUC Lua 5.4

Simple Test
  simple.fnl - simple test
  simple_wrapped.fnl - simple test wrapped in macrodebug
  diff simple.fnl simple_wrapped.fnl (two lines expected for macrodebug call)
  expects macrodebug calls in diff after here  vvvv
5c5
< 
---
> (macrodebug
11c11
< 
---
> ) ; macrodebug)
  expects macrodebug calls in diff before here ^^^^

  Generating...
  simple.lua - compiled simple.fnl
  simple_wrapped_output.fnl - macrodebug output from running simple_wrapped.fnl
  simple_wrapped.lua - compiled simple_wrapped_output.fnl
  diff simple.lua simple_wrapped.lua

  expects no output after here  vvvv
  expects no output before here ^^^^


Complex Test
  complex.fnl - complex test
  complex_wrapped.fnl - complex test wrapped in macrodebug
  diff complex.fnl complex_wrapped.fnl (two lines expected for macrodebug call)

  expects macrodebug calls in diff after here  vvvv
5c5
< 
---
> (macrodebug
19c19
< 
---
> ) ; macrodebug)
  expects macrodebug calls in diff before here ^^^^

  Generating...
  complex.lua - compiled complex.fnl
  complex_wrapped_output.fnl - macrodebug output from running complex_wrapped.fnl
  complex_wrapped.lua - compiled complex_wrapped_output.fnl
  diff complex.lua complex_wrapped.lua (no output expected)

  expects no output after here  vvvv
25c25
<       for a in b do
---
>       for a, b in p do
  expects no output before here ^^^^
```

Files
---

- `simple.fnl`: a short demo, behaves as expected
- `simple_wrapped.fnl`: the same as `simple.fnl` but the call is wrapped in `macrodebug`
- `complex.fnl`: a complex (ish) demo that exhibits the bug
- `complex_wrapped.fnl`: the same as `complex.fnl` but the call is wrapped in `macrodebug`

Additionally generated files:

- `simple.lua`: output of `fennel -c simple.fnl`
- `simple_wrapped_output.fnl`: `fnlfmt`'d output from macrodebug
- `simple_wrapped.lua`: output of `fennel -c simple_wrapped_output.fnl`
- `complex.lua`: output of `fennel -c complex.fnl`
- `complex_wrapped_output.fnl`: `fnlfmt`'d output from macrodebug
- `complex_wrapped.lua`: output of `fennel -c complex_wrapped_output.fnl`

Intention
---

Create a macro to wrap calls to the busted testing framework. Busted tests have
a `describe` block that wraps each `it` test.

The macro should create a new/pristine `context` variable, available to each
`it` test.

The value of `context` can be given with the optional `:context list` argument
pair, or it defaults to nil.

```fnl
(describe
  "testing my module"
  :context {:inject :my-value}
  (it "test 1" (assert.equal context.inject :my-value))
  (it "test 2" (assert.equal context.inject :my-value)))
```

Should produce something like this hand coded call:

```fnl
(busted.describe "testing my module"
  (fn []
    (busted.it "test 1"
      (fn []
        (local context {:inject :my-value})
        (assert.equal context.inject :my-value)))
    (busted.it "test 2"
      (fn []
        (local context {:inject :my-value})
        (assert.equal context.inject :my-value)))))
```
