# Readme

Problem
---

Macro is not generating call to `ipairs` in *second* `(it ...)` in complex test.

This is only present when running the code *not* output by `macrodebug`.

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
14c14
<
---
> ) ; macrodebug)

  Generating...
  complex.lua - compiled complex.fnl
  complex_wrapped_output.fnl - macrodebug output from running complex_wrapped.fnl
  complex_wrapped.lua - compiled complex_wrapped_output.fnl
  diff complex.lua complex_wrapped.lua (no output expected)

35c35
<         for _ in remote do
---
>         for _, remote in ipairs(refs) do
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

The value of `context` can be given with the optional `:setup list` argument
pair, or it defaults to nil.

```fnl
(describe
  "testing my module"
  :setup {:inject :my-value}
  (it "test 1" (assert.equal context.inject :my-value))
  (it "test 2" (assert.equal context.inject :my-value)))
```

Should produce:

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

```fnl
(macro describe [name ...]
  ; accepts name, optionally :setup code, (it "name" code) repeating

  ; gets given :setup value, creates a function to return that value
  ; and returns the remaining code (i.e the (it ..) tests)
  (fn extract-setup [code]
    (let [[_ data & rest] code]
      (values `(fn [] ,data) rest)))

  ; called when no :setup _ is given, creates a function to return nil
  (fn create-setup [code]
    (values `(fn [] nil) code))

  ; helper to generate (it ...) expressions
  (fn make-test [code]
    (let [[call name & test] code]
      `(it ,name (fn [] ,test))))

  ; convert ... into something we can work on
  (local c (list ...))

  ; get setup if it exists and separate it from the tests if needed
  (local (setup tests) (match (. c 1)
                          :setup (extract-setup c)
                          _ (create-setup c)))

  ; we explicitly want each (it ...) to have a `context` var,
  ; so enforce the symbol. gensym is no use for us.
  (local context (sym :context))

  ; body holds the describe body, it will be a bunch of
  ; consecutive function definitions which create the context var
  ; and then calls `(it name (fn [] test-code))`. The functions
  ; are called automatically at creation.
  (local body '(do))
  (each [_ t (ipairs tests)]
    (let [t (make-test t)]
      (table.insert body `((fn []
                            (local ,context (,setup))
                            ,t)))))

  ; require busted needed in the real world to avoid recursion
  `((. (require :busted) :describe)
    ,name
    (fn [] ,body)))
```
