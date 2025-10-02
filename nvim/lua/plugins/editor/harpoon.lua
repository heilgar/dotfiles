return {
    "ThePrimeagen/harpoon",
    keys = {
        { "<leader>ma", function() require("harpoon.mark").add_file() end, desc = "Harpoon add file" },
        { "<leader>mm", function() require("harpoon.ui").toggle_quick_menu() end, desc = "Harpoon menu" },
        { "<leader>m1", function() require("harpoon.ui").nav_file(1) end, desc = "Harpoon file 1" },
        { "<leader>m2", function() require("harpoon.ui").nav_file(2) end, desc = "Harpoon file 2" },
        { "<leader>m3", function() require("harpoon.ui").nav_file(3) end, desc = "Harpoon file 3" },
        { "<leader>m4", function() require("harpoon.ui").nav_file(4) end, desc = "Harpoon file 4" },
        { "<leader>mn", function() require("harpoon.ui").nav_next() end, desc = "Harpoon next" },
        { "<leader>mp", function() require("harpoon.ui").nav_prev() end, desc = "Harpoon prev" },
    },
    config = function()
        require('harpoon').setup({
            save_on_toggle = false,
            save_on_change = true,
            enter_on_sendcmd = false,
            tmux_autoclose_windows = false,
            excluded_filetypes = { "harpoon" },
            mark_branch = false,
            tabline = false,
            tabline_prefix = "   ",
            tabline_suffix = "   ",
        })
    end
}

