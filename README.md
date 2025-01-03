# Dioxide 📁

**Dioxide** is a program that seeks to recreate the [Zoxide](https://github.com/ajeetdsouza/zoxide) program but made entirely in Windows Batch.

Current version: **0.2.0-alpha**

> [!WARNING]
> Dioxide is currently in ***ALPHA***, much of what is said here may not be implemented yet. ***Be careful!***

> [!IMPORTANT]
> Dioxide currently only can be installed, it does not perform any other actions.

## Getting Started 🎯

### Dependencies 🗃️

- Windows 10

> [!NOTE]
> It has not been tested but it is possible that it may work even on Windows 7, 8 and 11.

### Download ⬇️

Download last raw file here.

### Installing ⚙️

> [!NOTE]
> **You need to install the script as administrator, if you don't it will give permissions automatically.**

There are two ways to install Dioxide.

- Running the script normally, it detects if the script is installed or not.

        main.bat

- Run

        main.bat --install

The script will then create the necessary files and entries in the Windows registry.

### Using Dioxide 💻

> [!IMPORTANT]
> Dioxide currently only can be installed, it does not perform any other actions.

- As in Zoxide, you use `d` to move to execute most of the actions.

- Move to dir

        d <path>

Dioxide checks the following order to move directory:

1. current directory `.\cd`

2. full path `C:\cd`

3. ranking

4. history log

*If no match is found, an error is returned.*

<!-- 
- As in Zoxide, you have `di` an interactive version of Dioxide.

TODO: Add this and screenshots -->

## Help ❓

Run the next switch to get help.

        d --help

This switch works whether or not it is installed.

## Version History 🕒

- 0.2.0-alpha
  - Changed the path in the variable.
  - Extra check of arguments.
  - Respective modifications in the use of Path variables.
  - First implementation of the d function.
  - Changed if for safe check.
  - Change in help message.

- 0.1.0
  - Initial Release.
  - Basic functions implementation.

## License 🔑

This project is licensed under the Apache 2.0 License.

## TODO ✔️

- [ ] Improve error handling.
- [ ] Main "d" implementation.
- [ ] History and ranking.
- [ ] Add interactive mode. (di)
- [ ] Test compatibility with more Windows versions.
- [ ] Loggin system
