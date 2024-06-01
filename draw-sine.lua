-- Aseprite script to draw a sine wave with specified wave frequency and amplitude dampening
-- Written by Dylmm, 2022
-- https://github.com/Dylmm/aseprite-scripts

-- Open dialog, ask user for sin wave parameters
function userInput()
    -- Create dialog for parameters
    local dlg = Dialog()
    dlg:check{ id="useselection", label="Selection:", selected=false }
    dlg:number{ id="wavefrequency", label="Wave Frequency:", decimals=2, text = "5"}
    dlg:number{ id="wavedampening", label="Wave Dampening:", decimals=2, text = "1" }
    dlg:check{ id="fill", label="Fill:", selected=true }
    dlg:button{ id="ok", text="OK" }
    dlg:button{ id="cancel", text="Cancel" }
    dlg:show()
    return dlg.data
end

-- Draws the specified sin wave
function drawSine(useselection, wavefrequency,wavedampening,fill)
    local image = app.image
    local copy = image:clone()
    
    --In selection bounds
    if useselection then 
        local rectsel = app.activeSprite.selection.bounds
        
        --x
        zx = rectsel.x - 1
        mx = rectsel.width + zx + 1
        --y
        py = (rectsel.height / 2) + rectsel.y
        my = rectsel.y - py 
        
        for x = zx, mx do
            if (x > zx and x < mx) then
                ny = math.floor( math.sin((zx-x)/((zx-mx+1) /(wavefrequency * 2 * math.pi))) * (rectsel.height-1)) / (2 * wavedampening) + (rectsel.y+(rectsel.height / 2))
                if fill then 
                    if ny < py then 
                        incrementdirection = 1
                    else
                        incrementdirection = -1
                    end
                    for fy = ny, py, incrementdirection do
                        copy:drawPixel(x, fy, app.fgColor)
                    end
                    py = ny
                end
				copy:drawPixel(x, ny, app.fgColor)
            end
        end
    app.activeCel.image:drawImage(copy)
    
    --Full selection
    else
        zx = 0
        py = image.height / 2
        mx = image.width + 1 
        
        for x = zx, mx do
            if (x >= zx and x <= mx) then
                ny = math.floor( math.sin(x/((mx-1) /(wavefrequency* 2 * math.pi))) * image.height ) / (2 * wavedampening) + image.height / 2
                if fill then 
                    if ny < py then 
                        incrementdirection = 1
                    else
                        incrementdirection = -1
                    end
                    for fy = ny, py, incrementdirection do
                        copy:drawPixel(x-1, fy, app.fgColor)
                    end
                    py = ny
                end
				copy:drawPixel(x, ny, app.fgColor)
            end
        end
    app.activeCel.image:drawImage(copy)
    end
end

-- Run script
do
    local userSine = userInput()
    if userSine.ok then
        drawSine(userSine.useselection,userSine.wavefrequency,userSine.wavedampening,userSine.fill)
    end
end
