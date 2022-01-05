(busted.describe "test suite"
                 (fn {}
                   (let [setup-fn_6_auto (fn {}
                                           (collect [a b p]
                                             a))
                         context (setup-fn_6_auto)]
                     (it "test 1"
                         (fn {}
                           (assert.true true))))
                   (let [setup-fn_6_auto (fn {}
                                           (collect [a b p]
                                             a))
                         context (setup-fn_6_auto)]
                     (it "test 2"
                         (fn {}
                           (assert.false false))))))

