# Claude Light Theme for VS Code

[![Visual Studio Marketplace Version](https://img.shields.io/visual-studio-marketplace/v/Lumidew.claude-light-theme?style=flat-square&label=Marketplace)](https://marketplace.visualstudio.com/items?itemName=Lumidew.claude-light-theme)
[![Installs](https://img.shields.io/visual-studio-marketplace/i/Lumidew.claude-light-theme?style=flat-square)](https://marketplace.visualstudio.com/items?itemName=Lumidew.claude-light-theme)

A Visual Studio Code theme inspired by the clean, warm, and focused interface of Claude AI.

This theme is designed for those who appreciate a calm, minimalist, and readable environment. It uses a warm, off-white background and a carefully selected palette for syntax highlighting to reduce eye strain and improve code comprehension.

![Current Directory Screenshot](https://github.com/AuroralFrost/claude-light-theme/blob/main/Screenshots.jpg)

---

## Features

- **Warm & Focused UI**: A gentle, paper-like background (`#FAF9F5`) that's easy on the eyes during long coding sessions.
- **Enhanced HTML/CSS Support**: Comprehensive syntax highlighting for web development with proper color-coding for tags, attributes, properties, and values.
- **Harmonious Highlighting**: Syntax colors are carefully tuned to be clear and aesthetically pleasing, inspired by Claude's official palette.
- **Consistent Design**: Provides a cohesive look and feel across the entire VS Code workbench, from the editor to the terminal.
- **Clarity First**: The color scheme prioritizes readability and semantic meaning, helping you understand your code at a glance.

## Color Palette

### Main Colors
- **Background**: `#FAF9F5` (Warm Off-White)
- **Foreground**: `#1F1E1D` (Dark Brown-Gray)
- **Accent**: `#1C6BBB` (Claude Blue)
- **Emphasis**: `#C96442` (Terracotta Orange)

### Syntax Highlighting
- **Keywords**: `#D73A83` (Pink)
- **Types & Classes**: `#8A46CE` (Purple)
- **Functions**: `#1F6FE4` (Blue)
- **Numbers & Constants**: `#2D8F8F` (Cyan)
- **Parameters**: `#B56613` (Orange-Brown)
- **Strings**: `#26831A` (Green)
- **Comments**: `#6F6F78` (Gray)

### HTML & CSS Support
- **HTML Tags**: `#D73A83` (Pink)
- **HTML Attributes**: `#1F6FE4` (Blue)
- **HTML Values**: `#26831A` (Green)
- **CSS Properties**: `#B56613` (Orange-Brown)
- **CSS Values**: `#2D8F8F` (Cyan)
- **CSS Selectors**: `#8A46CE` (Purple)

## Installation

### From the Marketplace
1. Open the **Extensions** sidebar in VS Code (`Ctrl+Shift+X` or `Cmd+Shift+X`).
2. Search for `Claude Light Theme`.
3. Click **Install**.
4. Open the **Command Palette** (`Ctrl+Shift+P` or `Cmd+Shift+P`), type `Preferences: Color Theme`, and select **Claude Light Theme**.

### From a VSIX File
1. [Download the latest `.vsix` file from the releases page.](https://github.com/your-username/claude-theme/releases)
2. Open the **Extensions** sidebar in VS Code.
3. Click the **...** menu in the top-right corner, select **Install from VSIX...**, and choose the downloaded file.

## Customization
You can override the theme's colors in your personal `settings.json` file.

```jsonc
{
  "workbench.colorCustomizations": {
    "[Claude Light Theme]": {
      "editor.background": "#FAFAFA", // Make it a bit whiter
      "activityBar.background": "#F5F3EE"
    }
  },
  "editor.tokenColorCustomizations": {
    "[Claude Light Theme]": {
      "comments": "#888888", // Make comments a bit lighter
      "strings": "#008000"  // A different shade of green for strings
    }
  }
}
```

## Contributing
Contributions are welcome! If you find any issues or have suggestions for improvements, please feel free to open an issue or submit a pull request.

## License
This theme is licensed under the [MIT License](LICENSE).
