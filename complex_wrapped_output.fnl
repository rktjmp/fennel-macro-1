((. (require :busted) :describe) "test suite"
                                 (fn {}
                                   (do
                                     ((fn {}
                                        (local context
                                               ((fn {}
                                                  (collect [a b p]
                                                    a))))
                                        (it "test 1"
                                            (fn {}
                                              [(assert.true true)]))))
                                     ((fn {}
                                        (local context
                                               ((fn {}
                                                  (collect [a b p]
                                                    a))))
                                        (it "test 2"
                                            (fn {}
                                              [(assert.false false)])))))))

