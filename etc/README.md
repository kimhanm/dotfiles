# Systemwide Configuration

Install packages
```bash
sudo pacman -S thermald cpupower acpid lm_sensors
```
Create symlinks for files in `dotfiles/etc/*`

Enable services
```bash
systemctl enable --now acpid.service thermald.service cpupower.service
```



