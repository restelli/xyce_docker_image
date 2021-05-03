# Dockerfile to run Xyce of Win 10, Linux and OS X

# How to build
```
docker build -t xyce_il .
```

# How to run interactive shell giving access to current folder
```
docker run \
    --mount type=bind,source="$(pwd)"/shared,target=/home/xyce/shared \
    -it \
    --rm \
    --name xyce_test \
    --net=host \
    xyce_test

```





## On Windows

A complete guide to install Docker on Windows can be found on [this link](https://docs.docker.com/docker-for-windows/install/).
Docker can run on Windows 10 64-bit: Pro, Enterprise, or Education (Build 17134 or higher) using Hyper-V backend, or on all distributions of Windows using WSL 2.
The Xyce image has been tested only with WSL2 and following the following steps:
Enable WSL and check if it is version 2.
```
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
```
Then check the windows version with the following command:
```
winver
```
Os build must be > 18362. If it is not it would not be possible to install Docker Desktop for Windows 10 with this method.

BIOS-level hardware virtualization support must be enabled in the BIOS settings.
```
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

Reboot the machine


Download and run the [WSL Linux kernel Update](https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi)

Download [Docker Desktop installer](https://desktop.docker.com/win/stable/amd64/Docker%20Desktop%20Installer.exe) and run it.

At the end close and logout
Log in again
