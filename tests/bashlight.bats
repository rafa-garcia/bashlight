#!/usr/bin/env bats

setup() {
	export BACKLIGHT_DIR="$BATS_TEST_TMPDIR/backlight"
	add_device test_backlight 100 50
	bashlight="$BATS_TEST_DIRNAME/../bashlight"
}

add_device() {
	local dir="$BACKLIGHT_DIR/$1"
	mkdir -p "$dir"
	echo "$2" >"$dir/max_brightness"
	echo "$3" >"$dir/actual_brightness"
	echo "$3" >"$dir/brightness"
}

level() {
	cat "$BACKLIGHT_DIR/$1/brightness"
}

@test "prints the version" {
	run "$bashlight" -version
	[ "$status" -eq 0 ]
	[[ $output =~ ^bashlight\ v[0-9] ]]
}

@test "prints usage with no arguments" {
	run "$bashlight"
	[ "$status" -eq 0 ]
	[[ $output == usage:* ]]
}

@test "rejects unknown options" {
	run "$bashlight" -foo
	[ "$status" -eq 1 ]
	[[ $output == *"unknown option"* ]]
}

@test "rejects a non-numeric percentage" {
	run "$bashlight" -set abc
	[ "$status" -eq 1 ]
}

@test "rejects a percentage above 100" {
	run "$bashlight" -set 150
	[ "$status" -eq 1 ]
}

@test "get reports the current level" {
	run "$bashlight" -get
	[ "$status" -eq 0 ]
	[[ $output == *"50 (50%)"* ]]
}

@test "set writes the scaled level" {
	run "$bashlight" -set 30 -time 1 -steps 1
	[ "$status" -eq 0 ]
	[ "$(level test_backlight)" -eq 30 ]
}

@test "set 0 keeps the minimum safe level" {
	run "$bashlight" -set 0 -time 1 -steps 1
	[ "$(level test_backlight)" -eq 1 ]
}

@test "inc and dec are relative to the current level" {
	run "$bashlight" -inc 25 -time 1 -steps 1
	[ "$(level test_backlight)" -eq 75 ]
	echo 75 >"$BACKLIGHT_DIR/test_backlight/actual_brightness"
	run "$bashlight" -dec 30 -time 1 -steps 1
	[ "$(level test_backlight)" -eq 45 ]
}

@test "inc clamps at the maximum" {
	run "$bashlight" -inc 90 -time 1 -steps 1
	[ "$(level test_backlight)" -eq 100 ]
}

@test "dec clamps at the minimum instead of crashing" {
	run "$bashlight" -dec 90 -time 1 -steps 1
	[ "$status" -eq 0 ]
	[ "$(level test_backlight)" -eq 1 ]
}

@test "options after the action are still honoured" {
	run "$bashlight" -set 60 -time 1 -steps 1
	[ "$status" -eq 0 ]
	[ "$(level test_backlight)" -eq 60 ]
	run "$bashlight" -set 60 -time bogus
	[ "$status" -eq 1 ]
}

@test "refuses two actions at once" {
	run "$bashlight" -get -set 10
	[ "$status" -eq 1 ]
	[[ $output == *"cannot combine"* ]]
}

@test "reads leading zeros as decimal" {
	run "$bashlight" -set 010 -time 1 -steps 1
	[ "$(level test_backlight)" -eq 10 ]
}

@test "updates every backlight device" {
	add_device acpi_video0 15 3
	run "$bashlight" -set 40 -time 1 -steps 1
	[ "$(level test_backlight)" -eq 40 ]
	[ "$(level acpi_video0)" -eq 6 ]
}

@test "skips devices reporting no maximum" {
	add_device broken 0 0
	run "$bashlight" -set 40 -time 1 -steps 1
	[ "$status" -eq 0 ]
	[ "$(level test_backlight)" -eq 40 ]
	[ "$(level broken)" -eq 0 ]
}

@test "fails when no device is writable" {
	[ "$EUID" -ne 0 ] || skip "meaningless as root"
	chmod a-w "$BACKLIGHT_DIR/test_backlight/brightness"
	run "$bashlight" -set 40 -time 1 -steps 1
	[ "$status" -eq 1 ]
	[[ $output == *"video group"* ]]
}

@test "fails when the backlight interface is missing" {
	export BACKLIGHT_DIR="$BATS_TEST_TMPDIR/nowhere"
	run "$bashlight" -get
	[ "$status" -eq 1 ]
	[[ $output == *"not available"* ]]
}
