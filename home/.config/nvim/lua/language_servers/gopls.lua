return {
    merge_with_default = true,
    settings = {
        gopls = {
            ["ui.inlayhints.hints"] = {
                compositeLiteralFields = true,
                constantValues = true,
                parameterNames = true
            }
        },
    }
}
