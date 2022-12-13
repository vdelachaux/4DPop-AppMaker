//%attributes = {"invisible":true}
var $icon : Picture

READ PICTURE FILE:C678(File:C1566("/RESOURCES/Images/Play.png").platformPath; $icon)

EXECUTE METHOD:C1007("quickOpenPushAction"; *; New object:C1471(\
"name"; "4DPop AppMaker Run"; \
"shortcut"; "build"; \
"icon"; $icon; \
"formula"; Formula:C1597(popAppMakerRun)))

EXECUTE METHOD:C1007("quickOpenPushAction"; *; New object:C1471(\
"name"; "4DPop AppMaker Settings"; \
"icon"; $icon; \
"formula"; Formula:C1597(popAppMakerParameters)))