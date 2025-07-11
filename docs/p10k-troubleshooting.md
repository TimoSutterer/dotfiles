# Powerlevel10k Troubleshooting Guide

This guide helps resolve common issues with Powerlevel10k display and functionality.

## Symbols Not Displaying (Question Marks, Boxes)

**Symptoms**: Seeing `?`, `□`, or missing characters in your prompt

**Solutions**:
1. Install a compatible Nerd Font (see [Font Setup Guide](p10k-setup.md#font-installation))
2. Configure your terminal to use the installed font
3. Restart your terminal completely

## Colors Look Wrong or Washed Out

**Symptoms**: Dull colors, incorrect color schemes, or monochrome prompt

**Solutions**:
1. **Check Terminal Support**: Ensure your terminal emulator supports true color (run color tests from [Color Depth Guide](p10k-setup.md#checking-your-color-depth))
2. **Environment Variables**: Check if color-related environment variables like `COLORTERM` and `TERM` are set appropriately for your specific setup
3. **Terminal Settings**: Verify your terminal's color scheme and profile settings
4. **Multiple Layers**: Check all components in your setup stack - each layer (terminal emulator, Docker containers, tmux/screen sessions, SSH connections) may have its own color configuration that needs to be properly set
5. **Shell Configuration**: Ensure your shell (zsh, bash) isn't overriding color settings


## Run Configuration Wizard

If your prompt still doesn't look right, run the configuration wizard:

```bash
p10k configure
```

This interactive tool will:
- Test your terminal's capabilities
- Guide you through visual configuration options
- Generate an optimized configuration file

## Additional Resources

For more advanced troubleshooting, see the [official Powerlevel10k troubleshooting guide](https://github.com/romkatv/powerlevel10k#troubleshooting).
