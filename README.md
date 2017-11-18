# CWProgressHUD

[![CI Status](http://img.shields.io/travis/ChrishonWyllie/CWProgressHUD.svg?style=flat)](https://travis-ci.org/ChrishonWyllie/CWProgressHUD)
[![Version](https://img.shields.io/cocoapods/v/CWProgressHUD.svg?style=flat)](http://cocoapods.org/pods/CWProgressHUD)
[![License](https://img.shields.io/cocoapods/l/CWProgressHUD.svg?style=flat)](http://cocoapods.org/pods/CWProgressHUD)
[![Platform](https://img.shields.io/cocoapods/p/CWProgressHUD.svg?style=flat)](http://cocoapods.org/pods/CWProgressHUD)



<br />
<br />
<div id="images">
  <img style="display: inline; margin: 0 5px;" src="Github Images/dark-show_iphonexspacegrey_portrait.png" width=200 height=398 />
  <img style="display: inline; margin: 0 5px;" src="Github Images/dark-show-with-progres_iphonexspacegrey_portrait.png" width=200 height=398 />
  <img style="display: inline; margin: 0 5px;" src="Github Images/light-show-success-with-message_iphonexspacegrey_portrait.png" width=200 height=398 />
  <img style="display: inline; margin: 0 5px;" src="Github Images/light-show-error-with-message_iphonexspacegrey_portrait.png" width=200 height=398 />
</div>
 
## Usage


<h3>Displaying the HUD</h3>

```swift
CWProgressHUD.show()
CWProgressHUD.show(withMessage: "Some message you'd like to display")
```

<p>Additional uses</p>

```swift
CWProgressHUD.show(withProgress: someCGFloatValue)
CWProgressHUD.showSuccess(withMessage: "Your image was uploaded successfully!")
CWProgressHUD.showError(withMessage: "Could not load data...")
```


<h3>Dismissing the HUD</h3>
<p>Simply call 'dismiss' to hide the progressHUD

```swift
CWProgressHUD.dismiss()
```


<h3>Customizing the HUD</h3>
<p>The HUD allows for two themes: dark and light. The default theme is light which features a white background and black text/images. The dark theme features reverse; black background with white text/images</p>

```swift
CWProgressHUD.setStyle(.light)
// or
CWProgressHUD.setStyle(.dark)
```


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

CWProgressHUD is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'CWProgressHUD'
```

## Author

ChrishonWyllie, chrishon595@yahoo.com

## License

CWProgressHUD is available under the MIT license. See the LICENSE file for more info.
