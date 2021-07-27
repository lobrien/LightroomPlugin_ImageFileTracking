-- Implementation of Lightroom plugin ImageTrack

local LrApplication = import 'LrApplication'
local LrDialogs = import 'LrDialogs'
local LrTasks = import 'LrTasks'
local LrLogger = import 'LrLogger'
local LrPathUtils = import 'LrPathUtils'
local LrFileUtils = import 'LrFileUtils'
local LrDialogs = import 'LrDialogs'
local LrDate = import 'LrDate'
local LrStringUtils = import 'LrStringUtils'

local logger = LrLogger('HelloWorldPlugin')
logger:enable("print")
local log = logger:quickf('info')

LrTasks.startAsyncTask(function ()
    log('Starting image processing')

    local catalog = LrApplication.getCatalog()

    --  process all images in catalog
    local photos = catalog:getAllPhotos()
    -- create file for writing
    local outFile = io.open("photo_paths.csv", "w")

    local i = 0
    for photo in photos do
        -- type of photo is LrPhoto
        processPhoto(outFile, photo)
        i = i + 1
        if i % 100 == 0 then
            log.write(i.." photos processed")
    end
    io.close()
end )

local function processPhoto(outFile, photo)
    local fileName = photo:getFormattedMetadata('fileName')
    local folder = photo:getFormattedMetadata('folderName')
    outFile:write(folder .. "," .. fileName .. "\n")
end