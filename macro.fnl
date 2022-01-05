(fn describe [name ...]
  ; accepts name, optionally :context code, (it "name" code) repeating

  ; Given (:context value code), creates a function to return that value.
  ; We also return the remaining code, sans (:context value) (i.e the (it ...) tests)
  (fn extract-context [code]
    (let [[_ data & rest] code]
      (values `,data rest)))

  ; called when no :context _ is given, creates a function to return nil
  (fn create-context [code]
    (values `nil code))

  ; convert ... into something we can work on
  (local c (list ...))

  ; get context if it exists and separate it from the tests if needed
  (local (context-value tests) (match (. c 1)
                                 :context (extract-context c)
                                 _ (create-context c)))

  ; (describe
  ;   "testing my module"
  ;   :context {:inject :my-value}
  ;          ^- context ------^
  ;   (it "test 1" (assert.equal context.inject :my-value)) <- "test"  <-+
  ;                ^- test body ------------------------^                | describe body
  ;   (it "test 2" (assert.equal context.inject :my-value))) <- "test" <-+
  ;                ^- test body ------------------------^

  (fn build-test [[_it name & asserts]]
    ; given (it "test_1" code code code)
    ; create (b.it "test_1" (fn [] context code code code))
    ; we explicitly want each (it ...) to have a `context` var,
    ; so enforce the symbol. gensym is no use for us.
    (let [func `(fn [] (local ,(sym :context) ,context-value))
          ; maybe this is a faux pas not using each here since i discard the
          ; result, but its more uniform with the next function.
          _ (icollect [_ assert (ipairs asserts) :into func]
                      `,assert)]
      `(busted.it ,name ,func)))

  (fn build-describe-body [tests]
    (icollect [_ test (ipairs tests) :into `(fn [])]
                (build-test test)))
  (local describe-body `,(build-describe-body tests))

  ; require busted needed in the real world to avoid recursion
  `(busted.describe
    ,name
    ,describe-body))

{: describe}
