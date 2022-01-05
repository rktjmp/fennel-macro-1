local function _1_()
  local function _2_()
    local context
    local function _3_()
      for a, b in p do
      end
      return nil
    end
    context = _3_()
    return assert["true"](true)
  end
  busted.it("test 1", _2_)
  local function _4_()
    local context
    local function _5_()
      for a in b do
      end
      return nil
    end
    context = _5_()
    return assert["false"](false)
  end
  return busted.it("test 2", _4_)
end
return busted.describe("test suite", _1_)
