//%attributes = {}
var AppMaker : cs:C1710.AppMaker
AppMaker:=cs:C1710.AppMaker.new()

//var $bool : Boolean
ASSERT:C1129(AppMaker.database.isMethodAvailable(Current method name:C684))
ASSERT:C1129(Not:C34(AppMaker.database.isMethodAvailable("hello world")))

//var $c : Collection
//$c:=$AppMaker.database.methods()
//$AppMaker.database.clearCompiledCode()
//$AppMaker.host.restart()
//var $credentials : Object
//$credentials:=AppMaker.credantials

AppMaker.run()

