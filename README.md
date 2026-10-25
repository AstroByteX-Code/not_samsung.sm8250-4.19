# ZenoKernel for Galaxy S20 FE (r8q / SM8250)

# Introduction
- This kernel is built upon the excellent work of the **not_kernel** project (by s-k-y.e).
- It is always compliant with the latest LineageOS common sm8250 kernel changes.
- This custom build is heavily optimized for **maximum gaming performance and extreme low latency**.

## ⚡ Features & Modifications (What makes ZenoKernel special?)
This is not just a rebrand. We've implemented deep hardware and software modifications:
- **GPU Overclock (910 MHz @ 400mV):** Pushed the Adreno 650 beyond factory limits for massive graphical gains (Cooler highly recommended).
- **Simple LMK:** Replaced the standard Android LMK with Sultan's Simple LMK for surgical process killing and zero jank during gaming.
- **RAM Tunings:** `swappiness=10`, `min_ttl=50`, and `vfs_cache_pressure=200` to keep game data locked in physical RAM.
- **TCP BBR:** Forced the Bottleneck Bandwidth and RTT congestion control for lower ping and stable online gaming.
- **CPU Response:** `input_boost_ms=150` and `schedutil rate_limit=500us` for instant touch responsiveness.
- **TEO Governor:** Intelligent CPU idle management for faster wake-ups and better battery standby.

## Warning:
- The kernel source code is **always** under development and may cause some unpredictable problems.
- **You are being warned.** Overclocking your GPU carries risks (heat, degradation, instability).
- Please use it with caution.
- Keep your stock `boot.img` backup safe at all times.

## Warranty
- None, none at all. I am handing you a **sharp knife**, it is not on me if you stab yourself with it.
- no warranties.
- no support.
- not.

## Notes
- This kernel combines contributions from multiple upstreams to make it as practical and well-rounded as possible.
- Code required for OneUI support was selectively cherry-picked from various sources by the original author.
- Support for all the remaining Samsung SM8250 devices is available in the source, however it probably needs some work to get it refined.
- Tested and stable on **Android 17 (Cinnamon Bun)** and previous versions.

## Credits
- **s-k-y.e** and the **not_kernel** team for the incredible base source code.
- **Sultan Alsawaf (kerneltoast)** for the Simple LMK.
- **The Linux Kernel Community** for TCP BBR and TEO.

## Engineered to perfection. (Now with extra Zeno.)
