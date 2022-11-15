# network_file_system

A peer-to-peer Network File System

## Getting Started

First extract all the contents of the file app.zip and open the folder in Android Studio to run the application. 
You would need to setup a Linux(desktop) device to emulate the application.
Run the file main.dart to launch the application.

If you are going to use the application as the client, please run the following commands before using the application:

1. sudo apt update
2. sudo apt install nfs-common
3. sudo apt install ssh-askpass-gnome

If you are going to use the application as the server, please run the following commands before using the application:

1. sudo apt update
2. sudo apt install nfs-kernel-server
3. sudo apt install ssh-askpass-gnome

The following packages are also needed for the application to work properly:
    1. netstat
    2. gedit (Text Editor)

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
