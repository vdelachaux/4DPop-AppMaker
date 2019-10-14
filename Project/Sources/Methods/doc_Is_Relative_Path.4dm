//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Method : doc_Is_Relative_Path
  // Created 02/06/08 by vdl
  // ----------------------------------------------------
  // Description
  // Tests if the path is a relative pathname.
  // ----------------------------------------------------
C_BOOLEAN:C305($0)
C_TEXT:C284($1)

If (False:C215)
	C_BOOLEAN:C305(doc_Is_Relative_Path ;$0)
	C_TEXT:C284(doc_Is_Relative_Path ;$1)
End if 

If (Length:C16($1)>0)
	
	$0:=(\
		(($1[[1]]="/") | ($1[[1]]=":") | ($1[[1]]="\\"))\
		 & (Position:C15(":\\";$1)=0) | ($1[[1]]=".")\
		)
	
End if 
