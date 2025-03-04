# Changelog

Based not exaustively on [Keep a Changelog][KaC-link] and [SemVer][Smv-link].

## 1.1.0

### Added

- Code cleaning.
- Changelog file.
- Added file checks.
- New "/version"  and "/fi-s"  switches.

### Changed

- Improvement when detecting switches, not limited to the first or second.
- Now the di.bat file is not created.
- Changes to the help message.

### Fixed

- Minor changes to some texts and fix some errors.
- Now instead of individually eliminating the keys of keys, the entire folder is eliminated. This fix an error on re-installing.

## 1.0.0

### Added

- Added additional commands "dev", "/na" and "/disk".
- Dioxide can now search for previous visited directories (Thanks to the service).

### Changed

- The help message has been modified a little bit.
- Now the service is created at installation time and not at each run.
- The service execution was changed to something more direct; eliminating the "/service" command, also, now it fulfills all its function properly.

### Fixed

- Dioxide actions now work properly.
- The "/b" command to return to previous directory was fixed.
- Fixed error when choosing N when running Admin command with Dioxide installed (simple implementation).

## 0.5.0-alpha

### Added

- Actions were created for before and after the use of Dioxide.
- Dioxide service was implemented and works as expected, one more feature is missing.
- A (temporary) warning was added to notify about the use of Dioxide.
- The PowerShell code for the service was added to the script.

## 0.4.0-alpha

### Added

- Added extra function commands, "reset" and "uninstall".
- Added option to uninstall Dioxide from system.
- Added new commands in help message.
- Added space for service implementation, and warning message.
- Now using an administrator command with "d" creates a new .bat called "Post use" to create last directory file and start Dioxide service.

## 0.3.1-alpha

### Changed

- Inconsistency in README.MD file.
- Minor changes of code.

## 0.3.0-alpha

### Added

- Added checks to know whether to execute "d" or check a command.
- Correctly implemented a check for "dev mode".
- Implemented a better way to receive option input with choice.exe.

### Changed

- Reduced timeout from 3 sec to 1 sec.
- Changed commands from "--" to "/".
- Changed use of :EOF to :ExitNoCLS.

### Fixed

- The title is updated to the current directory and not the previous one.
- Minor fix to error when using /fi.

## 0.2.0-alpha

### Added

- Extra check of arguments.
- First implementation of the d function.

### Changed

- Change in help message.
- Changed the path in the variable.
- Changed if for safe check.
- Respective modifications in the use of Path variables.

## 0.1.0

- Initial Release.
- Basic functions implementation.

[KaC-link]: https://keepachangelog.com/
[Smv-link]: https://semver.org/
