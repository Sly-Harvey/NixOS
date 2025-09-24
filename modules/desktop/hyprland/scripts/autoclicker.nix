{ pkgs, ... }:
pkgs.writers.writePython3Bin "auto-clicker"
  {
    libraries = [ pkgs.python3Packages.python-uinput ];
    flakeIgnore = [
      "E265"
      "E225"
      "E501"
    ];
  }
  ''
    import os
    import time
    import uinput
    import argparse

    # Set up command line argument parsing
    parser = argparse.ArgumentParser(description='Auto-clicker with configurable CPS')
    parser.add_argument('--cps', type=float, default=40.0, help='Clicks per second (default: 40)')
    args = parser.parse_args()

    # Calculate delay based on CPS
    click_delay = 1 / args.cps

    # Set up the uinput device
    keys = [uinput.BTN_LEFT]
    with open("/tmp/auto-clicker.pid", "w") as f:
        f.write(str(os.getpid()))

    print(f"Starting auto-clicker at {args.cps} clicks per second")
    print(f"PID: {os.getpid()} (saved to /tmp/auto-clicker.pid)")

    device = uinput.Device(keys)
    time.sleep(0.2)  # Small delay before starting to click

    try:
        while True:
            device.emit(uinput.BTN_LEFT, 1)  # Press
            device.emit(uinput.BTN_LEFT, 0)  # Release
            time.sleep(click_delay)
    except KeyboardInterrupt:
        print("Auto-clicker stopped")
  ''
