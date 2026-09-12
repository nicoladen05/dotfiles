# MCP on demand

Loads an MCP server's tools only for prompts that invoke it:

```text
/mcp:figma inspect this design: <url>
```

The tools are disconnected and removed from the active model context when the agent run settles.

## Setup

```bash
cd ~/.pi/agent/extensions/mcp-on-demand
npm install
```

Edit `mcp.json`, then run `/reload` in Pi.

HTTP server:

```json
{
  "servers": {
    "figma": { "url": "http://127.0.0.1:3845/mcp" }
  }
}
```

Stdio server:

```json
{
  "servers": {
    "example": {
      "command": "npx",
      "args": ["-y", "@example/mcp-server"],
      "env": { "API_KEY": "value" }
    }
  }
}
```

Only MCP tools are supported. OAuth, resources, prompts, sampling, and legacy SSE are not.
