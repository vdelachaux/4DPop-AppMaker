//%attributes = {"invisible":true}
// ----------------------------------------------------
// Method : doc_Is_Relative_Path
// Created 02/06/08 by vdl
// ----------------------------------------------------
// Description
// Tests if the path is a relative pathname.
// ----------------------------------------------------
var $0 : Boolean
var $1 : Text

If (Length:C16($1)>0)
	
	$0:=(\
		(($1[[1]]="/") | ($1[[1]]=":") | ($1[[1]]="\\"))\
		 & (Position:C15(":\\"; $1)=0) | ($1[[1]]=".")\
		)
	
End if 
