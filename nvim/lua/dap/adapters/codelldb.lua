return {
    type = "server",
    port = "${port}",
    executable = {
        command = vim.fn.exepath("codelldb"), -- Update with your codelldb binary path
        args = { "--port", "${port}" },
    },
}
