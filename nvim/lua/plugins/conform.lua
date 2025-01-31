return {
    "stevearc/conform.nvim",
    dependencies = { "mason.nvim" },
    lazy = true,
    cmd = "ConformInfo",
    event = { "VeryLazy" },
    keys = {
        {
            "<leader>cf",
            function()
                require("conform").format()
            end,
            mode = { "n", "v" },
            desc = "Format",
        },
    },
    config = function(_, opts)
        -- 初始化conform
        local conform = require("conform")
        conform.setup(opts)
        -- 个性化定制prettier
        conform.formatters.prettier = {
            -- 末尾增加参数，tab宽度为4个space
            append_args = { "--tab-width", "4" },
        }
    end,
    opts = {
        default_format_opts = {
            timeout_ms = 3000,
            async = false,
            quiet = false,
            lsp_format = "fallback",
        },
        formatters_by_ft = {
            lua = { "stylua" },
            sh = { "shfmt" },
            go = { "goimports", lsp_format = "fallback" },
            proto = { "common_protobuf", lsp_format = "fallback" },
            html = { "prettier", lsp_format = "fallback" },
            css = { "prettier", lsp_format = "fallback" },
            javascript = { "prettier", lsp_format = "fallback" },
            typescript = { "prettier", lsp_format = "fallback" },
        },
        formatters = {
            -- 参考官方 clang-format 进行定制：https://github.com/stevearc/conform.nvim/blob/master/lua/conform/formatters/clang-format.lua
            common_protobuf = {
                command = "clang-format",
                args = function()
                    -- 尝试向上查找 .clang-format 文件，如果找到则格式类型为 file，否则为预定义格式
                    local style =
                        "{BasedOnStyle: Google, IndentWidth: 2, ColumnLimit: 0, AlignConsecutiveAssignments: true, AlignConsecutiveDeclarations: true}"
                    local config_file = vim.fn.findfile(".clang-format", ".;")
                    if config_file ~= "" then
                        style = "file"
                    end
                    return {
                        "--assume-filename",
                        "$FILENAME",
                        "--style",
                        style,
                    }
                end,
            },
        },
    },
}
