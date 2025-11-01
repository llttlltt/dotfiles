# .dotfiles

These are my personal dotfiles, using zsh and various tools to set up my development environment on macOS.

![Terminal](/resources/images/ghostty.jpg)

## Highlights

- **cli**
  - [fzf](https://junegunn.github.io/fzf/)
  - [zoxide](https://github.com/ajeetdsouza/zoxide)
  - [ripgrep](https://github.com/BurntSushi/ripgrep)
  - [eza](https://eza.rocks/)
  - [fd](https://github.com/sharkdp/fd)
  - [jq](https://jqlang.org/)
  - [flavours](https://github.com/Misterio77/flavours)
  - [httpie](https://httpie.io/)
  - [trash](https://github.com/andreafrancia/trash-cli)
- **development**
  - [neovim](https://neovim.io/) : [kickstart.nvim](https://neovim.io/)
  - [ghostty](https://ghostty.org/)
  - [homebrew](https://brew.sh/)
  - [mise](https://mise.jdx.dev/)
- **tui**
  - [dua-cli](https://github.com/Byron/dua-cli)
  - [btop](https://github.com/aristocratos/btop)
  - [fx](https://fx.wtf/)
- **extras**
  - [leader-key](https://github.com/mikker/LeaderKey.app)
  - [karabiner-elements](https://karabiner-elements.pqrs.org/)
- **premium**
  - [alfred](https://www.alfredapp.com/)
    - `cu` : [convert currency](https://alfred.app/workflows/alfredapp/currency-converter/)
    - `cu` : [convert units](https://alfred.app/workflows/alfredapp/unit-converter/)
    - `tz` : [time zone](https://github.com/jaroslawhartman/TimeZones-Alfred)
  - [velja](https://sindresorhus.com/velja)
  - [rectangle-pro](https://rectangleapp.com/pro)
  - [macwhisper](https://goodsnooze.gumroad.com/l/macwhisper)

## Installation

[Dotbot](https://github.com/anishathalye/dotbot) handles the setup. Simply clone the repository and run the `install` script.

1. **Clone the repository:**

    ```bash
    git clone https://github.com/elliott-liu/dotfiles.git ~/.dotfiles
    ```

2. **Run the Dotbot installer:**

    ```bash
    cd ~/.dotfiles
    ./install
    ```

## TODO

- [ ] Dock Preferences
- [ ] Mission Control Preference (Don't Rearrange Spaces)
- [ ] Add ~/Library/Spelling/LocationDictionary
- [ ] Finder (Show Path Bar)
- [ ] Finder (As List)
- [ ] Alfred (Turn off Spotlight shortcut and use for Alfred)
- [ ] Calendar:
  - [ ] Advanced Preferences:
    - [ ] Turn on timezone support
    - [ ] Show events in year view
    - [ ] Show week numbers

### Background

My journey began with a [@fireship-io](https://github.com/fireship-io) video ([~/.dotfiles in 100 Seconds](https://youtu.be/r_MpUP6aKiQ)), and a course by [@eieioxyz](https://github.com/eieioxyz) on [Udemy](https://www.udemy.com/share/1043Ta3@hjXwP3uCJlmKqwco8k_3tBHNY9Sue8EcuuWg63c0ROr8UpThvqBfxhlE4IT4CTK_/).
