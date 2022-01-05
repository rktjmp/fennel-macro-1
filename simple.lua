local function _1_()
  do
    local setup_fn_6_auto
    local function _2_()
      return {inject = "my-value"}
    end
    setup_fn_6_auto = _2_
    local context = setup_fn_6_auto()
    local function _3_()
      return assert.equal(context.inject, "my-value")
    end
    it("test 1", _3_)
  end
  local setup_fn_6_auto
  local function _4_()
    return {inject = "my-value"}
  end
  setup_fn_6_auto = _4_
  local context = setup_fn_6_auto()
  local function _5_()
    return assert.equal(context.inject, "my-value")
  end
  return it("test 2", _5_)
end
return busted.describe("testing my module", _1_)
