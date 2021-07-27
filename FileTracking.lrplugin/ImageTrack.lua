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

local logger = LrLogger('FileTrackerPlugin')
logger:enable("logfile")
local log = logger:quickf('info')

LrTasks.startAsyncTask(function ()
    logger:trace('Starting image processing')

    local catalog = LrApplication.activeCatalog()

    logger:trace('Got catalog')
    --  process all images in catalog
    local photos = catalog:getAllPhotos()
    logger:trace("Got photos")
    -- create file for writing
    -- get desktop directory
    local home = LrPathUtils.getStandardFilePath('desktop')
    local fname = home .. '/photo_paths.csv'
    local outFile, err = io.open(fname, "w+")
    if outFile==nil then
        logger:trace("Couldn't open file: "..err)
    else
        logger:trace("Opened file")
        for i,photo in ipairs(photos) do
            -- type of photo is LrPhoto
            processPhoto(outFile, photo)
            if i % 100 == 0 then
                logger:trace(i.." photos processed")
            end
        end
        io.close()
        logger:trace("Finished processing")
    end
end )

function processPhoto(outFile, photo)
    local fileName = photo:getFormattedMetadata('fileName')
    local folder = photo:getRawMetadata('path')
    outFile:write(folder .. "," .. fileName .. "\n")
end