[Setup]
; REMARQUE : La valeur de AppId identifie l'application. Ne la modifiez pas si vous publiez des mises à jour !
AppId={{5C9E1B23-C2A8-4395-8F12-88E6A6A5E3E7}
AppName=Training Toolkit
AppVersion=0.1.1
AppPublisher=VIV
; Installation au niveau utilisateur pour éviter l'UAC (nécessaire pour les MAJ automatiques silencieuses)
DefaultDirName={userpf}\TrainingToolkit
PrivilegesRequired=lowest
OutputDir=Output
OutputBaseFilename=TrainingToolkit-Setup
Compression=lzma
SolidCompression=yes
; Force la fermeture de l'application Flutter en cours d'exécution
CloseApplications=force

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
; IMPORTANT: Assurez-vous que le chemin pointe bien vers votre dossier Release compilé
Source: "build\windows\x64\runner\Release\training_toolkit.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{autoprograms}\Training Toolkit"; Filename: "{app}\training_toolkit.exe"
Name: "{autodesktop}\Training Toolkit"; Filename: "{app}\training_toolkit.exe"; Tasks: desktopicon

[Run]
Filename: "{app}\training_toolkit.exe"; Description: "{cm:LaunchProgram,Training Toolkit}"; Flags: nowait postinstall skipifsilent
