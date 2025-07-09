local utils = require("utils")

local M = {}

local callbacks = {}
local handle_count = 1

function M.setup()
    utils.set_keymap_list({
        {
            "<Leader>q",
            function()
                for _, cb in ipairs(callbacks) do
                    if cb ~= nil then
                        cb()
                    end
                end
            end,
        },
    })
end

function M.register_on_close_cb(cb)
    assert(type(cb) == "function", "Callback must be a function")

    local handle = handle_count
    handle_count = handle_count + 1
    table.insert(callbacks, cb)

    return handle
end

function M.remove_on_close_cb(cb_handle)
    assert(type(cb_handle) == "number", "Callback handle must be a number")
    assert(cb_handle > 0 and cb_handle <= #callbacks, "Invalid callback handle")
    assert(callbacks[cb_handle] ~= nil, "Callback does not exist")

    callbacks[cb_handle] = nil
end

return M
