# SmartUI

[![CI Status](https://img.shields.io/travis/Reikjavik/SmartUI.svg?style=flat)](https://travis-ci.org/Reikjavik/SmartUI)
[![Version](https://img.shields.io/cocoapods/v/SmartUI.svg?style=flat)](https://cocoapods.org/pods/SmartUI)
[![License](https://img.shields.io/cocoapods/l/SmartUI.svg?style=flat)](https://cocoapods.org/pods/SmartUI)
[![Platform](https://img.shields.io/cocoapods/p/SmartUI.svg?style=flat)](https://cocoapods.org/pods/SmartUI)

## Description

SmartUI is a framework inspired by SwiftUI. It uses the same syntax and principles of UI development as its origin as similar as it's possible. 

The main idea behind is to provide a possibility of easy transition from SmartUI to SwiftUI by a simple code copying and reuse and give an opportunity to developers to get familiar with declarative UI approach.

## Usage

To get SwiftUI like behaviour it's recommended to use **ContainerView** for layouting.
```swift
import UIKit
import SmartUI

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        ContainerView {
            Text("Hello, world!")
        }.layout(in: self.view)
    }
}
```
There's also a possibility to use **WrapperView** instead of **ContainerView**. In this case SmartUI views will **fill** the parent.
Both **ContainerView** and **WrapperView** are UIViews and can be layouted with constraints.

In opposite it is also available to provide a custom UIView to SmartUI layout. It can be easy implemented with **CustomView**.
```swift
ContainerView { [unowned self] in
    List {[
        self.galleryView,
        CustomView(view: self.pageControl)
    ]}
}
```
It is also possible to provide a custom modifier for every SmartUI view. For this purpose the **CustomModifier** can be used. 
```swift
Text("Hello, world!")
.customModifier { view -> UIView in
    view.backgroundColor = .red
    return view
}
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

iOS 10 and above.

## Installation

SmartUI is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SmartUI'
```
## Limitations

SmartUI is based on UIKit and NSLayoutCostraints. It tries to copy the SwiftUI behaviour but it's not always possible. The biggest issue is using multiline UILabels in UIStackViews. That's why there are some additional view modifiers are provided like `.contentHuggingPriority` and `.contentCompressionResistance` and SmartUI Stacks also support `.fill` alignment mode which SwiftUI's Stacks do not.

SmartUI gives more control to different layout components but also requiers understanding of advanced UIKit principles. Get familiar with provided example project, it might be helpful.  

## Author

Igor Tiukavkin, in.tyukavkin@gmail.com

## License

SmartUI is available under the MIT license. See the LICENSE file for more info.
