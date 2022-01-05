local function _1_()
  local function _2_()
    local context
    local function _3_()
      local parsed
      do
        local tbl_15_auto = {}
        local i_16_auto = #tbl_15_auto
        for _, remote in ipairs(refs) do
          local val_17_auto = remotes.parse(remote)
          if (nil ~= val_17_auto) then
            i_16_auto = (i_16_auto + 1)
            do end (tbl_15_auto)[i_16_auto] = val_17_auto
          else
          end
        end
        parsed = tbl_15_auto
      end
      return {remotes = parsed}
    end
    context = _3_()
    local function _5_()
      return {assert["true"](true)}
    end
    return it("test 1", _5_)
  end
  _2_()
  local function _6_()
    local context
    local function _7_()
      local parsed
      do
        local tbl_15_auto = {}
        local i_16_auto = #tbl_15_auto
        for _ in remote do
          local val_17_auto = remotes.parse(remote)
          if (nil ~= val_17_auto) then
            i_16_auto = (i_16_auto + 1)
            do end (tbl_15_auto)[i_16_auto] = val_17_auto
          else
          end
        end
        parsed = tbl_15_auto
      end
      return {remotes = parsed}
    end
    context = _7_()
    local function _9_()
      return {assert["false"](false)}
    end
    return it("test 2", _9_)
  end
  return _6_()
end
return (require("busted")).describe("tags", _1_)
