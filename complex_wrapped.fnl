; This is the raw "complex" that exhibits an error

(import-macros {: describe} :macro)

(macrodebug
(describe
  "test suite"
  ; these all exhibit the same behaviour
  :context (each [a b p] a)
  ; :context (icollect [a b p] a)
  ; :context (collect [a b p] a)
  ; :context (fn [] (each [a b p] a))
  ; context (fn [] icollect/collect)
  ; using two it forms breaks the second context, the for loop is generated incorrectly
  (it "test 1" (assert.true true))
  (it "test 2" (assert.false false)))
) ; macrodebug)
