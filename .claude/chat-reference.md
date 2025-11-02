# FiveM Chat Resource Reference

**Documentation:** https://docs.fivem.net/docs/resources/chat/

## Overview

The chat resource provides a NUI-based chat interface for FiveM servers. It's a core resource that handles in-game chat messages, commands, and suggestions.

**Repository:** https://github.com/citizenfx/cfx-server-data/tree/master/resources/%5Bgameplay%5D/chat

## Installation

The chat resource is included in the default cfx-server-data package. Ensure it's started in your server.cfg:

```cfg
ensure chat
```

**Note:** The chat resource requires webpack for building. If it fails to start, basic chat functionality may be limited.

## Client-Side Exports

### addMessage

Displays a message in the chat interface.

```lua
-- Lua
exports.chat:addMessage({
    color = {255, 0, 0},              -- RGB color array (optional)
    multiline = true,                  -- Allow multiline messages (optional)
    args = {"Author", "Message text"}  -- Array of strings
})

-- Simple message
exports.chat:addMessage({
    args = {"System", "Server restarting in 5 minutes"}
})

-- Colored message
exports.chat:addMessage({
    color = {0, 255, 0},
    args = {"Success", "Item purchased!"}
})

-- Multiline message
exports.chat:addMessage({
    multiline = true,
    args = {"Info", "Line 1\nLine 2\nLine 3"}
})
```

```js
// JavaScript
exports.chat.addMessage({
    color: [255, 0, 0],
    multiline: true,
    args: ["Author", "Message text"]
});
```

```cs
// C#
BaseScript.TriggerEvent("chat:addMessage", new {
    color = new[] {255, 0, 0},
    multiline = true,
    args = new[] {"Author", "Message text"}
});
```

### addSuggestion

Adds a command suggestion to the chat autocomplete system.

```lua
-- Lua
exports.chat:addSuggestion('/command', 'Command description', {
    { name = "argument1", help = "First argument description" },
    { name = "argument2", help = "Second argument description" }
})

-- Example: Add /teleport suggestion
exports.chat:addSuggestion('/teleport', 'Teleport to coordinates', {
    { name = "x", help = "X coordinate" },
    { name = "y", help = "Y coordinate" },
    { name = "z", help = "Z coordinate" }
})

-- Command with no arguments
exports.chat:addSuggestion('/coords', 'Show your coordinates')
```

```js
// JavaScript
exports.chat.addSuggestion('/command', 'Command description', [
    { name: "argument1", help: "First argument description" }
]);
```

## Server-Side Exports

### addMessage

Send a message to a specific player or all players from server-side.

```lua
-- Send to specific player
exports.chat:addMessage(source, {
    color = {255, 0, 0},
    args = {"Server", "Welcome to the server!"}
})

-- Send to all players (-1)
exports.chat:addMessage(-1, {
    color = {0, 255, 0},
    args = {"Announcement", "Server will restart soon"}
})
```

### registerMessageHook

Intercept and modify chat messages before they're displayed.

```lua
exports.chat:registerMessageHook(function(source, outMessage, hookRef)
    -- source: Player who sent the message
    -- outMessage: Table containing message data
    -- hookRef: Reference to prevent infinite loops

    -- Modify the message
    outMessage.args[2] = "[FILTERED] " .. outMessage.args[2]

    -- Return false to block the message
    -- return false

    -- Return true to allow (after modifications)
    return true
end)

-- Example: Profanity filter
local bannedWords = {"badword1", "badword2", "badword3"}

exports.chat:registerMessageHook(function(source, outMessage, hookRef)
    local message = outMessage.args[2]

    for _, word in ipairs(bannedWords) do
        if string.find(message:lower(), word:lower()) then
            -- Block the message
            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 0, 0},
                args = {"System", "Your message contains inappropriate language"}
            })
            return false
        end
    end

    return true
end)

-- Example: Add player name prefix
exports.chat:registerMessageHook(function(source, outMessage, hookRef)
    local playerName = GetPlayerName(source)
    outMessage.args[1] = "[" .. source .. "] " .. playerName
    return true
end)
```

### registerMode

Register a custom chat mode with specific behavior.

```lua
exports.chat:registerMode({
    name = "modeName",           -- Mode identifier
    displayName = "Mode Display", -- Display name in chat
    color = "#FF0000",            -- Hex color
    isDefault = false,            -- Whether this is the default mode
    range = 100.0                 -- Message range (optional)
})

-- Example: Local chat mode
exports.chat:registerMode({
    name = "local",
    displayName = "Local",
    color = "#FFFF00",
    range = 20.0
})

-- Example: Admin chat mode
exports.chat:registerMode({
    name = "admin",
    displayName = "Admin",
    color = "#FF0000",
    isDefault = false
})
```

## Client-Side Events

### chat:addMessage

Trigger a chat message display (preferred over deprecated chatMessage).

```lua
-- Client-side trigger
TriggerEvent('chat:addMessage', {
    color = {255, 0, 0},
    args = {"System", "Message text"}
})

-- Server-side trigger to client
TriggerClientEvent('chat:addMessage', source, {
    color = {0, 255, 0},
    args = {"Server", "Welcome!"}
})

-- Trigger to all clients
TriggerClientEvent('chat:addMessage', -1, {
    args = {"Announcement", "Server event starting!"}
})
```

### chat:addSuggestion

Add a single command suggestion.

```lua
TriggerEvent('chat:addSuggestion', '/command', 'Description', {
    { name = "arg1", help = "Argument help" }
})
```

### chat:addSuggestions

Add multiple suggestions at once.

```lua
TriggerEvent('chat:addSuggestions', {
    ['/command1'] = {
        help = "Command 1 description",
        params = {
            { name = "arg1", help = "First argument" }
        }
    },
    ['/command2'] = {
        help = "Command 2 description",
        params = {
            { name = "arg1", help = "First argument" },
            { name = "arg2", help = "Second argument" }
        }
    }
})
```

### chat:removeSuggestion

Remove a previously added suggestion.

```lua
TriggerEvent('chat:removeSuggestion', '/command')

-- Example: Remove suggestion when resource stops
AddEventHandler('onClientResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        TriggerEvent('chat:removeSuggestion', '/mycommand')
    end
end)
```

### chat:addTemplate

Define custom message templates.

```lua
TriggerEvent('chat:addTemplate', 'templateName', '<div class="custom-style">{0}</div>')

-- Example: Custom styled messages
TriggerEvent('chat:addTemplate', 'admin',
    '<div style="background-color: red; padding: 5px;">{0}</div>')
```

### chat:clear

Clear all chat messages.

```lua
-- Client-side
TriggerEvent('chat:clear')

-- Server-side to specific player
TriggerClientEvent('chat:clear', source)

-- Server-side to all players
TriggerClientEvent('chat:clear', -1)
```

### chatMessage (Deprecated)

**Note:** This event is deprecated. Use `chat:addMessage` instead.

```lua
-- Old way (deprecated)
TriggerEvent('chatMessage', "Author", {255, 0, 0}, "Message")

-- New way (recommended)
TriggerEvent('chat:addMessage', {
    color = {255, 0, 0},
    args = {"Author", "Message"}
})
```

## Server-Side Events

### chatMessage

Triggered when a player sends a chat message.

```lua
AddEventHandler('chatMessage', function(source, name, message)
    -- source: Player ID
    -- name: Player name
    -- message: Message text

    -- Cancel the default chat behavior
    CancelEvent()

    -- Process the message
    print(name .. " said: " .. message)

    -- Send custom message to all players
    TriggerClientEvent('chat:addMessage', -1, {
        args = {name, message}
    })
end)

-- Example: Command handler
AddEventHandler('chatMessage', function(source, name, message)
    if string.sub(message, 1, 1) == "/" then
        -- It's a command, let the command handler deal with it
        return
    end

    -- Cancel default message
    CancelEvent()

    -- Add custom formatting
    TriggerClientEvent('chat:addMessage', -1, {
        color = {255, 255, 255},
        args = {"[" .. source .. "] " .. name, message}
    })
end)
```

## Common Use Cases

### Proximity Chat

```lua
-- Server-side
AddEventHandler('chatMessage', function(source, name, message)
    if string.sub(message, 1, 1) == "/" then
        return -- Let commands through
    end

    CancelEvent()

    local sourceCoords = GetEntityCoords(GetPlayerPed(source))
    local players = GetPlayers()

    for _, player in ipairs(players) do
        local targetCoords = GetEntityCoords(GetPlayerPed(player))
        local distance = #(sourceCoords - targetCoords)

        if distance <= 20.0 then -- 20 meter range
            TriggerClientEvent('chat:addMessage', player, {
                color = {255, 255, 255},
                args = {name, message}
            })
        end
    end
end)
```

### Roleplay Chat Modes

```lua
-- Server-side
local chatModes = {
    ['/me'] = { color = {255, 165, 0}, prefix = "* " },
    ['/do'] = { color = {0, 165, 255}, prefix = "* " },
    ['/ooc'] = { color = {128, 128, 128}, prefix = "[OOC] " }
}

AddEventHandler('chatMessage', function(source, name, message)
    for command, settings in pairs(chatModes) do
        if string.sub(message, 1, #command) == command then
            CancelEvent()

            local text = string.sub(message, #command + 2)

            TriggerClientEvent('chat:addMessage', -1, {
                color = settings.color,
                args = {settings.prefix .. name, text}
            })
            return
        end
    end
end)
```

### Staff Chat

```lua
-- Server-side
RegisterCommand('admin', function(source, args, rawCommand)
    if IsPlayerAceAllowed(source, 'command.admin') then
        local message = table.concat(args, " ")

        -- Send to all admins
        local players = GetPlayers()
        for _, player in ipairs(players) do
            if IsPlayerAceAllowed(player, 'command.admin') then
                TriggerClientEvent('chat:addMessage', player, {
                    color = {255, 0, 0},
                    args = {"[ADMIN] " .. GetPlayerName(source), message}
                })
            end
        end
    end
end, false)

-- Client-side: Add suggestion
exports.chat:addSuggestion('/admin', 'Send message to all administrators', {
    { name = "message", help = "Message to send" }
})
```

### Chat Logging

```lua
-- Server-side
AddEventHandler('chatMessage', function(source, name, message)
    -- Log to console
    print(string.format("[CHAT] %s (%s): %s", name, source, message))

    -- Log to file (requires file writing resource)
    -- Or log to database
    MySQL.Async.execute('INSERT INTO chat_logs (player_id, name, message, timestamp) VALUES (@id, @name, @msg, NOW())', {
        ['@id'] = source,
        ['@name'] = name,
        ['@msg'] = message
    })
end)
```

### Spam Prevention

```lua
-- Server-side
local playerMessages = {}
local SPAM_THRESHOLD = 3
local SPAM_TIME = 5000 -- milliseconds

AddEventHandler('chatMessage', function(source, name, message)
    if not playerMessages[source] then
        playerMessages[source] = {}
    end

    local currentTime = GetGameTimer()
    local messages = playerMessages[source]

    -- Clean old messages
    for i = #messages, 1, -1 do
        if currentTime - messages[i] > SPAM_TIME then
            table.remove(messages, i)
        end
    end

    -- Check spam
    if #messages >= SPAM_THRESHOLD then
        CancelEvent()
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            args = {"System", "Please don't spam!"}
        })
        return
    end

    table.insert(messages, currentTime)
end)
```

## Configuration

The chat resource uses NUI and can be customized via CSS/HTML. Customization files are located in:
- `resources/[gameplay]/chat/html/`

### Custom Styling

Edit `resources/[gameplay]/chat/html/index.css` to customize appearance:

```css
/* Example custom styles */
.message {
    background-color: rgba(0, 0, 0, 0.8);
    padding: 5px;
    margin: 2px 0;
}

.message-author {
    font-weight: bold;
    color: #00ff00;
}
```

## Best Practices

1. **Always cancel events when handling messages** to prevent duplicate displays
2. **Use chat:addMessage instead of chatMessage** (deprecated)
3. **Validate message content** server-side before broadcasting
4. **Implement rate limiting** to prevent spam
5. **Use colors consistently** for different message types
6. **Clean up suggestions** when resources stop
7. **Log chat messages** for moderation purposes
8. **Sanitize user input** to prevent HTML injection

## Troubleshooting

**Chat not showing:**
- Ensure chat resource is started
- Check for JavaScript errors in F8 console
- Verify NUI is functioning

**Messages not appearing:**
- Check if you're using correct event format
- Ensure colors are RGB arrays, not hex
- Verify args is an array with at least 2 elements

**Suggestions not working:**
- Make sure suggestion is added on client-side
- Check command name includes forward slash
- Verify suggestion format is correct

**Commands not working:**
- Ensure you're listening to chatMessage event
- Check if you're cancelling the event properly
- Verify command parsing logic

## Related Resources

- **baseevents** - Basic game events
- **spawnmanager** - Player spawning
- **sessionmanager** - Session management

## Official Links

- **Documentation:** https://docs.fivem.net/docs/resources/chat/
- **Source Code:** https://github.com/citizenfx/cfx-server-data/tree/master/resources/%5Bgameplay%5D/chat
- **Forums:** https://forum.cfx.re/
