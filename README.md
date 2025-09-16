# CAC Manager

**CAC Manager** is a script-based utility for configuring DoD Common Access Card (CAC) support on Linux systems, starting with Fedora support.

It performs everything you need to get up and running with CAC authentication on a supported Linux system — from installing required packages, enabling smartcard services, and importing DoD root certificates.

---

## Features

- One-line installer (fully automated)
- DoD certificate bundle download + trust store import
- Smartcard service ('pcscd.socket') activation
- Verifies and installs required packages
- Diagnostics via 'pcsc_scan'
- Modular per distro – support for more OSes coming soon!

---

## Supported Linux Distributions

| Distro       | Status   | Notes                        |
|--------------|----------|------------------------------|
| Fedora       | ✅ Stable | Tested on Fedora 37+         |
| Ubuntu       | 🔄 WIP    | Coming soon                  |
| RHEL/Rocky   | 🔄 WIP    | Coming soon                  |

> If you want support for your distro, open a GitHub issue or contribute via pull request!

## Quick Start

``` bash
curl -fsSL https://raw.githubusercontent.com/large-farva/cacmate/main/setup.sh | bash
```

This script will request `sudo` access to install packages and enable smartcard support.

### Directory Structure

``` text
cacmanager/
├── scripts/
│   ├── fedora.sh     # Fedora-specific logic
│   ├── ubuntu.sh     # (coming soon)
│   ├── rhel.sh       # (coming soon)
│   └── common.sh     # Shared helper functions
├── setup.sh          # Distro-detecting launcher
├── README.md
├── LICENSE
└── changelog.md
```

---

### Manual Install

If you'd rather inspect and run the script manually:

``` bash
git clone https://github.com/large-farva/cacmate.git
cd cacmate
chmod +x setup.sh
./setup.sh
```

---


### Log & Output

Each run generates a timestamped log file:

``` bash
~/.cac/logs/fedora-cac-setup_YYYY-MM-DD_HH-MM-SS.log
```

Certificate files and extracted bundles are placed in:

``` bash
~/.cac/certs/
```

---

### Requirements

The script handles all of this for you, but you'll need:
- `dnf`, `systemd`, `sudo`
- Internet access (to fetch DoD cert bundle)
- A CAC reader + valid CAC card

---

### Diagnosis
- Run `pcsc_scan` to check for card detection
- Use distro-packaged browsers (RPM, deb, etc. - not Flatpak) for CAC-enabled websites

---

### Troubleshooting
- If your CAC reader is not detected:

``` bash
systemctl status pcscd.socket
```
- Some Flatpak browsers don't support host PKCS#11 modules — prefer native RPM/DEB packages.

---

### License

Licensed under the MIT License. See [LICENSE](LICENSE) for details.

---

### Coming Soon
- GUI version
- Ubuntu/Debian, RHEL, Rocky, AlmaLinux support