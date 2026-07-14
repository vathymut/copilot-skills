# Electron App Screenshots

**Node.js Playwright only** — Python Playwright has no `electron` API. Captures via CDP (Chrome DevTools Protocol), not from the screen — works even while minimized.

```javascript
const { _electron: electron } = require('playwright');
const app = await electron.launch({
    executablePath: 'C:\\Program Files\\Microsoft VS Code\\Code.exe',
    args: ['--new-window', '--disable-extensions', '--user-data-dir=' + tmpDir]
});
const window = await app.firstWindow();
await window.waitForLoadState('domcontentloaded');

// Minimize immediately — captures still work via CDP
await app.evaluate(({ BrowserWindow }) => {
    BrowserWindow.getAllWindows()[0].minimize();
});

await window.screenshot({ path: 'capture.png' }); // works while minimized!
await app.close();
```

**Critical**: `--user-data-dir=<temp>` is required or VS Code hands off to the existing instance and the launched process exits immediately.
