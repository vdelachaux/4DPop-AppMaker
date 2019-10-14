Form:C1466.plist.remove(Form:C1466.preparation.index-1)
Form:C1466.preparation.index:=0

Storage:C1525.preferences.set("info.plist";Form:C1466.plist)

LISTBOX SELECT ROW:C912(*;"info.listbox";0;lk remove from selection:K53:3)
OBJECT SET ENABLED:C1123(*;OBJECT Get name:C1087(Object current:K67:2);False:C215)
