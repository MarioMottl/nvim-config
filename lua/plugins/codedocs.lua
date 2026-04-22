return {
    {
        "jeangiraldoo/codedocs.nvim",
        config = function()
            local s = require("codedocs.config.languages.utils").new_section

            require("codedocs").setup {
                languages = {
                    rust = {
                        default_style = "RustcDoc",
                        styles = {
                            RustcDoc = {
                                comment = {
                                    relative_position = "empty_target_or_above",
                                    indent = false,
                                    blocks = {
                                        s {
                                            name = "title",
                                            layout = { "/// ${%snippet_tabstop_idx:description}" },
                                        },
                                    },
                                },
                                func = {
                                    relative_position = "above",
                                    indent = false,
                                    blocks = {
                                        -- /// Brief one-sentence summary.
                                        s {
                                            name = "title",
                                            layout = { "/// ${%snippet_tabstop_idx:summary}" },
                                            insert_gap_between = { enabled = true, text = "///" },
                                        },
                                        -- /// # Errors
                                        -- ///
                                        -- /// When this returns Err(...).
                                        s {
                                            name = "errors",
                                            layout = {
                                                "/// # Errors",
                                                "///",
                                                "/// ${%snippet_tabstop_idx:description}",
                                            },
                                            insert_gap_between = { enabled = true, text = "///" },
                                        },
                                        -- /// # Panics
                                        -- ///
                                        -- /// When this panics.
                                        s {
                                            name = "panics",
                                            layout = {
                                                "/// # Panics",
                                                "///",
                                                "/// ${%snippet_tabstop_idx:description}",
                                            },
                                            insert_gap_between = { enabled = true, text = "///" },
                                        },
                                        -- /// # Examples
                                        -- ///
                                        -- /// ```
                                        -- /// example
                                        -- /// ```
                                        s {
                                            name = "examples",
                                            layout = {
                                                "/// # Examples",
                                                "///",
                                                "/// ```",
                                                "/// ${%snippet_tabstop_idx:example}",
                                                "/// ```",
                                            },
                                        },
                                    },
                                },
                            },
                        },
                    },
                },
            }
        end,
    },
}
