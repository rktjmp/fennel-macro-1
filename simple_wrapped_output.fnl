(busted.describe "testing my module"
                 (fn {}
                   (let [setup-fn_6_auto (fn {}
                                           {:inject :my-value})
                         context (setup-fn_6_auto)]
                     (it "test 1"
                         (fn {}
                           (assert.equal context.inject :my-value))))
                   (let [setup-fn_6_auto (fn {}
                                           {:inject :my-value})
                         context (setup-fn_6_auto)]
                     (it "test 2"
                         (fn {}
                           (assert.equal context.inject :my-value))))))

