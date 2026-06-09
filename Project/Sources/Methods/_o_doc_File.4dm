//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : doc_File
// Database: 4D Mobile App
// ID[E4BCA07C239A4A898B5AFF446D5CCD08]
// Created #12-7-2018 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// Waiting for File command !
// ----------------------------------------------------
// Declarations
var $0 : Object
var $1 : Text

var $Boo_invisible; $Boo_locked : Boolean
var $Dat_creation; $Dat_modified : Date
var $Lon_parameters : Integer
var $Gmt_creation; $Gmt_modified : Time
var $Pic_icon : Picture
var $Txt_pathname; $Txt_property : Text
var $Obj_file; $Obj_template : Object

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1; "Missing parameter"))
	
	// Required parameters
	$Txt_pathname:=$1
	
	// Default values
	$Obj_template:=New object:C1471("exist"; False:C215; "name"; ""; "extension"; ""; "fullName"; ""; "isFolder"; False:C215; "isFile"; False:C215; "creationDate"; String:C10(!00-00-00!; ISO date GMT:K1:10; ?00:00:00?); "lastModification"; String:C10(!00-00-00!; ISO date GMT:K1:10; ?00:00:00?); "parent"; ""; "parentFolder"; ""; "nativePath"; ""; "path"; ""; "size"; 0; "icon"; Null:C1517)
	
	// Optional parameters
	If ($Lon_parameters>=2)
		
		// <NONE>
		
	End if 
	
	$Obj_file:=Path to object:C1547($Txt_pathname)
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
If (Length:C16($Txt_pathname)#0)
	
	$Obj_file:=Path to object:C1547($Txt_pathname)
	
	$Obj_file.isFolder:=Bool:C1537(Position:C15($Txt_pathname[[Length:C16($Txt_pathname)]]; ":\\"))
	$Obj_file.isFile:=Not:C34($Obj_file.isFolder)
	$Obj_file.exist:=(Test path name:C476($Txt_pathname)=Is a document:K24:1)
	$Obj_file.fullName:=$Obj_file.name+$Obj_file.extension
	$Obj_file.nativePath:=$Txt_pathname
	$Obj_file.path:=Convert path system to POSIX:C1106($Txt_pathname)
	
	If ($Obj_file.exist)
		
		GET DOCUMENT PROPERTIES:C477($Txt_pathname; $Boo_locked; $Boo_invisible; $Dat_creation; $Gmt_creation; $Dat_modified; $Gmt_modified)
		$Obj_file.creationDate:=String:C10($Dat_creation; ISO date GMT:K1:10; $Gmt_creation)
		$Obj_file.lastModification:=String:C10($Dat_modified; ISO date GMT:K1:10; $Gmt_modified)
		$Obj_file.locked:=$Boo_locked
		$Obj_file.invisible:=$Boo_invisible
		
		$Obj_file.size:=Get document size:C479($Txt_pathname)
		
		GET DOCUMENT ICON:C700($Txt_pathname; $Pic_icon)
		$Obj_file.icon:=$Pic_icon
		
	End if 
	
	$Obj_file.parent:=Convert path system to POSIX:C1106($Obj_file.parentFolder)
	
End if 

For each ($Txt_property; $Obj_template)
	
	If ($Obj_file[$Txt_property]=Null:C1517)
		
		$Obj_file[$Txt_property]:=$Obj_template[$Txt_property]
		
	End if 
End for each 

// ----------------------------------------------------
// Return
$0:=$Obj_file

// ----------------------------------------------------
// End  