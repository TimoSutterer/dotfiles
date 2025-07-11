# Powerlevel10k Font and Display Configuration

This guide explains how to properly configure fonts and display settings for Powerlevel10k to ensure all symbols and colors render correctly.

## Font Installation

Powerlevel10k requires a compatible font to display special symbols and icons properly. Without the correct font, you may see question marks, boxes, or missing characters in your prompt.
The easiest solution is to install a Nerd Font that includes all the necessary glyphs as explained in the official [Powerlevel10k font installation guide](https://github.com/romkatv/powerlevel10k?tab=readme-ov-file#fonts).

## Color Depth Configuration

Color depth determines how many colors your terminal can display, affecting the visual quality of your prompt.

### What is Color Depth?

Color depth refers to the number of bits used to represent colors:
- **8-bit**: 256 colors
- **24-bit**: True color (16.7 million colors)

Powerlevel10k works best with 24-bit color support for the richest visual experience.

### Checking Your Color Depth

Run these commands to test your terminal's color support:

```bash
# Test 256 colors (8-bit)
# source: https://askubuntu.com/a/821163
for i in {0..255} ; do
    printf "\x1b[48;5;%sm%3d\e[0m " "$i" "$i"
    if (( i == 15 )) || (( i > 15 )) && (( (i-15) % 6 == 0 )); then
        printf "\n";
    fi
done

# Test true color (24-bit)
# source: https://unix.stackexchange.com/a/404415
awk -v term_cols="${width:-$(tput cols || echo 80)}" 'BEGIN{
    s="/\\";
    for (colnum = 0; colnum<term_cols; colnum++) {
        r = 255-(colnum*255/term_cols);
        g = (colnum*510/term_cols);
        b = (colnum*255/term_cols);
        if (g>255) g = 510-g;
        printf "\033[48;2;%d;%d;%dm", r,g,b;
        printf "\033[38;2;%d;%d;%dm", 255-r,255-g,255-b;
        printf "%s\033[0m", substr(s,colnum%2+1,1);
    }
    printf "\n";
}'
```

### Setting Color Depth

Most modern terminals support 24-bit color by default. If the color tests above don't display properly or you're experiencing color issues with Powerlevel10k, see the [troubleshooting guide](p10k-troubleshooting.md#colors-look-wrong-or-washed-out) for detailed steps to resolve color problems.
