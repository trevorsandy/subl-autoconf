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
  WScript.Echo "= Starting operations ="
  WScript.Echo

  If Not fso.FolderExists(sublDir) Then
    WScript.Echo "Sublime Text " & sublVersion & " not installed... Continuing anyway"
    fso.CreateFolder(sublDir)
  End If

  Dim pkgDir
  Dim pkgBckDir

  pkgDir = sublDir & "\Packages"
  pkgBckDir = pkgDir & ".bck"

  If fso.FolderExists(pkgBckDir) Then
    fso.DeleteFolder pkgBckDir, true

    If fso.FolderExists(pkgBckDir) Then
      WScript.Echo "Removing previous backup... KO"
      WScript.Quit
    Else
      WScript.Echo "Removing previous backup... OK"
    End If
  End If

  If fso.FolderExists(pkgDir) Then
    fso.MoveFolder pkgDir, pkgBckDir

    If fso.FolderExists(pkgDir) And Not fso.FolderExists(pkgBckDir) Then
      WScript.Echo "Backing up existing Packages... KO"
      WScript.Quit
    Else
      WScript.Echo "Backing up existing Packages... OK"
    End If
  End If

  fso.CreateFolder(pkgDir)
  fso.GetFolder(launchDir & "\User").Copy pkgDir & "\User"

  If Not fso.FolderExists(pkgDir & "\User") Then
    WScript.Echo "Moving new Packages... KO"
    WScript.Quit
  Else
    WScript.Echo "Moving new Packages... OK"
  End If

  Dim instPkg
  Dim pkgCtrl

  instPkg = sublDir & "\Installed Packages"
  pkgCtrl = instPkg & "\Package Control.sublime-package"

  If Not fso.FileExists(pkgCtrl) Then
    If Not fso.FolderExists(instPkg) Then
      fso.CreateFolder(instPkg)
    End If

    Dim xHttp: Set xHttp = WScript.CreateObject("Microsoft.XMLHTTP")
    Dim bStrm: Set bStrm = WScript.CreateObject("Adodb.Stream")

    xHttp.Open "GET", "http://packagecontrol.io/Package%20Control.sublime-package", False
    xHttp.Send

    With bStrm
        .type = 1
        .open
        .write xHttp.responseBody
        .savetofile pkgCtrl, 2
    End With
  End If

  If fso.FileExists(pkgCtrl) Then
    WScript.Echo "Installing package control... OK"
  Else
    WScript.Echo "Installing package control... KO"
    WScript.Echo "Try to install package control manually."
  End If

  WScript.Echo
  WScript.Echo "= Operations ended ="
End If
