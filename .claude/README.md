# Claude AI Context Files for FiveM Server

This directory contains context and reference files to help Claude better understand and assist with your FiveM server development.

## Files Overview

### Core Context Files

#### [context.md](context.md)
Complete project context including:
- Server information (production & local)
- Configuration details
- Directory structure
- Common tasks and workflows
- Troubleshooting guide
- Development workflow
- Links to official documentation

#### [fivem-reference.md](fivem-reference.md)
Quick reference guide with:
- Resource manifest templates
- Server-side scripting examples
- Client-side scripting patterns
- Common natives usage
- Server configuration examples
- Console commands
- Best practices
- Debugging tips

#### Resource-Specific References

**[baseevents-reference.md](baseevents-reference.md)**
- Death and vehicle events
- Event parameters and usage
- Practical code examples
- Common use cases and best practices

**[chat-reference.md](chat-reference.md)**
- Chat exports and events
- Message formatting and styling
- Command suggestions system
- Custom chat modes and filters

**[mapmanager-reference.md](mapmanager-reference.md)**
- Map and game type management
- Creating custom maps
- Game mode system
- Map rotation and voting

**[spawnmanager-reference.md](spawnmanager-reference.md)**
- Player spawning system
- Spawn point management
- Auto-spawn configuration
- Custom spawn callbacks

**[txadmin-reference.md](txadmin-reference.md)**
- Server administration panel
- In-game admin menu
- Player management
- Monitoring and performance

### Configuration Files

#### [settings.local.json](settings.local.json)
Claude permissions for this project:
- Allowed bash commands
- Security settings

#### [config/docs.json](config/docs.json)
Documentation sources configuration:
- Links to official FiveM documentation
- Priority settings

### Project Files

#### [../.claudeignore](../.claudeignore)
Files excluded from Claude's context:
- Binary files (alpine/)
- Cache and logs
- Large resource files
- Build artifacts

## Official Documentation Links

All context files reference the official FiveM documentation:

- **Main Documentation:** https://docs.fivem.net/docs/
- **Server Manual:** https://docs.fivem.net/docs/server-manual/
- **Scripting Reference:** https://docs.fivem.net/docs/scripting-reference/
- **Natives:** https://docs.fivem.net/natives/
- **Baseevents:** https://docs.fivem.net/docs/resources/baseevents/

## How This Helps

These context files allow Claude to:

1. **Understand Your Project**
   - Server configuration and setup
   - Resource structure
   - Deployment workflow

2. **Provide Better Assistance**
   - Accurate FiveM-specific code
   - Server management commands
   - Best practices and patterns

3. **Reference Documentation**
   - Quick access to common patterns
   - Event handling examples
   - Native function usage

4. **Troubleshoot Issues**
   - Common problems and solutions
   - Error messages and fixes
   - Configuration issues

## Using These Files

These files are automatically available to Claude when working in this directory. You can:

- **Ask about FiveM concepts:** Claude has quick reference to common patterns
- **Request code examples:** Claude can reference templates and examples
- **Get project-specific help:** Claude understands your server setup
- **Troubleshoot issues:** Claude knows your configuration and common problems

## Example Questions You Can Ask

With these context files, Claude can better help with:

- "How do I create a new resource for my FiveM server?"
- "Show me how to track player deaths using baseevents"
- "What's the command to restart my server on production?"
- "How do I spawn a vehicle in my script?"
- "Help me debug why my resource isn't loading"
- "Create a vehicle entry restriction system"
- "How do I deploy my changes to the Ubuntu server?"

## Updating Context

To keep context current:

1. **Update context.md** when server configuration changes
2. **Add to fivem-reference.md** when you learn new patterns
3. **Update .claudeignore** to exclude large new files
4. **Add specific resource docs** (like baseevents) as needed

## Notes

- Context files are in Markdown format for readability
- Official FiveM docs are referenced, not copied
- Files are optimized for Claude's understanding
- Binary and large files are excluded via .claudeignore

## Need More Information?

If Claude needs additional context:
1. Ask to read specific project files
2. Request to fetch from official docs (https://docs.fivem.net/docs/)
3. Add new reference files to this directory

---

**Last Updated:** November 2, 2025
**Server:** Legacy Romania (109.123.240.14:30120)
**Status:** Production server running, local dev setup complete
