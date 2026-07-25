local lsp_pickers = {
    {
        "<leader>ld",
        "definition",
        "LSP: Definitions",
    },
    {
        "<leader>lD",
        "declaration",
        "LSP: Declarations",
    },
    {
        "<leader>lm",
        "implementation",
        "LSP: Implementations",
    },
    {
        "<leader>lo",
        "document_symbol",
        "LSP: Document symbols",
    },
    {
        "<leader>lR",
        "references",
        "LSP: References",
    },
    {
        "<leader>lt",
        "type_definition",
        "LSP: Type definitions",
    },
    {
        "<leader>lw",
        "workspace_symbol_live",
        "LSP: Workspace symbols",
    },
}

local keys = {
    {
        "<leader>lx",
        function()
            require("mini.extra").pickers.diagnostic({ scope = "current" })
        end,
        desc = "LSP: Buffer diagnostics",
    },
}

local function pick_lsp(scope)
    return function()
        require("mini.extra").pickers.lsp({ scope = scope })
    end
end

for _, picker in ipairs(lsp_pickers) do
    table.insert(keys, {
        picker[1],
        pick_lsp(picker[2]),
        desc = picker[3],
    })
end

return {
    "nvim-mini/mini.extra",
    version = "0.17.0",
    dependencies = {
        {
            "nvim-mini/mini.pick",
            opts = {},
        },
    },
    opts = {},
    keys = keys,
}
