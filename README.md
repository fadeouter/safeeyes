# Safeeyes
[Argos](https://github.com/p-e-w/argos) extension to keep your eyes healthy (Take a break or Safeeyes analog).

Every 20 minutes script forces a break: disables input devices like mouse and touchpad and starts slideshow for 25 seconds.

This script uses `feh` image viewer. `man feh` to know keyboard shortcuts.

**Features**

* Lightweight, in comparison with Safeeyes
* Disable/enable toggle
* Fullscreen apps detection (no break if any present)
* Configurable break period
* Uses any image or image slideshows during break
* Configurable time between alert and break
* Press ESC or Q to exit

**Limitations**

Fullscreen app detection and mouse/touchpad disabling (?) does not work with Wayland. All other probably will.

<H2> Installation </h2>
Before you use, create and set specific directory with images for break.

Also, ``sudo apt install xdotool feh``.
