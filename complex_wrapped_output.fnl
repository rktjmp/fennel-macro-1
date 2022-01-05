(busted.describe "test suite"
                 (fn {}
                   (busted.it "test 1"
                              (fn {}
                                (local context
                                       (icollect [a b p]
                                         a))
                                (assert.true true)))
                   (busted.it "test 2"
                              (fn {}
                                (local context
                                       (icollect [a b p]
                                         a))
                                (assert.false false)))))

