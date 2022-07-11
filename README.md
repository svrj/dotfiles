## My dotfiles
These are my dotfiles and installation helpers for Ubuntu (22.04)

### Convenience script for when things are tuned
 - Starter script for fresh installs
 > curl <hosted starter script> | sh

## Notes
 - Wayland is used by default in Ubuntu 22.04 instead of Xorg. To prevent this:
     - https://fostips.com/switch-back-xorg-ubuntu-21-04/
     ```bash
     sudo cp /etc/environment /etc/environment.back
     sudo cp /etc/gdm3/custom.conf /etc/gdm3/custom.conf.back

     sudo cp etc/gdm3/custom.conf /etc/gdm3/
     sudo cp etc/environment /etc/
     ```

## Resources:
 - https://github.com/addyosmani/dotfiles
 - https://github.com/paulirish/dotfiles
