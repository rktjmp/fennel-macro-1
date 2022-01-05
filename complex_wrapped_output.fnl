((. (require :busted) :describe) :tags
                                 (fn {}
                                   (do
                                     ((fn {}
                                        (local context
                                               ((fn {}
                                                  (let [parsed (icollect [_ remote (ipairs refs)]
                                                                 (remotes.parse remote))]
                                                    {:remotes parsed}))))
                                        (it "test 1"
                                            (fn {}
                                              [(assert.true true)]))))
                                     ((fn {}
                                        (local context
                                               ((fn {}
                                                  (let [parsed (icollect [_ remote (ipairs refs)]
                                                                 (remotes.parse remote))]
                                                    {:remotes parsed}))))
                                        (it "test 2"
                                            (fn {}
                                              [(assert.false false)])))))))

