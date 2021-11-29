# MIS Communicator Update

Two packages, one with the X86 version and another with the X64 version.

**************************************************************************

New Features.
	- Added the ability to search the occurrences of a Communication Profile.
	- Improved the speed of selecting a Control through left-click in highly populated Forms.
	- Loopers are no longer filled in Designer if their total number of Controls exceeds 300.
	- Added the ability to enable APPX restricted capabilities.

Kalipso Designer was updated.
	- Fixed issue setting font in the Properties Toolbar.
	- Fixed issue when using 'Variables to Set' option in 'Start Service' Action.
	- Fixed issue converting projects from versions prior to 3.6.
	- Fixed display issue in "Update Project" Action.
	- Fixed issue sending Push Notification to Windows devices.
	- Fixed issue editing a Control belonging to a Container located in a Plane other than 0. The Control with appear duplicated in the Project tree.
	- Fixed issue validating Danish voice license.
	- Fixed issue editing Voice Settings. When licensing mode was set to 'MIS Communicator', 'Communication Profile' parameter wasn't being correctly saved.
	- Fixed issue retrieving the text representation of a 'Set Db Profile Parameter' Action when the Profile was from a Linked Project or Component no longer linked.
	- fixed issue entering Action through keyboard when the target line isn't visible.
	- Fixed issue editing a Control inside of a Container. When saving the properties, Kalipso was validating the position of the Control and always keeping a margin of 10, thus automatically moving the Control even if no property was changed.
	- Fixed issue in 'JSON Get Value'. After editing the 'JSON' value, the input would no longer accept focus.
	- Fixed issue in Find. When analyzing 'Start Timer' Action, the analyzed Timer name was the name of the Timer with the specified Id in the current Form instead of the Form where the Action was.
	- Fixed issue pasting Form. Background Image reference would be lost.
	- Fixed issue editing 'Synchronize' Action when the 'Mode' Parameter has an unexpected value.
	- Fixed issue resizing Looper cell.
	- Fixed issue pasting a Control with a 'Keyboard' Action where the 'Type' Parameter has an unexpected value.
	- Fixed issue create a Table in a Report. If creating the Table returned an error, a crash would be produced instead of displaying the error message.
	- Fixed issue Deploying Project's Component. If all variables had some access level, an error would be produced.
	- Fixed issue refreshing a Web Service's Operation that exists both in SOAP 1.0 and SOAP 1.2. If the Operation was created before Kalipso started prefixing Operations to distinguish them between SOAP 1.0 and SOAP 1.2, a new Operation would be created instead of updating the existing one.
	- "ACD Scan" Actions weren't showing up on the search for actions to create.
	- Fixed issue in 'CheckSum' Action. When using 'CRC32' Type, 'Unicode' parameter wasn't available.
	- Fixed issue generating Project's 'IPA Scripts' and 'KClient for iOS'. Hyphen (-) character wasn't being allowed in 'Company' parameter.
	- Fixed issue setting Series in a Multi Line/Bar Chart. Expression Editor for the Series wasn't displaying Local Variables.
	- Fixed issue setting Color in a Multi Line/Bar Chart. Expression Editor for the Colo wasn't being called.
	
KClient was updated.
	- Fixed bug in simulator showing names of TVARs() in the trace window with linked projects. It was only showing names of TVARs from the main project.
	- Updated Point Mobile scan interface to return code type 112 for GS1 DataMatrix.
	- Fixed Point Mobile scan interface no to return the terminator with the barcode data result.
	- Fixed bug in Win10 client connecting to the local database when the project parameters had an encryption key defined that would cause the connection to fail.
	- Fixed bug in Win10 client restarting after updating a project with KZP file when the project contained resource fonts.
	- Updated all clients SQLite to version 3.36 (latest available) to include the most recent security fixes.
	- Updated OpenSSL lib on Android to version 1.1.1l  to include the most recent security fixes.
	- Fixed bug on iOS sending files over FTP that would cause file transfer to fail if the file size was exactly a multiple of 4096 bytes.
	- Fixed bug on Android, SetFocus() was not being correctly applied for Table Control.
	- Memory optimizations made to Android client when loading big images in loopers.
	- Updated Win10 kclient to support TLS 1.2 on Sockets.
	- Fixed bug on Android with MessageBox action with multiple buttons. When using the ENTER key from a physical keyboard to validate, it would validate the default button instead of the focused button.
	- Changes made on Android KClient with Zebra Barcode Scanning API to workaround a bug in Zebra SDK that exists on some devices, the configurations made to the scanner engine could be lost when sending the App to the background and then returning to the App again.
	- Fixed bug in Win32 clients that would cause application to crash if calling SetFocus() to a RadioButton control.
	- Fixed bug in Win10 client that would cause click on Table Control Header to also trigger click on Table Control.
	- Fixed bug on Android 8.0 or higher initializing Forms for PresentForm() action that could cause application to crash.
	- Fixed bug in CortexScanConnect on iOS, it was not correctly initializing the decoder with UTF8.
	- Fixed ShellExecute on iOS to have the same behaviour has click on File Explorer, to show the document in a preview window when possible.
	- Fixed bug in Honeywell Scan interface on Android, when the App was going to background, the scanner was not being correctly released for other Apps/System to be able to use it.