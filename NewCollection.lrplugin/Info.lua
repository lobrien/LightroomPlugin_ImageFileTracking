return {
    VERSION = { major = 0, minor = 1, revision = 1, },

    -- Specify a basic Lightroom Plugin info
    NAME = "All Photo Collection",
    AUTHOR = "Larry O'Brien",
    DESCRIPTION = "A plugin to track images in Lightroom.",
    LICENSE = "MIT",
    URL = "",

    LrSdkVersion = 9.0,
    LrSdkMinVersion = 4.0,

    LrToolkitIdentifier = "net.knowing.imagetrack",
    LrPluginName = "NewCollection",
    LrPluginInfoUrl = "https://github.com/lobrien/LightroomPlugin_ImageFileTracking",
    LrLibraryMenuItems = {
        {
            title = "Collection",
            file = "ImageTrack.lua"
        }
    }
}