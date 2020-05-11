# backlight

<a href="https://travis-ci.org/rafa-garcia/backlight"><img src="https://travis-ci.org/rafa-garcia/backlight.svg?branch=master"></a>

Brightness control in bash.

This utility handles display brightness when backlight control is exposed to the user through a sysfs interface at `/sys/class/backlight`. By default, the brightness level is managed for every registered class device through its backlight sysfs entry.

## Dependencies

- `bash`
- ACPI, graphic or platform driver controlling brightness and exposing a sysfs interface.
  - `[ "$(ls -A /sys/class/backlight)" ] && echo "Yea" || echo "Nay"`
- Installed by a sudoer

## Installation

1. Clone the repository.
    - `git clone https://github.com/rafa-garcia/backlight`

2. Change working directory to `backlight`.
    - `cd backlight`

3. Run `sudo make install` from the root directory to install the script, manpage and udev rule.

`backlight` can also be uninstalled easily with `sudo make uninstall`.

## Usage

```sh
usage: backlight [options]
Where options are:
  -help                    Print out a summary of the usage and exit
  -version                 Print out the program version and exit
  -get                     Print out the current backlight brightness of each output
  -set <percentage>        Sets each backlight brightness to the specified level
  -inc <percentage>        Increases brightness by the specified amount
  -dec <percentage>        Decreases brightness by the specified amount
  -time <milliseconds>     Length of time to transition to new value. Default is 200
  -steps <steps>           Number of steps to take while transitioning. Default is 20
```

## Why

After moving to [Wayland](https://wayland.freedesktop.org/), I struggled to find a portable (as in pure bash) [X.Org](https://www.x.org/)'s `xbacklight`-like utility that does not require X and handles similar CLI options.

## License

The application is licensed under the [MIT License](LICENSE).
