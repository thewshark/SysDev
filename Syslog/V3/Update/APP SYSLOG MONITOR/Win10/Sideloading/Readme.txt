This text file explain how to install your Kalipso Application in windows 10.

1.	Open the application folder;
2.	Select the Add-AppDevPackage.ps1;
3.	Right Click and select Run With Power shell.
4.	Press Y to confirm power Shell questions until install.


NOTE:

To be able to Synchronize your App with MISCommunicator on the same machine you need to execute this command with administrative rights:

checknetisolation loopbackexempt -a -n=[PLEASE POST THE APPLICATION PACKAGE HERE]


To Get the package name use the follow path in file explorer and search for your application package:

%USERPROFILE%\AppData\Local\Packages\


KClient package sample:

SysdevMobile.KClientV50_whdsjj1dnhbm8