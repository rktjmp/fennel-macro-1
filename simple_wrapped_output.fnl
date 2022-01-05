(busted.describe "testing my module"
                 (fn {}
                   (busted.it "test 1"
                              (fn {}
                                (local context
                                       ((fn {}
                                          {:inject :my-value})))
                                (assert.equal context.inject :my-value)))
                   (busted.it "test 2"
                              (fn {}
                                (local context
                                       ((fn {}
                                          {:inject :my-value})))
                                (assert.equal context.inject :my-value)))))

