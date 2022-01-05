; this is the simple case

(import-macros {: describe} :macro)


(describe
  "testing my module"
  :context {:inject :my-value}
  (it "test 1" (assert.equal context.inject :my-value))
  (it "test 2" (assert.equal context.inject :my-value)))

