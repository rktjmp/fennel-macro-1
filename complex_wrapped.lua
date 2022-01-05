local function _1_()
  local function _2_()
    local context
    local function _3_()
      local tbl_12_auto = {}
      for a, b in p do
        local _4_, _5_ = a
        if ((nil ~= _4_) and (nil ~= _5_)) then
          local k_13_auto = _4_
          local v_14_auto = _5_
          tbl_12_auto[k_13_auto] = v_14_auto
        else
        end
      end
      return tbl_12_auto
    end
    context = _3_()
    return assert["true"](true)
  end
  busted.it("test 1", _2_)
  local function _7_()
    local context
    local function _8_()
      local tbl_12_auto = {}
      for a, b in p do
        local _9_, _10_ = a
        if ((nil ~= _9_) and (nil ~= _10_)) then
          local k_13_auto = _9_
          local v_14_auto = _10_
          tbl_12_auto[k_13_auto] = v_14_auto
        else
        end
      end
      return tbl_12_auto
    end
    context = _8_()
    return assert["false"](false)
  end
  return busted.it("test 2", _7_)
end
return busted.describe("test suite", _1_)
