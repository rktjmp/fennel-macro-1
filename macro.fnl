(fn describe [name ...]
  ; accepts name, optionally :context code, (it "name" code) repeating

  ; get context if it exists and separate it from the tests if needed
  (local (context-value tests) (match [...]
                                 [:context data & tests] (values data tests)
                                 tests (values nil tests)))
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
    ; create (busted.it "test_1" (fn [] context code code code))
    ; we explicitly want each (it ...) to have a `context` var,
    ; so enforce the symbol. gensym is no use for us.
    (let [func `(fn [] (local ,(sym :context) ,context-value))
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
