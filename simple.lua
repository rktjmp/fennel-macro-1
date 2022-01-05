local function _1_()
  local function _2_()
    local context
    local function _3_()
      return {inject = "my-value"}
    end
    context = _3_()
    return assert.equal(context.inject, "my-value")
  end
  busted.it("test 1", _2_)
  local function _4_()
    local context
    local function _5_()
      return {inject = "my-value"}
    end
    context = _5_()
    return assert.equal(context.inject, "my-value")
  end
  return busted.it("test 2", _4_)
end
return busted.describe("testing my module", _1_)
