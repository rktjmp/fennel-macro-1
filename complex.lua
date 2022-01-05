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
    local function _7_()
      return {assert["true"](true)}
    end
    return it("test 1", _7_)
  end
  _2_()
  local function _8_()
    local context
    local function _9_()
      local tbl_12_auto = {}
      for a in b do
        local _10_, _11_ = a
        if ((nil ~= _10_) and (nil ~= _11_)) then
          local k_13_auto = _10_
          local v_14_auto = _11_
          tbl_12_auto[k_13_auto] = v_14_auto
        else
        end
      end
      return tbl_12_auto
    end
    context = _9_()
    local function _13_()
      return {assert["false"](false)}
    end
    return it("test 2", _13_)
  end
  return _8_()
end
return (require("busted")).describe("test suite", _1_)
