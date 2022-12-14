Class extends lep

// https:// Ss64.com/osx/ditto.html

Class constructor($rc : Object; $tgt : 4D:C1709.File)
	
	Super:C1705()
	
	This:C1470.src:=$rc
	This:C1470.tgt:=$tgt
	
	This:C1470.CONSTANTS:=New object:C1471
	
	// Create or extract from a PKZip archive instead of the default CPIO.
	// PKZip archives should be stored in filenames ending in .zip.
	This:C1470.CONSTANTS.PKZip:=True:C214
	
	// When creating an archive, embed the parent directory name src in dst_archive.
	This:C1470.CONSTANTS.keepParent:=True:C214
	
	// Preserve resource forks and HFS meta-data.
	// As of Mac OS X 10.4, --rsrc is default behavior.
	This:C1470.CONSTANTS.rsrc:=True:C214
	
	// When creating a PKZip archive, preserve resource forks and HFS meta-data in the
	// subdirectory __MACOSX. PKZip extraction will automatically find these resources.
	This:C1470.CONSTANTS.sequesterRsrc:=True:C214
	
	// Preserve extended attributes (requires --rsrc).
	// As of Mac OS X 10.5, --extattr is the default.
	This:C1470.CONSTANTS.extattr:=True:C214
	
	// Preserve quarantine information.
	// As of Mac OS X 10.5, --qtn is the default.
	This:C1470.CONSTANTS.qtn:=True:C214
	
	// The compression level can be set from 0 to 9, where 0 represents no compression
	// By default, ditto will use the default compression level as defined by zlib.
	This:C1470.CONSTANTS.zlibCompressionLevel:=-1
	
	// Allow ditto to prompt for a password to use to extract the contents of a password-encrypted ZIP archive
	This:C1470.CONSTANTS.password:=False:C215
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
Function archive($tgt : 4D:C1709.File)
	
	This:C1470.tgt:=$tgt || This:C1470.tgt
	
	This:C1470.tgt.delete()
	
	This:C1470.launch(This:C1470._cmd("ditto -c ")+This:C1470.quoted(This:C1470.src.path)+" "+This:C1470.quoted(This:C1470.tgt.path))
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
Function extract($tgt : 4D:C1709.Folder)
	
	This:C1470.tgt:=$tgt || This:C1470.tgt
	
	This:C1470.launch(This:C1470._cmd("ditto ")+This:C1470.quoted(This:C1470.src.path)+" "+This:C1470.quoted(This:C1470.tgt.path))
	
	// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
Function _cmd($cmd : Text) : Text
	
	var $create : Boolean
	$create:=Position:C15("-c "; $cmd)>0
	
	If (This:C1470.CONSTANTS.PKZip)
		
		$cmd+="-k "  // Create or extract from a PKZip archive instead of the default CPIO.
		
		If (This:C1470.CONSTANTS.sequesterRsrc)
			
			$cmd+="--sequesterRsrc "  // Preserve resource forks and HFS meta-data in the subdirectory __MACOSX.
			
		End if 
	End if 
	
	If ($create)
		
		If (This:C1470.CONSTANTS.keepParent)
			
			$cmd+="--keepParent "  // Embed the parent directory name src in dst_archive.
			
		End if 
		
		If (This:C1470.CONSTANTS.zlibCompressionLevel>=0)
			
			$cmd+="--zlibCompressionLevel "+String:C10(This:C1470.CONSTANTS.zlibCompressionLevel)+" "
			
		End if 
		
	Else 
		
		If (This:C1470.CONSTANTS.password)
			
			$cmd+="--password "  // Allow ditto to prompt for a password to use to extract the contents of the file
			
		End if 
	End if 
	
	If (Not:C34(This:C1470.CONSTANTS.rsrc))
		
		$cmd+="--norsrc "  // Do not preserve resource forks and HFS meta-data.
		
		If (Not:C34(This:C1470.CONSTANTS.extattr))
			
			$cmd+="--noextattr "  // Do not preserve extended attributes (requires --norsrc)
			
		End if 
	End if 
	
	return $cmd