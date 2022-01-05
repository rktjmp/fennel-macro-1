; This is the raw "complex" that exhibits an error

(import-macros {: describe} :macro)

(macrodebug
(describe
  "test suite"
  ; these all exhibit the same behaviour
  :setup (each [a b p] a)
  ; :setup (icollect [a b p] a)
  ; :setup (collect [a b p] a)
  ; :setup (fn [] (each [a b p] a))
  ; setup (fn [] icollect/collect)
  ; using two it forms breaks the second setup, the for loop is generated incorrectly
  (it "test 1" (assert.true true))
  (it "test 2" (assert.false false)))
) ; macrodebug)
