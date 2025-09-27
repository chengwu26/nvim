--- Improve csv/tsv

---@type LazySpec
return {
  "hat0uma/csvview.nvim",
  ---@module "csvview"
  ---@type CsvView.Options
  cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
  ft = { "csv", "tsv" },
  opts = {
    parser = {
      -- The comment prefix characters
      -- If the line starts with one of these characters, it is treated as a comment.
      -- Comment lines are not displayed in tabular format.
      -- You can also specify it on the command line.
      -- e.g:
      -- :CsvViewEnable comment=#
      --- @type string[]
      comments = { "#", "//" },

      -- The quote character
      -- If a field is enclosed in this character, it is treated as a single field and the delimiter in it will be ignored.
      -- e.g:
      --  quote_char= "'"
      -- You can also specify it on the command line.
      -- e.g:
      -- :CsvViewEnable quote_char='
      --- @type string
      quote_char = "\"",
    },
    keymaps = {
      -- Text objects for selecting fields
      textobject_field_inner = { "if", mode = { "o", "x" } },
      textobject_field_outer = { "af", mode = { "o", "x" } },
      -- Excel-like navigation:
      -- Use <Tab> and <S-Tab> to move horizontally between fields.
      -- Use <Enter> and <S-Enter> to move vertically between rows and place the cursor at the end of the field.
      -- Note: In terminals, you may need to enable CSI-u mode to use <S-Tab> and <S-Enter>.
      jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
      jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
      jump_next_row = { "<Enter>", mode = { "n", "v" } },
      jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
    },
  },
}
