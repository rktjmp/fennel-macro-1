local function _1_()
  local function _2_()
    local context
    for a, b in p do
    end
    context = nil
    return assert["true"](true)
  end
  busted.it("test 1", _2_)
  local function _3_()
    local context
    for a, b in p do
    end
    context = nil
    return assert["false"](false)
  end
  return busted.it("test 2", _3_)
end
return busted.describe("test suite", _1_)
