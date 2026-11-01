:; cd ~/Zenokernel
:; printf '%s\n' \
'# ZenoKernel for Galaxy S20 FE (r8q / SM8250)' \
'' \
'# Introduction' \
'- This kernel is built upon the excellent work of the **not_kernel** project (by s-k-y.e).' \
'- It is always compliant with the latest LineageOS common sm8250 kernel changes.' \
'- This custom build is heavily optimized for **maximum gaming performance and extreme low latency**.' \
'' \
'## ⚡ Features & Modifications (What makes ZenoKernel special?)' \
'This is not just a rebrand. We have implemented deep hardware and software modifications:' \
'- **GPU Overclock (910 MHz @ 390mV):** Pushed the Adreno 650 beyond factory limits for massive graphical gains (Cooler highly recommended). Dynamic timers for 60/90/120Hz.' \
'- **CPU Boost & HAL Bypass:** Sultan Schedutil Fix applied. `verify_within_limits` liberates the max frequency to allow scaling above the boost floor. Tuning: Silver (300MHz), Gold (1.8GHz), Prime (2.42GHz) for the perfect thermal sweet spot.' \
'- **Touch Response:** Real Zinitix driver patched. IRQ pinned to CPUs 4-7 (0xF0), nice -20. Validated 4ms latency and 0% jank.' \
'- **RAM Tunings:** Native kthread forcing `swappiness=10`, `dirty_ratio=10`, and `dirty_bytes=0` to keep game data locked in physical RAM.' \
'- **TCP BBR:** Forced via native kernel kthread for lower ping and stable online gaming.' \
'- **Power Efficiency:** PELT half-life 16ms, RCU_LAZY enabled, WoW timeout reduced to 10s.' \
'' \
'## Warning:' \
'- The kernel source code is **always** under development and may cause some unpredictable problems.' \
'- **You are being warned.** Overclocking your GPU carries risks (heat, degradation, instability).' \
'- Please use it with caution.' \
'- Keep your stock `boot.img` backup safe at all times.' \
'' \
'## Warranty' \
'- None, none at all. I am handing you a **sharp knife**, it is not on me if you stab yourself with it.' \
'- No warranties.' \
'- No support.' \
'- Not.' \
'' \
'## Notes' \
'- This kernel combines contributions from multiple upstreams to make it as practical and well-rounded as possible.' \
'- Code required for OneUI support was selectively cherry-picked (SDCardFS kept native).' \
'- Dual-Boot validated on AOSP Custom ROMs and original OneUI.' \
'- The AnyKernel3 ZIP is hardened with hardware checks (`ro.boot.em.model` for SM-G780*/SM-G781*) to prevent flashing on unsupported devices.' \
'' \
'## Credits' \
'- **s-k-y.e** and the **not_kernel** team for the incredible base source code.' \
'- **Sultan Alsawaf (kerneltoast)** for the Schedutil Fix and HFR logic.' \
'- **The Linux Kernel Community** for TCP BBR.' \
'' \
'## Engineered to perfection. (Now with extra Zeno.)' \
> README.md

echo "README.md criado. Verificando:"
cat README.md | head -15
