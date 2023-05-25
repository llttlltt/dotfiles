local M = {}

M.general = {
    n = {
        ["<C-h>"] = {"<cmd> TmuxNavigateLeft<CR>", "Window left"},
        ["<C-l>"] = {"<cmd> TmuxNavigateRight<CR>", "Window right"},
        ["<C-j>"] = {"<cmd> TmuxNavigateDown<CR>", "Window down"},
        ["<C-k>"] = {"<cmd> TmuxNavigateUp<CR>", "Window up"}
    }
}

M.dap = {
    plugin = true,
    n = {
        ["<leader>dr"] = {"<cmd> RustDebuggables <CR>", "Rust debugger"},
        ["<leader>db"] = {"<cmd> DapToggleBreakpoint <CR>", "Toggle breakpoint"},
        ["<leader>ds"] = {function()
            local widgets = require('dap.ui.widgets')
            local sidebar = widgets.sidebar(widgets.scopes)
            sidebar.open()
        end, "Open debugging sidebar"},
        ["<leader>dc"] = {"<cmd> DapContinue <CR>", "Continue execution"},
        ["<leader>dl"] = {"<cmd> DapShowLog <CR>", "Show log"},
        ["<leader>di"] = {"<cmd> DapStepInto <CR>", "Step into"},
        ["<leader>dO"] = {"<cmd> DapStepOut <CR>", "Step out"},
        ["<leader>do"] = {"<cmd> DapStepOver <CR>", "Step over"},
        ["<leader>dt"] = {"<cmd> DapTerminate <CR>", "Terminate debugging"}
    }
}

M.crates = {
    plugin = true,
    n = {
        ["<leader>rcu"] = {function()
            require('crates').upgrade_all_crates()
        end, "Update crates"}
    }
}

return M
