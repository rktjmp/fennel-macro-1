local function _1_()
  do
    local setup_fn_6_auto
    local function _2_()
      local tbl_12_auto = {}
      for a, b in p do
        local _3_, _4_ = a
        if ((nil ~= _3_) and (nil ~= _4_)) then
          local k_13_auto = _3_
          local v_14_auto = _4_
          tbl_12_auto[k_13_auto] = v_14_auto
        else
        end
      end
      return tbl_12_auto
    end
    setup_fn_6_auto = _2_
    local context = setup_fn_6_auto()
    local function _6_()
      return assert["true"](true)
    end
    it("test 1", _6_)
  end
  local setup_fn_6_auto
  local function _7_()
    local tbl_12_auto = {}
    for a, b in p do
      local _8_, _9_ = a
      if ((nil ~= _8_) and (nil ~= _9_)) then
        local k_13_auto = _8_
        local v_14_auto = _9_
        tbl_12_auto[k_13_auto] = v_14_auto
      else
      end
    end
    return tbl_12_auto
  end
  setup_fn_6_auto = _7_
  local context = setup_fn_6_auto()
  local function _11_()
    return assert["false"](false)
  end
  return it("test 2", _11_)
end
return busted.describe("test suite", _1_)
