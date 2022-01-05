# Readme

Problem
---

Macro is not generating correct `for a b in p` in *second* `(it ...)` in
complex test, it outputs `for a in b`.

This is only present when running the code **not** output by `macrodebug`.

Quick
---

Run `./generate.sh`

```
Simple Test
  simple.fnl - simple test
  simple_wrapped.fnl - simple test wrapped in macrodebug
  diff simple.fnl simple_wrapped.fnl (two lines expected for macrodebug call)

5c5
<
---
> (macrodebug
11c11
<
---
> ) ; macrodebug)

  Generating...
  simple.lua - compiled simple.fnl
  simple_wrapped_output.fnl - macrodebug output from running simple_wrapped.fnl
  simple_wrapped.lua - compiled simple_wrapped_output.fnl
  diff simple.lua simple_wrapped.lua (no output expected)


Complex Test
  complex.fnl - complex test
  complex_wrapped.fnl - complex test wrapped in macrodebug
  diff complex.fnl complex_wrapped.fnl (two lines expected for macrodebug call)

5c5
<
---
> (macrodebug
12c12
<
---
> ) ; macrodebug)

  Generating...
  complex.lua - compiled complex.fnl
  complex_wrapped_output.fnl - macrodebug output from running complex_wrapped.fnl
  complex_wrapped.lua - compiled complex_wrapped_output.fnl
  diff complex.lua complex_wrapped.lua (no output expected)

28c28
<       for a in b do
---
>       for a, b in p do
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

The Macro
---

See macro.fnl

