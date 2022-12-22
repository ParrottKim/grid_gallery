# grid_gallery
<img src="https://img.shields.io/static/v1?label=platform&message=flutter&color=1ebbfd" alt="github">

A Flutter package provides customizable widget to user select and list up images in device storage without android and iOS native photo picker.

![grid_gallery](https://user-images.githubusercontent.com/83802425/209039655-8841adc0-51e7-4387-bb3e-a89171b34d60.gif)

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage
### Request for permission
#### Android
No configuration required

#### iOS
Add the following keys and value to `Info.plist` file, located in `<project root>/ios/Runner/Info.plist`
```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>In order to access your photo library</string>
<key>NSCameraUsageDescription</key>
<string>In order to access your camera</string>
```

## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.
