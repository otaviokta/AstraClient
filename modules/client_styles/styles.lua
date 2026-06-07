local resourceLoaders = {
    ["otui"] = g_ui.importStyle,
    ["otfont"] = g_fonts.importFont,
    ["ttf"] = g_fonts.importFont,
    ["otf"] = g_fonts.importFont,
    ["otps"] = g_particles.importParticle,
}

function init()
    local device = g_platform.getDevice()
    importResources("styles", "otui", device)
    importResources("fonts", "otfont", device)
    importResources("fonts", "ttf", device)
    importResources("fonts", "otf", device)
    importResources("particles", "otps", device)

    g_mouse.loadCursors('/data/cursors/cursors')
end

function terminate()
end

function importResources(dir, type, device)
    local path = '/' .. dir .. '/'
    local files = g_resources.listDirectoryFiles(path, true, false, true)
    for _, file in pairs(files) do
        if g_resources.isFileType(file, type) then
            local success, err = pcall(resourceLoaders[type], file)
            if not success then
                g_logger.warning("Failed to load resource: " .. tostring(file) .. " (" .. tostring(err) .. ")")
            end
        end
    end

    if device then
        local devicePath = g_platform.getDeviceShortName(device.type)
        if devicePath ~= "" then
            importResources(dir .. '/' .. devicePath, type)
        end
        local osPath = g_platform.getOsShortName(device.os)
        if osPath ~= "" then
            importResources(dir .. '/' .. osPath, type)
        end
    end
    return files
end

function reloadParticles()
    g_particles.terminate()
    local device = g_platform.getDevice()
    importResources("particles", "otps", device)
end
