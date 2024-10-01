property disk : 4D:C1709.Folder

Class extends lep

// === === === === === === === === === === === === === === === === === === === === === === ===
Class constructor($target : 4D:C1709.File; $content)
	
	Super:C1705()
	
	This:C1470.target:=$target
	This:C1470.content:=Null:C1517
	This:C1470.disk:=Null:C1517
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
	/// Create a disk image image
Function create($content) : Boolean
	
/*
hdiutil create <sizespec> <imagepath>
Size specifiers:
    -size < ?? | ??b | ??k | ??m | ??g | ??t | ??p | ??e >
    -sectors <count>
    -megabytes <count>
	
Image options:
    -library <MKDrivers>
    -layout <layout>[GPTSPUD or per -fs]
MBRSPUD - Single partition - Master Boot Record Partition Map
SPUD - Single partition - Apple Partition Map
UNIVERSAL CD - CD/DVD
NONE - No partition map
GPTSPUD - Single partition - GUID Partition Map
SPCD - Single partition - CD/DVD
UNIVERSAL HD - Hard disk
ISOCD - Single partition - CD/DVD with ISO data
    -partitionType <partitionType>[per -fs]
    -align <sector alignment>[8 sectors]
    -ov
	
Filesystem options:
    -fs <filesystem>
UDF - Universal Disk Format (UDF)
MS-DOS FAT12 - MS-DOS (FAT12)
MS-DOS - MS-DOS (FAT)
MS-DOS FAT16 - MS-DOS (FAT16)
MS-DOS FAT32 - MS-DOS (FAT32)
HFS+ - Mac OS Extended
Case-sensitive HFS+ - Mac OS Extended (Case-sensitive)
Case-sensitive Journaled HFS+ - Mac OS Extended (Case-sensitive, Journaled)
Journaled HFS+ - Mac OS Extended (Journaled)
ExFAT - ExFAT
Case-sensitive APFS - APFS (Case-sensitive)
APFS - APFS
   -volname <volumename>["untitled"]
   -stretch < ?? | ?b | ??k | ??m | ??g | ??t | ??p | ??e > (HFS+)
	
New Blank Image options:
    -type <image type>[UDIF]
SPARSEBUNDLE - sparse bundle disk image
SPARSE - sparse disk image
UDIF - read/write disk image
UDTO - DVD/CD master
   -[no]spotlightdo (not) create a Spotlight™ index
	
Image from Folder options:
   -srcfolder <source folder>
   -[no]spotlightdo (not) create a Spotlight™ index
   -[no]anyownersdo (not) attempt to preserve owners
   -[no]skipunreadabledo (not) skip unreadable objects [no]
   -[no]atomicdo (not) copy to temp location and then rename [yes]
   -srcowners on|off|any|auto [auto]
   onenable owners on source
   offdisable owners on source
   anyleave owners state on source unchanged
   autoenable owners if source is a volume
   -format <image type>[UDZO]
UDRO - read-only
UDCO - compressed (ADC)
UDZO - compressed
UDBZ - compressed (bzip2), deprecated
ULFO - compressed (lzfse)
ULMO - compressed (lzma)
UFBI - entire device
IPOD - iPod image
UDSB - sparsebundle
UDSP - sparse
UDRW - read/write
UDTO - DVD/CD master
UNIV - hybrid image (HFS+/ISO/UDF)
SPARSEBUNDLE - sparse bundle disk image
SPARSE - sparse disk image
UDIF - read/write disk image
UDTO - DVD/CD master
	
Image from Device options:
Note: Filesystem options (-fs, -volname, -stretch) ignored with -srcdevice
   -srcdevice <source dev node, e.g. disk1, disk2s1>
   -format <image type>[UDZO]
UDRO - read-only
UDCO - compressed (ADC)
UDZO - compressed
UDBZ - compressed (bzip2), deprecated
ULFO - compressed (lzfse)
ULMO - compressed (lzma)
UFBI - entire device
IPOD - iPod image
UDSB - sparsebundle
UDSP - sparse
UDRW - read/write
UDTO - DVD/CD master
    -segmentSize < ?? | ??b | ??k | ??m | ??g | ??t | ??p | ??e > (deprecated)
                 (sectors, bytes, KiB, MiB, GiB, TiB, PiB, EiB)
	
Attach options:
   -attachattach image after creation
	
Common options:
    -encryption <crypto method>
    AES-128 - 128-bit AES encryption (recommended)
    AES-256 - 256-bit AES encryption (more secure, but slower)
    -stdinpass
    -agentpass
    -certificate <path-to-cert-file>
    -pubkey <public-key-hash>[,pkh2,...]
    -imagekey <key>=<value>
    -tgtimagekey <key>=<value>
    -plist
    -puppetstrings
    -verbose
    -debug
    -quiet
*/
	
	// TODO: Allow collection & more (File, Folder,…)
	
	This:C1470.content:=$content
	
	var $srcPath; $tgtPath : Text
	
	Case of 
			//______________________________________________________
		: (Value type:C1509(This:C1470.content)=Is text:K8:3)
			
			$srcPath:=This:C1470.content
			
			//______________________________________________________
		: (Value type:C1509(This:C1470.content)=Is object:K8:27)
			
			$srcPath:=This:C1470.content.path
			
			//______________________________________________________
		Else 
			
			// A "Case of" statement should never omit "Else"
			
			//______________________________________________________
	End case 
	
	Case of 
			//______________________________________________________
		: (Value type:C1509(This:C1470.target)=Is text:K8:3)
			
			$tgtPath:=This:C1470.target
			
			//______________________________________________________
		: (Value type:C1509(This:C1470.target)=Is object:K8:27)
			
			$tgtPath:=This:C1470.target.path
			
			//______________________________________________________
		Else 
			
			// A "Case of" statement should never omit "Else"
			
			//______________________________________________________
	End case 
	
	If ((This:C1470.target#Null:C1517) && This:C1470.target.exists)
		
		This:C1470.target.delete()
		
	End if 
	
	This:C1470.launch("hdiutil create -srcfolder "+This:C1470.quoted($srcPath)+" -format UDBZ "+This:C1470.quoted($tgtPath))
	
	return (This:C1470.success)
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
	/// Atach (mount) disk image
Function attach() : Boolean
	
/*
hdiutil attach <image>
Device options:
    -readonlyforce read-only
    -kernelattempt to attach the image in-kernel
	
Mount options:
    -mount required|optional|suppressedmount volumes?
    -nomountsame as -mount suppressed
    -mountpoint <path>mount at <path> instead of inside /Volumes
    -mountroot <path>mount volumes on <path>/<volname>
    -mountrandom <path>mount volumes on <path>/<random>
	
Processing options (defaults per framework preferences):
    -[no]verify(do not) verify image checksums
    -[no]autofsck(do not) perform automatic filesystem checks
    -[no]autoopen(do not) open root of new mounts
	
Common options:
    -encryption <crypto method>
        AES-128 - 128-bit AES encryption (recommended)
        AES-256 - 256-bit AES encryption (more secure, but slower)
    -stdinpass
    -agentpass
    -recover <keychain-file>
    -imagekey <key>=<value>
    -drivekey <key>=<value>
    -shadow <shadowfile>
    -insecurehttp
    -cacert <file | dir>
    -plist
    -puppetstrings
    -verbose
    -debug
    -quiet
*/
	
	If (This:C1470._target())
		
		This:C1470.launch("hdiutil attach "+This:C1470.quoted(This:C1470.target.path))
		
		If (This:C1470.success)
			
			var $pos; $len : Integer
			This:C1470.success:=Match regex:C1019("(?mi-s)(/Volumes/[^$]*)"; This:C1470.outputStream; 1; $pos; $len)
			
			If (This:C1470.success)
				
				This:C1470.disk:=Folder:C1567(Substring:C12(This:C1470.outputStream; $pos; $len))
				This:C1470.success:=This:C1470.disk.exists
				
			Else 
				
				This:C1470._pushError("hdiutil attach "+This:C1470.quoted(This:C1470.target.path)+": failed")
				
			End if 
		End if 
	End if 
	
	return (This:C1470.success)
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
	/// Detach (unmount) disk image from system
Function detach() : Boolean
	
/*
hdiutil detach <devname>
	
Note: you can specify a mount point (e.g. /Volumes/MyDisk)
      instead of a dev node (e.g. /dev/disk1)
	
Options:
    -forceforcibly detach
	
Common options:
    -verbose
    -debug
    -quiet
*/
	
	If (This:C1470._disk())
		
		This:C1470.launch("hdiutil detach "+This:C1470.quoted(Delete string:C232(This:C1470.disk.path; Length:C16(This:C1470.disk.path); 1)))
		
	End if 
	
	return (This:C1470.success)
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
Function _target() : Boolean
	
	This:C1470.success:=(This:C1470.target#Null:C1517)\
		 && (This:C1470.target.exists#Null:C1517)\
		 && (This:C1470.target.path#Null:C1517)\
		 && (Bool:C1537(This:C1470.target.exists))
	
	If (Not:C34(This:C1470.success))
		
		This:C1470._pushError("Invalid target "+(This:C1470.target ? "" : String:C10(This:C1470.target.path)))
		
	End if 
	
	return (This:C1470.success)
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
Function _disk() : Boolean
	
	This:C1470.success:=(This:C1470.disk#Null:C1517) && This:C1470.disk.exists
	
	If (Not:C34(This:C1470.success))
		
		This:C1470._pushError("Invalid disk "+(This:C1470.disk ? "" : This:C1470.disk.path))
		
	End if 
	
	return (This:C1470.success)