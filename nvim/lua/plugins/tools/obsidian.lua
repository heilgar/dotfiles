return {
    "epwalsh/obsidian.nvim",
    version = "*",  -- recommended, use latest release instead of latest commit
    ft = "markdown", -- Only load for markdown files
    cmd = {
        "ObsidianOpen", "ObsidianNew", "ObsidianQuickSwitch", "ObsidianFollowLink",
        "ObsidianBacklinks", "ObsidianTags", "ObsidianToday", "ObsidianYesterday",
        "ObsidianTomorrow", "ObsidianDailies", "ObsidianSearch", "ObsidianLink",
        "ObsidianLinkNew", "ObsidianWorkspace"
    },
    keys = {
        { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "New Obsidian note" },
        { "<leader>oo", "<cmd>ObsidianOpen<cr>", desc = "Open Obsidian note" },
        { "<leader>os", "<cmd>ObsidianQuickSwitch<cr>", desc = "Quick switch notes" },
        { "<leader>of", "<cmd>ObsidianFollowLink<cr>", desc = "Follow link under cursor" },
        { "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "Show backlinks" },
        { "<leader>ot", "<cmd>ObsidianTags<cr>", desc = "Search by tags" },
        { "<leader>od", "<cmd>ObsidianToday<cr>", desc = "Today's note" },
        { "<leader>oy", "<cmd>ObsidianYesterday<cr>", desc = "Yesterday's note" },
        { "<leader>oT", "<cmd>ObsidianTomorrow<cr>", desc = "Tomorrow's note" },
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    opts = {
        workspaces = {
            {
                name = "personal",
                path = "~/vaults/personal",
            },
            {
                name = "work",
                path = "~/vaults/work",
            },
        },
        
        completion = {
            nvim_cmp = true,
            min_chars = 2,
        },
        
        mappings = {
            -- Smart action depending on context
            ["gf"] = {
                action = function()
                    return require("obsidian").util.gf_passthrough()
                end,
                opts = { noremap = false, expr = true, buffer = true },
            },
            -- Toggle check-boxes
            ["<leader>ch"] = {
                action = function()
                    return require("obsidian").util.toggle_checkbox()
                end,
                opts = { buffer = true },
            },
        },
        
        new_notes_location = "current_dir",
        
        note_id_func = function(title)
            -- Create note IDs from title if given, otherwise use timestamp
            local suffix = ""
            if title ~= nil then
                suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
            else
                suffix = tostring(os.time())
            end
            return suffix
        end,
        
        note_frontmatter_func = function(note)
            local out = { id = note.id, aliases = note.aliases, tags = note.tags }
            if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
                for k, v in pairs(note.metadata) do
                    out[k] = v
                end
            end
            return out
        end,
        
        templates = {
            subdir = "templates",
            date_format = "%Y-%m-%d",
            time_format = "%H:%M",
        },
        
        follow_url_func = function(url)
            vim.fn.jobstart({"open", url})
        end,
    },
}

