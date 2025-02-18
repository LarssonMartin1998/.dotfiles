return {
    "sphamba/smear-cursor.nvim",
    opts = {
        smear_between_buffers = true,

        min_horizontal_distance_smear = 3,
        min_vertical_distance_smear = 2,

        scroll_buffer_space = true,
        smear_insert_mode = false,

        cursor_color = "#FFCC66",
        transparent_bg_fallback_color = "#303030",

        stiffness = 0.85,
        trailing_stiffness = 0.7,
        distance_stop_animating = 0.5,
    },
}
