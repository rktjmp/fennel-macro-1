local function _1_()
  local function _2_()
    local context = {inject = "my-value"}
    return assert.equal(context.inject, "my-value")
  end
  busted.it("test 1", _2_)
  local function _3_()
    local context = {inject = "my-value"}
    return assert.equal(context.inject, "my-value")
  end
  return busted.it("test 2", _3_)
end
return busted.describe("testing my module", _1_)
