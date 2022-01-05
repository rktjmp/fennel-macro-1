; This is the raw "complex" that exhibits an error

(import-macros {: describe} :macro)


(describe
  "tags"
  :setup (let [parsed (icollect [_ remote (ipairs refs)]
                                (remotes.parse remote))]
           {:remotes parsed})
  ; using two it forms breaks the second setup with no call to ipairs
  (it "test 1" (assert.true true))
  (it "test 2" (assert.false false)))

