# Dioxide 📁

**Dioxide** is a program that seeks to recreate the [Zoxide](https://github.com/ajeetdsouza/zoxide) program but made entirely in Windows Batch and Powershell.

Current version: **1.0.0**

> [!NOTE]
> I consider that the project meets its objective 95%, for now I don't want to ***LOSE MY HEAD*** with something like Batch, so I'll leave it like that!
>
> Maybe in the future I will manage to fix the bugs and implement the interactive version.

## Getting Started 🎯

### Dependencies 🗃️

- Windows 10

> [!NOTE]
> It has not been tested but it is possible that it may work even on Windows 7, 8 and 11.

### Download ⬇️

Download [last raw file here](https://raw.githubusercontent.com/hppsrc/dioxide/refs/heads/main/main.bat).

### Installing ⚙️

> [!NOTE]
> **You need to install the script as administrator, if you don't it will give permissions automatically.**

There are two ways to install Dioxide.

- Running the script normally, it detects if the script is installed or not.

        main.bat

- Run

        main.bat /install

The script will then create the necessary files and entries in the Windows registry.

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

- [ ] Add interactive mode. (di)
- [ ] Fix Service Background Start.
- [ ] Reduce disk usage.
- [ ] Code cleanup.
- [ ] Loggin system.
- [ ] Test compatibility with more Windows versions.
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

## Version History 🕒

- 1.0.0
  - Mostly stable version considered 1.0.0.
  - Added additional commands “dev”, “/na” and “/disk”.
  - Fixed error when choosing N when running Admin command with Dioxide installed (simple implementation).
  - Dioxide can now search for previous visited directories (Thanks to the service).
  - Dioxide actions now work properly.
  - Now the service is created at installation time and not at each run.
  - The help message has been modified a little bit.
  - The “/b” command to return to previous directory was fixed.
  - The service execution was changed to something more direct; eliminating the “/service” command, also, now it fulfills all its function properly.

- 0.5.0-alpha
  - Actions were created for before and after the use of Dioxide.
  - Dioxide service was implemented and works as expected, one more feature is missing.
  - A (temporary) warning was added to notify about the use of Dioxide.
  - The PowerShell code for the service was added to the script.

- 0.4.0-alpha
  - Added extra function commands, “reset” and “uninstall”.
  - Now using an administrator command with “d” creates a new .bat.
  - Called “Post use” to create last directory file and start Dioxide service (not implemented yet).
  - Added option to uninstall Dioxide from system.
  - Added new commands in help message.
  - Added space for service implementation, and warning message.

- 0.3.0-alpha
  - Correctly implemented a check for “dev mode”.
  - Added checks to know whether to execute “d” or check a command.
  - Changed commands from “--” to “/”.
  - Reduced timeout from 3 sec to 1 sec.
  - Implemented a better way to receive option input with choice.exe.
  - Minor fix to error when using /fi.
  - The title is updated to the current directory and not the previous one.
  - Changed use of :EOF to :ExitNoCLS.

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
