Form:C1466.plist.push(New object:C1471("key";"";"value";""))

Form:C1466.preparation.index:=Form:C1466.plist.length
LISTBOX SELECT ROW:C912(*;"info.listbox";Form:C1466.preparation.index;lk replace selection:K53:1)
OBJECT SET ENABLED:C1123(*;"b.key.delete";True:C214)

EDIT ITEM:C870(*;"info.plist.keys")