(fn describe [name ...]
  ; accepts name, optionally :setup code, (it "name" code) repeating

  ; gets given :setup value, creates a function to return that value
  ; and returns the remaining code (i.e the (it ..) tests)
  (fn extract-setup [code]
    (let [[_ data & rest] code]
      (values `(fn [] ,data) rest)))

  ; called when no :setup _ is given, creates a function to return nil
  (fn create-setup [code]
    (values `(fn [] nil) code))

  ; convert ... into something we can work on
  (local c (list ...))

  ; get setup if it exists and separate it from the tests if needed
  (local (setup-fn tests) (match (. c 1)
                            :setup (extract-setup c)
                            _ (create-setup c)))

  ; (describe
  ;   "testing my module"
  ;   :setup {:inject :my-value}
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
    (let [func `(fn [] (local ,(sym :context) (,setup-fn)))
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
