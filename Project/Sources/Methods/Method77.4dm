//%attributes = {}
var $pathname : Text
var $folder : 4D:C1709.Folder

$pathname:=Get 4D folder:C485(Database folder:K5:14; *)
$folder:=Folder:C1567(Folder:C1567(fk database folder:K87:14; *).platformPath; fk platform path:K87:2)

ASSERT:C1129($pathname=$folder.platformPath)


