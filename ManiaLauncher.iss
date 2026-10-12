; Inno Setup 6 script — create ManiaLauncher_Setup_0.2.0.exe on Windows.
[Setup]
AppId={{C16F051B-E5E9-44D3-9E5D-B2CE7C3E0952}
AppName=ManiaLauncher
AppVersion=0.2.0
AppPublisher=ManiaLauncher Community
DefaultDirName={localappdata}\Programs\ManiaLauncher
DefaultGroupName=ManiaLauncher
OutputDir=dist
OutputBaseFilename=ManiaLauncher_Setup_0.2.0
Compression=lzma2
SolidCompression=yes
UninstallDisplayIcon={app}\ManiaLauncher.exe
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
PrivilegesRequired=lowest
WizardStyle=modern

[Languages]
Name: "brazilianportuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"

[Tasks]
Name: "desktopicon"; Description: "Criar atalho na Área de Trabalho"; GroupDescription: "Atalhos:"; Flags: unchecked

[Files]
Source: "dist\ManiaLauncher.exe"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\ManiaLauncher"; Filename: "{app}\ManiaLauncher.exe"
Name: "{autodesktop}\ManiaLauncher"; Filename: "{app}\ManiaLauncher.exe"; Tasks: desktopicon

[Run]
Filename: "{app}\ManiaLauncher.exe"; Description: "Abrir ManiaLauncher"; Flags: postinstall nowait skipifsilent
