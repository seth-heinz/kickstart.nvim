# Java Debugging Setup for Neovim

## Setup Complete!

Your Neovim is now configured to debug Gradle Java projects like `~/git/northam-verification-service/master`.

## Prerequisites

1. **Java installed**: Make sure you have Java 21 (or your project's version) installed
   - Check with: `java -version`
   - If using sdkman, ensure the path in `lua/custom/java-lsp.lua` matches your installation

2. **Mason packages**: The following will be automatically installed when you first open Neovim:
   - `jdtls` (Java Language Server)
   - `java-debug-adapter` (for debugging)
   - `java-test` (for running tests)

## Usage

### Opening Your Project

1. Navigate to your project directory:
   ```bash
   cd ~/git/northam-verification-service/master
   nvim .
   ```

2. Open any Java file - the LSP will automatically start

### Setting Breakpoints

- **Toggle breakpoint**: `<leader>db` (usually `Space` + `d` + `b`)
- Place your cursor on the line where you want to break and press the keybinding

### Starting a Debug Session

1. **First, make sure your project is built**:
   ```bash
   ./gradlew build
   ```

2. **Start debugging**: `<leader>dc` (Continue/Start)
   - On first run, jdtls will discover your main classes
   - You'll be prompted to select which main class to debug

### Debug Controls

- `<leader>dc` - Continue execution (or start debugging)
- `<leader>di` - Step Into
- `<leader>do` - Step Over
- `<leader>dO` - Step Out
- `<leader>dt` - Terminate debug session
- `<leader>dr` - Open REPL (evaluate expressions)
- `<leader>dl` - Run last debug configuration
- `<leader>du` - Toggle debug UI

### Debug UI

The debug UI will automatically open when debugging starts and shows:

**Left sidebar:**
- Scopes (variables in current scope)
- Breakpoints
- Call stack
- Watches

**Bottom panel:**
- REPL (evaluate expressions)
- Console (program output)

### Java-Specific Features

- `<leader>jo` - Organize imports
- `<leader>jv` - Extract variable
- `<leader>jc` - Extract constant
- `<leader>jm` - Extract method (in visual mode)

### Debugging a Gradle Test

#### Java Tests (JUnit)
1. Open the test file
2. Set a breakpoint in the test method
3. Use `<leader>dc` to start debugging
4. Select the test class when prompted

#### Groovy/Spock Tests
1. Open the `.groovy` Spock test file
2. Set a breakpoint in any test method (e.g., inside a `def "test name"()` block)
3. Use `<leader>dc` to start debugging
4. Select the Spock test class when prompted
5. The debugger will stop at your breakpoints in the Groovy code

**Note**: Groovy syntax highlighting and LSP support is included for `.groovy` files!

### Troubleshooting

**LSP not starting:**
- Run `:Mason` to check if jdtls is installed
- Run `:LspInfo` to see LSP status
- Check `:messages` for errors

**Debug adapter not found:**
- Run `:Mason` and ensure `java-debug-adapter` and `java-test` are installed
- Restart Neovim after installation

**Wrong Java version:**
- Edit `~/.config/nvim/lua/custom/java-lsp.lua`
- Update the `runtimes` path to your Java installation

**Project not recognized:**
- Make sure you're in a directory with `build.gradle` or `gradlew`
- The LSP looks for these files to identify the project root

## Configuration Files

- `lua/custom/plugins/java-debug.lua` - Debug plugin configuration
- `lua/custom/java-lsp.lua` - Java LSP settings
- `ftplugin/java.lua` - Auto-loads LSP for Java files

## Next Steps

1. Restart Neovim
2. Run `:Lazy sync` to install the debug plugins
3. Run `:Mason` to verify Java tools are installed
4. Open a Java file in your project and test it out!

Happy debugging!
