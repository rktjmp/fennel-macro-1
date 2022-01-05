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

  (local describe-body '(fn []))
  (each [_ t (ipairs tests)]
    (let [[_it name & test] t
          test-body '(fn [])
          _ (each [_ expression (ipairs test)]
              (table.insert test-body `,expression))
          it `(it ,name ,test-body)]
      (table.insert describe-body `(let [setup-fn# ,setup
                                         ,context (setup-fn#)]
                                     ,it))))

  ; require busted needed in the real world to avoid recursion
  `(busted.describe
    ,name
    ,describe-body))

{: describe}
