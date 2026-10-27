; Inno Setup script for the Windows x64 installer. windows.yml compiles it
; after the Package step:
;
;   ISCC /DAppVersion=0.33.1-136-gd85f7738d /DVersionInfo=0.33.1.136
;        /DSourceDir=<abs>\dist /DOutputDir=<abs>\installer
;        packaging\windows\metroid_prime_port.iss
;
; It installs per user, with no administrator rights, into
; %LOCALAPPDATA%\Programs\Metroid Prime Port by default. The port writes
; everything into a user\ folder beside the executable when that folder can be
; written to (docs/NATIVE_PORT.md), so a folder the player owns keeps the
; install portable. A folder under Program Files would send it to
; %APPDATA%\Metroid Prime instead.
;
; The installer carries dist\ as it is: the executable, Dawn's DLLs, ffmpeg.exe,
; the documents and licenses\. No disc image or game data, ever. CI's user\
; folder (the startup check's log and caches) is left out, and the uninstaller
; removes only what was installed, so a player's user\ (saves, settings, mods)
; stays.

#ifndef AppVersion
  #define AppVersion "0.0.0"
#endif
#ifndef VersionInfo
  #define VersionInfo "0.0.0.0"
#endif
#ifndef SourceDir
  #define SourceDir AddBackslash(SourcePath) + "..\..\dist"
#endif
#ifndef OutputDir
  #define OutputDir AddBackslash(SourcePath) + "..\..\installer"
#endif

#define AppName "Metroid Prime Port"
#define AppExe "metroid_prime_port.exe"

[Setup]
; Fixed for good: Windows finds an earlier install (to upgrade or remove) by it.
AppId={{A66D7BFC-CCEB-4B28-B03C-77CFCC706572}
AppName={#AppName}
AppVersion={#AppVersion}
AppVerName={#AppName} {#AppVersion}
AppPublisher=Metroid Prime Port contributors
AppPublisherURL=https://github.com/Odrannnn/MetroidPrimePort
AppSupportURL=https://github.com/Odrannnn/MetroidPrimePort/issues
VersionInfoVersion={#VersionInfo}
VersionInfoProductVersion={#VersionInfo}
VersionInfoProductTextVersion={#AppVersion}
PrivilegesRequired=lowest
DefaultDirName={localappdata}\Programs\{#AppName}
DisableDirPage=no
DefaultGroupName={#AppName}
DisableProgramGroupPage=yes
; {localappdata} is intended here: the install is the player's own.
UsedUserAreasWarning=no
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
; SourceDir is the base for relative paths here, so name the icon from the script.
SetupIconFile={#SourcePath}..\metroid_prime_port.ico
UninstallDisplayIcon={app}\{#AppExe}
UninstallDisplayName={#AppName}
SourceDir={#SourceDir}
OutputDir={#OutputDir}
OutputBaseFilename=metroid-prime-port-{#AppVersion}-windows-x86_64-setup
Compression=lzma2/max
SolidCompression=yes
WizardStyle=modern
CloseApplications=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "brazilianportuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
; Paths are relative to SourceDir (dist\). user\ is CI's startup-check output.
Source: "*"; DestDir: "{app}"; Excludes: "\user,\user\*,*.iso,*.gcm,*.ciso,*.wbfs,*.rvz,*.nkit.iso"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\{#AppName}"; Filename: "{app}\{#AppExe}"; WorkingDir: "{app}"
Name: "{group}\{cm:UninstallProgram,{#AppName}}"; Filename: "{uninstallexe}"
Name: "{userdesktop}\{#AppName}"; Filename: "{app}\{#AppExe}"; WorkingDir: "{app}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#AppExe}"; WorkingDir: "{app}"; Description: "{cm:LaunchProgram,{#AppName}}"; Flags: nowait postinstall skipifsilent

; No [UninstallDelete]: files the game made (user\, a disc image the player put
; beside the executable, textures\) are not the installer's, and stay.
