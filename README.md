# Readme

Problem
---

Macro is not generating call to `ipairs` in *second* `(it ...)` in complex test.

This is only present when running the code *not* output by `macrodebug`.

Quick
---

./generate.sh

```
λ ./generate.sh
Simple
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
Generating :
  simple.lua - compiled simple.fnl
  simple_wrapped_output.fnl - output of running simple_wrapped.fnl
  simple_wrapped.lua - compiled simple_wrapped_output.fnl
  diff simple.lua simple_wrapped.lua (no output expected)
Complex
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
Generating :
  complex.lua - compiled complex.fnl
  complex_wrapped_output.fnl - output of running complex_wrapped.fnl
  complex_wrapped.lua - compiled complex_wrapped_output.fnl
  diff complex.lua complex_wrapped.lua (no output expected)
35c35
<         for _ in remote do
---
>         for _, remote in ipairs(refs) do
```

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

A simple test
---

```
; simple.fnl

(import-macros {: describe} :macro)

(describe
  "testing my module"
  :setup {:inject :my-value}
  (it "test 1" (assert.equal context.inject :my-value))
  (it "test 2" (assert.equal context.inject :my-value)))
```

via `(macrodebug)`

```
; simple_macrodebug_output.fnl
((. (require :busted) :describe) "testing my module"
                                 (fn {}
                                   (do
                                     ((fn {}
                                        (local context
                                               ((fn {}
                                                  {:inject :my-value})))
                                        (it "test 1"
                                            (fn {}
                                              [(assert.equal context.inject
                                                             :my-value)]))))
                                     ((fn {}
                                        (local context
                                               ((fn {}
                                                  {:inject :my-value})))
                                        (it "test 2"
                                            (fn {}
                                              [(assert.equal context.inject
                                                             :my-value)])))))))
```

Looks correct.

Check lua output:

```
-- simple_compiled.lua
local function _1_()
  local function _2_()
    local context
    local function _3_()
      return {inject = "my-value"}
    end
    context = _3_()
    local function _4_()
      return {assert.equal(context.inject, "my-value")}
    end
    return it("test 1", _4_)
  end
  _2_()
  local function _5_()
    local context
    local function _6_()
      return {inject = "my-value"}
    end
    context = _6_()
    local function _7_()
      return {assert.equal(context.inject, "my-value")}
    end
    return it("test 2", _7_)
  end
  return _5_()
end
return (require("busted")).describe("testing my module", _1_)
```

```
-- simple_macrodebug_compiled.lua
local function _1_()
  local function _2_()
    local context
    local function _3_()
      return {inject = "my-value"}
    end
    context = _3_()
    local function _4_()
      return {assert.equal(context.inject, "my-value")}
    end
    return it("test 1", _4_)
  end
  _2_()
  local function _5_()
    local context
    local function _6_()
      return {inject = "my-value"}
    end
    context = _6_()
    local function _7_()
      return {assert.equal(context.inject, "my-value")}
    end
    return it("test 2", _7_)
  end
  return _5_()
end
return (require("busted")).describe("testing my module", _1_)
```

`diff simple_compiled.lua simple_macrodebug_compiled.lua`

(empty, no differences)

```
```

Complex Example
---

Each `it` test should have its own `icollect` iteration.

```
; complex.fnl
(import-macros {: describe} :macro)
(describe
  "tags"
  :setup (let [parsed (icollect [_ remote (ipairs refs)]
                                (remotes.parse remote))]
           {:remotes parsed})
  (it "test 1" (assert.true true))
  (it "test 2" (assert.false false)))
```

```
; complex_macrodebug_output.fnl
((. (require :busted) :describe) :tags
                                 (fn {}
                                   (do
                                     ((fn {}
                                        (local context
                                               ((fn {}
                                                  (let [parsed (icollect [_ remote (ipairs refs)]
                                                                 (remotes.parse remote))]
                                                    {:remotes parsed}))))
                                        (it "test 1"
                                            (fn {}
                                              [(assert.true true)]))))
                                     ((fn {}
                                        (local context
                                               ((fn {}
                                                  (let [parsed (icollect [_ remote (ipairs refs)]
                                                                 (remotes.parse remote))]
                                                    {:remotes parsed}))))
                                        (it "test 2"
                                            (fn {}
                                              [(assert.false false)])))))))
```

Seems OK? Each context and test block looks appropriately scoped.

View compiled lua

```
; complex_macrodebug_compiled.lua
local function _1_()
  local function _2_()
    local context
    local function _3_()
      local parsed
      do
        local tbl_15_auto = {}
        local i_16_auto = #tbl_15_auto
        for _, remote in ipairs(refs) do
          local val_17_auto = remotes.parse(remote)
          if (nil ~= val_17_auto) then
            i_16_auto = (i_16_auto + 1)
            do end (tbl_15_auto)[i_16_auto] = val_17_auto
          else
          end
        end
        parsed = tbl_15_auto
      end
      return {remotes = parsed}
    end
    context = _3_()
    local function _5_()
      return {assert["true"](true)}
    end
    return it("test 1", _5_)
  end
  _2_()
  local function _6_()
    local context
    local function _7_()
      local parsed
      do
        local tbl_15_auto = {}
        local i_16_auto = #tbl_15_auto
        for _, remote in ipairs(refs) do
          local val_17_auto = remotes.parse(remote)
          if (nil ~= val_17_auto) then
            i_16_auto = (i_16_auto + 1)
            do end (tbl_15_auto)[i_16_auto] = val_17_auto
          else
          end
        end
        parsed = tbl_15_auto
      end
      return {remotes = parsed}
    end
    context = _7_()
    local function _9_()
      return {assert["false"](false)}
    end
    return it("test 2", _9_)
  end
  return _6_()
end
return (require("busted")).describe("tags", _1_)
```

Seems OK, each block has call to `ipairs(refs)`.

Check running without going through macrodebug first

```
; complex_compiled.lua
local function _1_()
  local function _2_()
    local context
    local function _3_()
      local parsed
      do
        local tbl_15_auto = {}
        local i_16_auto = #tbl_15_auto
        for _, remote in ipairs(refs) do
          local val_17_auto = remotes.parse(remote)
          if (nil ~= val_17_auto) then
            i_16_auto = (i_16_auto + 1)
            do end (tbl_15_auto)[i_16_auto] = val_17_auto
          else
          end
        end
        parsed = tbl_15_auto
      end
      return {remotes = parsed}
    end
    context = _3_()
    local function _5_()
      return {assert["true"](true)}
    end
    return it("test 1", _5_)
  end
  _2_()
  local function _6_()
    local context
    local function _7_()
      local parsed
      do
        local tbl_15_auto = {}
        local i_16_auto = #tbl_15_auto
        for _ in remote do
          local val_17_auto = remotes.parse(remote)
          if (nil ~= val_17_auto) then
            i_16_auto = (i_16_auto + 1)
            do end (tbl_15_auto)[i_16_auto] = val_17_auto
          else
          end
        end
        parsed = tbl_15_auto
      end
      return {remotes = parsed}
    end
    context = _7_()
    local function _9_()
      return {assert["false"](false)}
    end
    return it("test 2", _9_)
  end
  return _6_()
end
return (require("busted")).describe("tags", _1_)
```

Suddenly the second `for _ ...` is missing a call to ipairs

`diff complex_compiled.lu complex_macrodebug_compiled.lua`

```
35c35
<         for _ in remote do
---
>         for _, remote in ipairs(refs) do
