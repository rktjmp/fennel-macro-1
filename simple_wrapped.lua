local function _1_()
  local function _2_()
    local context
    local function _3_()
      return {inject = "my-value"}
    end
    context = _3_()
    local function _4_()
      return {assert.equal(context.inject, "my-value")}
    end
    return it("test 1", _4_)
  end
  _2_()
  local function _5_()
    local context
    local function _6_()
      return {inject = "my-value"}
    end
    context = _6_()
    local function _7_()
      return {assert.equal(context.inject, "my-value")}
    end
    return it("test 2", _7_)
  end
  return _5_()
end
return (require("busted")).describe("testing my module", _1_)
