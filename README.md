# Dioxide 📁

**Dioxide** is a program that seeks to recreate the [Zoxide](https://github.com/ajeetdsouza/zoxide) program but made entirely in Windows Batch and Powershell.

Current version: **2.0.0**

> [!NOTE]
> This project is currently inactive and will stop receiving updates in general for a long time. Batch is a very annoying thing to work on and I don't want to waste any more time with this.

## Getting Started 🎯

### Dependencies 🗃️

- Windows 10

> [!NOTE]
> It has not been tested but it is possible that it may work even on Windows 7, 8 and 11.

---

### Download ⬇️

Download [last raw file here](https://raw.githubusercontent.com/hppsrc/dioxide/refs/heads/main/main.bat).

---

### Installing ⚙️

> [!NOTE]
> You need to install the script as administrator, if you don't it will give permissions automatically.

There are two ways to install Dioxide.

- Running the script normally, it detects if the script is installed or not.

        main.bat

- Run

        main.bat /install

The script will then create the necessary files and entries in the Windows registry.

---

### Using Dioxide 💻

- As in Zoxide, you use `d` to move to execute most of the actions.

- Move to dir

        d <path>

Dioxide checks the following order to move directory:

1. current directory `.\cd`

2. full path `C:\cd`

3. ranking

*If no match is found, an error is returned.*

## Help ❓

Run the next switch to get help.

        d /help

This switch works whether or not it is installed.

## License 🔑

This project is licensed under the Apache 2.0 License.

## TODO ✔️

- [ ] Fix Service Background Start.
- [ ] Loggin system.
- [ ] Test compatibility with more Windows versions.
- [x] Add interactive mode. (di)
- [x] Reduce disk usage.
- [x] Code cleanup.
- [x] Main "d" implementation.
- [x] History and ranking.
- [x] Improve error handling.
- [x] Extra actions.
  - [x] "d /b" return to last path.
  - [x] "d /e" open explorer.
  - [x] "d /n" open new terminal.

## Known Errors 🐞

- There is a bug where using double quotes gives an interpretation error, there is no way to fix this.

example:

      d "3D Objects"

- When changing directory a minimized PowerShell window is created, this is the Dioxide service, it is completely harmless and necessary for the use of rankings.

## Changelog 🕒

Check the [CHANGELOG.md](CHANGELOG.md) file.
