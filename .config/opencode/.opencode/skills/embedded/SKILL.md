---
name: embedded
description: PlatformIO + C/C++ embedded development workflow, nvim-platformio keybinds, common patterns
---

## Toolchain

- Build system: PlatformIO (`pio`)
- Editor integration: `nvim-platformio.lua` via `<leader>p` menu
- LSP: `clangd` (generates `compile_commands.json`)
- Aliases: `piob` (build), `piou` (upload), `piom` (monitor)

## nvim-platformio menu (`<leader>p`)

```
g — General
  b  build
  u  upload
  m  monitor
  c  clean

p — Platform
  b  build filesystem
  u  upload filesystem
  e  erase flash

d — Dependencies
  l  list packages
  o  outdated
  u  update

a — Advanced
  t  test
  c  check (static analysis)
  d  debug
  b  compile_commands.json
```

## platformio.ini structure

```ini
[env:esp32dev]
platform = espressif32
board = esp32dev
framework = arduino
monitor_speed = 115200
build_flags =
    -DCORE_DEBUG_LEVEL=3
    -DBOARD_HAS_PSRAM
lib_deps =
    knolleary/PubSubClient@^2.8
    bblanchon/ArduinoJson@^7.0

[env:test]
platform = native
test_build_src = yes
```

## Code patterns

**Avoid blocking in loop():**
```cpp
// bad
void loop() {
  delay(1000);
  doThing();
}

// good — non-blocking with millis()
void loop() {
  static unsigned long lastRun = 0;
  if (millis() - lastRun >= 1000) {
    lastRun = millis();
    doThing();
  }
}
```

**Pin definitions at top of file:**
```cpp
static constexpr uint8_t PIN_LED    = 2;
static constexpr uint8_t PIN_BUTTON = 4;
static constexpr uint32_t BAUD_RATE = 115200;
```

**Serial debug guarded by define:**
```cpp
#ifdef DEBUG
  #define LOG(x) Serial.println(x)
#else
  #define LOG(x)
#endif
```

## Common debug workflow

```bash
piob          # build to catch compile errors
piou          # upload to device
piom          # open serial monitor (Ctrl-C to exit)

# or combined
pio run -t upload -t monitor
```

## generate compile_commands.json (for clangd)

```bash
pio run -t compiledb
```

This enables full LSP features in nvim.
