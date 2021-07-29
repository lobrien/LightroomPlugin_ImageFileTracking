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
local LrTasks = import 'LrTasks'

local logger = LrLogger('NewCollectionPlugin')
logger:enable("logfile")
local log = logger:quickf('info')

local function has_value(tab, val)
    for i, v in ipairs(tab) do
        if v == val then
            return true
        end
    end
    return false
end

local function processPhoto(col, photo)
    --photo.addOrRemoveFromTargetCollection()
    col:addPhotos({ photo })
    return true, nil
end

local function getNamedCollection(cols, name)
    for i, c in ipairs(cols) do
        if c:getName() == name then
            return c, nil
        end
    end
    return nil, 'Collection not found'
end

LrTasks.startAsyncTask(function ()
    logger:trace('Starting image processing')

    local catalog = LrApplication.activeCatalog()
    logger:trace('Got catalog')
    local cols = catalog:getChildCollections()
    -- need to figure this one out
    --local col = cols[1]
    local col = getNamedCollection(cols, "TempCollection")
    logger:trace(tostring(col))
    -- iterate over cols
    for i, col in ipairs(cols) do
        logger:trace('Processing collection: ' .. col:getName() .. "," .. col.localIdentifier)
    end
    --  process all images in catalog
    local photos = catalog:getAllPhotos()
    logger:trace("Got photos")
    catalog:withWriteAccessDo( "add to target collection", function(context) 
        for i,photo in ipairs(photos) do
            -- type of photo is LrPhoto
            local status, err = LrTasks.pcall(processPhoto, col, photo)
            if err ~= nil then
                logger:trace(i .. " bad photo" .. tostring(err))
            end
            if i % 100 == 0 then
                logger:trace(i.." photos processed")
            end
        end
    end )
end )

