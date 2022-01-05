; This is the raw "complex" that exhibits an error

(import-macros {: describe} :macro)

(macrodebug
(describe
  "test suite"
  :setup (collect [a b p] a)
  ; using two it forms breaks the second setup, the for loop is generated incorrectly
  (it "test 1" (assert.true true))
  (it "test 2" (assert.false false)))
) ; macrodebug)
