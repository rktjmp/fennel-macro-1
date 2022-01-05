((. (require :busted) :describe) "testing my module"
                                 (fn {}
                                   (do
                                     ((fn {}
                                        (local context
                                               ((fn {}
                                                  {:inject :my-value})))
                                        (it "test 1"
                                            (fn {}
                                              [(assert.equal context.inject
                                                             :my-value)]))))
                                     ((fn {}
                                        (local context
                                               ((fn {}
                                                  {:inject :my-value})))
                                        (it "test 2"
                                            (fn {}
                                              [(assert.equal context.inject
                                                             :my-value)])))))))

