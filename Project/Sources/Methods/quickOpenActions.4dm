//%attributes = {"invisible":true}
var $icon : Picture
READ PICTURE FILE:C678(Folder:C1567(fk resources folder:K87:11).file("Images/Play.png").platformPath; $icon)
EXECUTE METHOD:C1007("quickOpenPushAction"; *; New object:C1471(\
"name"; "4DPop AppMaker Run"; \
"shortcut"; "build"; \
"icon"; $icon; \
"formula"; Formula:C1597(popAppMakerRun)))

//READ PICTURE FILE(Folder(fk resources folder).file("Images/XML.png").platformPath; $icon)
EXECUTE METHOD:C1007("quickOpenPushAction"; *; New object:C1471(\
"name"; "4DPop AppMaker Settings"; \
"icon"; $icon; \
"formula"; Formula:C1597(popAppMakerParameters)))
