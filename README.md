# bashlight

[![CI](https://github.com/rafa-garcia/bashlight/workflows/CI/badge.svg)](https://github.com/rafa-garcia/bashlight/actions)

Brightness control in bash.

This utility handles display brightness when backlight control is exposed to the user through a sysfs interface at `/sys/class/backlight`. By default, the brightness level is managed for every registered class device through its backlight sysfs entry.

## Dependencies

- `bash` (pure bash implementation)
- Linux system with backlight support (check: `ls /sys/class/backlight/`)
- `sudo` privileges for installation

## Installation

1. Clone the repository.
    - `git clone https://github.com/rafa-garcia/bashlight`

2. Change working directory to `bashlight`.
    - `cd bashlight`

3. Run `sudo make install` from the root directory to install the script, manpage, udev rule and shell completions (bash and zsh).
    - The `90-backlight.rules` udev rule will be added to allow the `video` group to control backlight and keyboard backlight
    - Add your user to the `video` group: `sudo usermod -a -G video $USER` (logout/login required)

`bashlight` can also be uninstalled easily with `sudo make uninstall`.

## Usage

```
usage: bashlight [options]
where options are:
  -help                    Print out a summary of the usage and exit
  -version                 Print out the program version and exit
  -get                     Print out the current brightness of each output
  -list                    Print out the backlight device names
  -set <percentage>        Sets each backlight brightness to the specified level
  -inc <percentage>        Increases brightness by the specified amount
  -dec <percentage>        Decreases brightness by the specified amount
  -save                    Save the current brightness of each output
  -restore                 Restore the last saved brightness
  -device <name>           Apply the operation to the given device only
  -kbd                     Control keyboard backlights instead of displays
  -perceptual              Map percentages to a perceptual brightness curve
  -time <milliseconds>     Duration of transition to new value. Default is 200
  -steps <steps>           Number of transition steps. Default is 20
```

## Examples

```bash
# Get current brightness
bashlight -get

# Set brightness to 50%
bashlight -set 50

# Increase brightness by 10%
bashlight -inc 10

# Decrease brightness by 15% with slower transition
bashlight -dec 15 -time 500

# Set brightness with custom transition steps
bashlight -set 75 -time 300 -steps 30

# Only touch one device on machines with several
bashlight -list
bashlight -device intel_backlight -set 50

# Turn the keyboard backlight off
bashlight -kbd -set 0

# Dim for the lock screen, put it back on unlock
bashlight -save && bashlight -set 5
bashlight -restore

# Steps that look even to the eye across the whole range
bashlight -perceptual -inc 10
```

## External monitors

Backlight control over DDC/CI is exposed through the same sysfs interface by the [ddcci-backlight](https://gitlab.com/ddcci-driver-linux/ddcci-driver-linux) kernel module. With it loaded, external monitors show up under `/sys/class/backlight` like any other device and bashlight controls them with no extra configuration.

## Tests

```bash
bats tests
```

The suite points `BACKLIGHT_DIR` at a throwaway directory, so it runs anywhere [bats](https://github.com/bats-core/bats-core) does.

## Why

After moving to [Wayland](https://wayland.freedesktop.org/), I struggled to find a portable (as in pure bash) [X.Org](https://www.x.org/)'s `xbacklight`-like utility that does not require X and handles similar CLI options.

## License

The application is licensed under the [MIT License](LICENSE).
