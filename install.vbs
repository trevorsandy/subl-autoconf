Dim Arg
Dim Str

If Not LCase(Right(WScript.FullName, 12)) = "\cscript.exe" Then
  For Each Arg In WScript.Arguments
    If InStr(Arg, " ") Then Arg = """" & Arg & """"
    Str = Str & " " & Arg
  Next

  WScript.CreateObject("WScript.Shell").Run "cmd /k cscript //nologo """ & WScript.ScriptFullName & """ " & Str
  WScript.Quit
Else
  Dim sublVersion

  sublVersion = 3

  If WScript.Arguments.Count > 0 Then
    If WScript.Arguments(0) <> "" Then
      sublVersion = WScript.Arguments(0)
    End If
  End If

  Dim sh: Set sh = WScript.CreateObject("WSCript.shell")
  Dim fso: Set fso = WScript.CreateObject("Scripting.FileSystemObject")
  Dim launchDir
  Dim sublDir

  launchDir = fso.GetAbsolutePathName(".")
  sublDir = sh.ExpandEnvironmentStrings("%APPDATA%") & "\Sublime Text " & sublVersion

  WScript.Echo "=== Sublime Text AutoConfig ==="
  WScript.Echo
  WScript.Echo "= Starting my tasks ="
  WScript.Echo

  If Not fso.FolderExists(sublDir) Then
    Dim installAnyway

    WScript.StdOut.Write "Couldn't find Sublime Text " & sublVersion & "... Should I continue anyway? (yes / no) "

    installAnyway = WScript.StdIn.ReadLine
    WScript.Echo

    If LCase(installAnyway) = "yes" Then
      WScript.Echo "Ok, I'll continue the installation!"

      fso.CreateFolder(sublDir)

      WScript.Echo

      If Not fso.FolderExists(sublDir) Then
        WScript.Echo "I couldn't create the Sublime Text directory... You should check if you have the good rights on the following folder: " & sublDir
        WScript.Echo "Come back again :)"
        WScript.Echo
        WScript.Echo "= Bye bye! ="
        WScript.Quit
      End If
    Else
      WScript.Echo "Allright, install Sublime Text 3 and launch me again :)"
      WScript.Echo
      WScript.Echo "= Bye bye! ="
      WScript.Quit
    End If
  End If

  Dim pkgDir
  Dim pkgBckDir

  pkgDir = sublDir & "\Packages"
  pkgBckDir = pkgDir & ".bck"

  If fso.FolderExists(pkgBckDir) And fso.FolderExists(pkgDir) Then
    fso.DeleteFolder pkgBckDir, true

    If fso.FolderExists(pkgBckDir) Then
      WScript.Echo "Removing previous backup...     Fail :("
      WScript.Echo
      WScript.Echo "I couldn't remove the backup directory, please do it manually and come back again!"
      WScript.Echo "This directory is located here: " & pkgBckDir
      WScript.Echo
      WScript.Echo "= Bye bye! ="
      WScript.Quit
    Else
      WScript.Echo "Removing previous backup...     Done :)"
    End If
  End If

  If fso.FolderExists(pkgDir) Then
    fso.MoveFolder pkgDir, pkgBckDir

    If fso.FolderExists(pkgDir) And Not fso.FolderExists(pkgBckDir) Then
      WScript.Echo "Backing up existing packages... Fail :("
      WScript.Echo
      WScript.Echo "I couldn't backup existing packages, please do it manually and come back again!"
      WScript.Echo "You should rename the following directory: " & pkgDir & " like so: " & pkgBckDir
      WScript.Echo
      WScript.Echo "= Bye bye! ="
      WScript.Quit
    Else
      WScript.Echo "Backing up existing packages... Done :)"
    End If
  End If

  fso.CreateFolder(pkgDir)

  If Not fso.FolderExists(pkgDir) Then
    WScript.Echo
    WScript.Echo "I couldn't create the Sublime Text packages directory... You should check if you have the good rights on the following folder: " & pkgDir
    WScript.Echo "Come back again :)"
    WScript.Echo
    WScript.Echo "= Bye bye! ="
    WScript.Quit
  End If

  fso.GetFolder(launchDir & "\User").Copy pkgDir & "\User"

  If Not fso.FolderExists(pkgDir & "\User") Then
    WScript.Echo "Moving new packages...          Fail :("
    WScript.Echo
    WScript.Echo "I couldn't move new packages directory... You should check if you have the good rights on the following folder: " & pkgDir
    WScript.Echo "Come back again :)"
    WScript.Echo
    WScript.Echo "= Bye bye! ="
    WScript.Quit
  Else
    WScript.Echo "Moving new packages...          Done :)"
  End If

  Dim instPkg
  Dim pkgCtrl

  instPkg = sublDir & "\Installed Packages"
  pkgCtrl = instPkg & "\Package Control.sublime-package"

  Dim xHttp: Set xHttp = WScript.CreateObject("Microsoft.XMLHTTP")
  Dim bStrm: Set bStrm = WScript.CreateObject("Adodb.Stream")

  If Not fso.FileExists(pkgCtrl) Then
    If Not fso.FolderExists(instPkg) Then
      fso.CreateFolder(instPkg)

      If Not fso.FolderExists(instPkg) Then
        WScript.Echo
        WScript.Echo "I couldn't create the installed packages directory... You should check if you have the good rights on the following folder: " & pkgDir
        WScript.Echo "Come back again :)"
        WScript.Echo
        WScript.Echo "= Bye bye! ="
        WScript.Quit
      End If
    End If

    xHttp.Open "GET", "http://packagecontrol.io/Package%20Control.sublime-package", False
    xHttp.Send

    With bStrm
        .type = 1
        .open
        .write xHttp.responseBody
        .savetofile pkgCtrl, 2
        .close
    End With
  End If

  If fso.FileExists(pkgCtrl) Then
    WScript.Echo "Installing package control...   Done :)"
  Else
    WScript.Echo "Installing package control...   Fail :("
    WScript.Echo
    WScript.Echo "I couldn't install package control... Please install it manually in order to use your new configuration :)"
  End If

  WScript.Echo
  WScript.Echo "= Node.js & npm related stuff ="
  WScript.Echo

  Dim path
  Dim node
  Dim npm

  npm = False
  path = sh.ExpandEnvironmentStrings("%PATH%")

  If InStr(path, "npm") > 0 Then
    Dim splitPath

    splitPath = Split(path, ";")

    For Each dir In splitPath
      If InStr(dir, "npm") > 0 Then
        npm = True
      End If
    Next
  End If

  Dim installCommand

  installCommand = "npm i -g standard standard-format"

  If npm Then
    Dim installExtraPkg

    WScript.Echo "I have found that the npm command is available!"
    WScript.StdOut.Write "Do you want me to install extra packages needed by some of the Sublime Text packages I previously installed? (yes / no) "

    installExtraPkg = WScript.StdIn.ReadLine

    If LCase(installExtraPkg) = "yes" Then
      WScript.Echo
      WScript.Echo "npm is currently installing needed packages, it can be long, so please wait! I'll tell you when it's done ;)"
      sh.run installCommand, 0, True
      WScript.Echo
      WScript.Echo "The following npm packages should have been installed:"
      WScript.Echo "- standard"
      WScript.Echo "- standard-format"
      WScript.Echo
      WScript.Echo "However, if for some reason they haven't been installed, you can install them manually with the following command: " & installCommand
      WScript.Echo
      WScript.Echo "I'll now configure tern_for_sublime package..."

      Dim ternBinDir
      Dim ternPackageJSON

      ternDir = pkgDir & "\tern_bin"

      fso.CreateFolder(ternDir)

      If Not fso.FolderExists(ternDir) Then
        WScript.Echo
        WScript.Echo "I couldn't create the tern_for_sublime directory... You should check if you have the good rights on the following folder: " & pkgDir
        WScript.Echo "Come back again :)"
        WScript.Echo
        WScript.Echo "= Bye bye! ="
        WScript.Quit
      End If

      ternPackageJSON = ternDir & "\package.json"

      xHttp.Open "GET", "https://raw.githubusercontent.com/ternjs/tern_for_sublime/master/package.json", False
      xHttp.Send

      With bStrm
          .type = 1
          .open
          .write xHttp.responseBody
          .savetofile ternPackageJSON, 2
          .close
      End With

      WScript.Echo
      WScript.Echo "1. Install tern dependencies (via npm, can be long, blablabla, wait till I tell you it's done)"

      sh.CurrentDirectory = ternDir
      sh.run "npm i", 0, True
      sh.CurrentDirectory = launchDir

      Dim tern

      tern = ternDir & "\node_modules\tern\bin\tern"

      If fso.FileExists(tern) Then
        WScript.Echo "2. Configuring tern_for_sublime"

        Dim ternConfigFile

        ternConfigFile = pkgDir & "\User\Tern.sublime-settings"

        Set file = fso.CreateTextFile(ternConfigFile, True)

        file.Write "{" & vbCrLf & _
          "  ""tern_argument_hints"": true," & vbCrLf & _
          "  ""tern_output_style"": ""tooltip""," & vbCrLf & _
          "  ""tern_argument_completion"": true," & vbCrLf & _
          "  ""tern_command"": [" & vbCrLf & _
          "    ""node""," & vbCrLf & _
          "    """ & Replace(tern, "\", "\\") & """," & vbCrLf & _
          "    ""--no-port-file""" & vbCrLf & _
          "  ]" & vbCrLf & _
          "}"

        file.Close

        If fso.FileExists(ternConfigFile) Then
          WScript.Echo
          WScript.Echo "Tern installed and configured successfully!"
        Else
          WScript.Echo "I couldn't create tern config file..."
        End If
      Else
        WScript.Echo
        WScript.Echo "I couldn't install Tern... Please install it manually by running the following command: " & ternCommand
      End If

      If Not fso.FileExists(ternConfigFile) Then
        WScript.Echo "If you launch Sublime Text as is, you will be warned by an error message saying tern isn't installed..."
        WScript.Echo
        WScript.Echo "So, you'll have to create Tern config file: " & pkgDir & "\User\Tern.sublime-settings"
        WScript.Echo "It has to contain the following lines:"
        WScript.Echo
        WScript.Echo "{"
        WScript.Echo "  ""tern_argument_hints"": true,"
        WScript.Echo "  ""tern_output_style"": ""tooltip"","
        WScript.Echo "  ""tern_argument_completion"": true,"
        WScript.Echo "  ""tern_command"": ["
        WScript.Echo "    ""node"","
        WScript.Echo "    """ & tern & ""","
        WScript.Echo "    ""--no-port-file"""
        WScript.Echo "  ]"
        WScript.Echo "}"
      End If
    Else
      WScript.Echo "Ok, I'll let you handle that :)"
      WScript.Echo
      WScript.Echo "All you have to do is run the following command: " & installCommand
    End If
  Else
    WScript.Echo "I have to warn you that I haven't found the npm command in your path!"
    WScript.Echo "I am not able to install the needed packages by some Sublime Text packages I installed..."
    WScript.Echo
    WScript.Echo "To make this right, please install Node.js (with npm, they should stick together) and run the following command: " & installCommand
  End If

  WScript.Echo
  WScript.Echo "= Job done, glad to be of help! ="
End If
