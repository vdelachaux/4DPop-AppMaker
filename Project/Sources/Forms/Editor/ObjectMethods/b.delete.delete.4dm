LISTBOX DELETE ROWS:C914(*;"list.delete";(OBJECT Get pointer:C1124(Object named:K67:5;"list.delete.items"))->)

_o_param_SET_ARRAY (Storage:C1525.environment.domPref;\
"delete/array";\
OBJECT Get pointer:C1124(Object named:K67:5;"list.delete.items"))

LISTBOX SELECT ROW:C912(*;"list.delete";0;lk remove from selection:K53:3)
OBJECT SET ENABLED:C1123(*;OBJECT Get name:C1087(Object current:K67:2);False:C215)
