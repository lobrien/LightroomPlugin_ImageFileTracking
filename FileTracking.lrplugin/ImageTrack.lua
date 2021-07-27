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
            local status, err = processPhoto(outFile, photo)
            if status then
                if i % 100 == 0 then
                    logger:trace(i.." photos processed")
                end
            else
                logger:trace("Error processing photo " .. tostring(i) .. ": ".. err)
            end
        end
        io.close()
        logger:trace("Finished processing")
    end
end )

function processPhoto(outFile, photo)
    local folder = photo:getRawMetadata('path') or 'NA'
    local isAvailable = photo:checkPhotoAvailability() or false
    local createdTime = photo:getRawMetadata('dateTimeOriginal') or 0
    outFile:write(folder .. "," .. tostring(isAvailable) .. "," .. tostring(createdTime) .. "\n")
    return true, nil
end