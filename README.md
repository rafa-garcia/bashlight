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

3. Run `sudo make install` from the root directory to install the script, manpage and udev rule.
    - The `90-backlight.rules` udev rule will be added to allow the `video` group to control backlight
    - Add your user to the `video` group: `sudo usermod -a -G video $USER` (logout/login required)

`bashlight` can also be uninstalled easily with `sudo make uninstall`.

## Usage

```
usage: bashlight [options]
where options are:
  -help                    Print out a summary of the usage and exit
  -version                 Print out the program version and exit
  -get                     Print out the current brightness of each output
  -set <percentage>        Sets each backlight brightness to the specified level
  -inc <percentage>        Increases brightness by the specified amount
  -dec <percentage>        Decreases brightness by the specified amount
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
```

## Why

After moving to [Wayland](https://wayland.freedesktop.org/), I struggled to find a portable (as in pure bash) [X.Org](https://www.x.org/)'s `xbacklight`-like utility that does not require X and handles similar CLI options.

## License

The application is licensed under the [MIT License](LICENSE).
