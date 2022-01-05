local function _1_()
  local function _2_()
    local context
    do
      local tbl_15_auto = {}
      local i_16_auto = #tbl_15_auto
      for a, b in p do
        local val_17_auto = a
        if (nil ~= val_17_auto) then
          i_16_auto = (i_16_auto + 1)
          do end (tbl_15_auto)[i_16_auto] = val_17_auto
        else
        end
      end
      context = tbl_15_auto
    end
    return assert["true"](true)
  end
  busted.it("test 1", _2_)
  local function _4_()
    local context
    do
      local tbl_15_auto = {}
      local i_16_auto = #tbl_15_auto
      for a, b in p do
        local val_17_auto = a
        if (nil ~= val_17_auto) then
          i_16_auto = (i_16_auto + 1)
          do end (tbl_15_auto)[i_16_auto] = val_17_auto
        else
        end
      end
      context = tbl_15_auto
    end
    return assert["false"](false)
  end
  return busted.it("test 2", _4_)
end
return busted.describe("test suite", _1_)
