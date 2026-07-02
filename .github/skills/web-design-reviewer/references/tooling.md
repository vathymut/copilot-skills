# Tooling Reference

## MCP Configuration

```json
{
  "mcpServers": {
    "playwright": {
      "command": "npx",
      "args": ["-y", "@playwright/mcp@latest", "--caps=vision"]
    }
  }
}
```

## Playwright MCP Tool Mapping

| Capability | Playwright MCP Tool | Purpose |
|------------|---------------------|---------|
| Navigation | `browser_navigate` | Access URLs |
| Snapshot | `browser_snapshot` | Retrieve DOM structure |
| Screenshot | `browser_take_screenshot` | Images for visual inspection |
| Click | `browser_click` | Interact with interactive elements |
| Resize | `browser_resize` | Responsive testing |
| Console | `browser_console_messages` | Detect JS errors |

## Other Compatible Browser Automation Tools

| Tool | Features |
|------|----------|
| Selenium | Broad browser support, multi-language support |
| Puppeteer | Chrome/Chromium focused, Node.js |
| Cypress | Easy integration with E2E testing |
| WebDriver BiDi | Standardized next-generation protocol |

The same workflow can be implemented with these tools. As long as they provide the necessary capabilities (navigation, screenshot, DOM retrieval), the choice of tool is flexible.
