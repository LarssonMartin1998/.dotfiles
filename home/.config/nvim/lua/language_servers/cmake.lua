return {
    cmd = { "cmake-language-server" },
    filetypes = { "cmake" },
    root_markers = {
        "CMakeLists.txt",
        "CMakePresets.json",
        "CTestConfig.cmake",
        "build",
        "cmake",
    },
    init_options = {
        buildDirectory = "build",
    },
}
