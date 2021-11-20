# SmartUI

[![Version](https://img.shields.io/cocoapods/v/SmartUI.svg?style=flat)](https://cocoapods.org/pods/SmartUI)
[![License](https://img.shields.io/cocoapods/l/SmartUI.svg?style=flat)](https://cocoapods.org/pods/SmartUI)
[![Platform](https://img.shields.io/cocoapods/p/SmartUI.svg?style=flat)](https://cocoapods.org/pods/SmartUI)

## Description

SmartUI is a framework inspired by SwiftUI. It uses the same syntax and principles of UI development as its origin as similar as it's possible. 

The main idea behind is to provide a possibility of easy transition from SmartUI to SwiftUI by a simple code copying and reuse and give an opportunity to developers to get familiar with declarative UI approach.

**Please, visit** [Documentation page](Documentation/Documentation.md) for finding best practices and recommendations. This will help you a lot.

The full list of all available views and modifiers can be found [here](Documentation/Availability.md).


## Usage

In order to get SwiftUI like behaviour it's recommended to use **ContainerView** for layouting. **ContainerView** is just a simple UIView and can be used anywhere in UIKit views hierarchy. 

It is also possible to replace only a part of UIKit views with SmartUI views, because SmatUI views will be converted to UIKit views with NSLayoutConstraints during the layout cycle. 

For more details, please, read [documentation](Documentation/Documentation.md).
```swift
import UIKit
import SmartUI

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        ContainerView { [unowned self] in
            ScrollView {
                VStack {[
                    Text("?")
                        .font(Font.system(size: 60, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 100, height: 100)
                        .background(Color.blue.opacity(0.4))
                        .clipShape(Circle())
                        .padding([.top, .bottom], 40),
                    Text("Sign In")
                        .font(Font.system(size: 24, weight: .semibold))
                        .foregroundColor(accentColor)
                        .padding(.bottom, 20),
                    TextField("Username", text: self.username)
                        .foregroundColor(.black)
                        .padding(16)
                        .background(grayBackground)
                        .cornerRadius(6.0)
                        .padding(.bottom, 20),
                    SecureField("Password", text: self.password)
                        .foregroundColor(.black)
                        .padding(16)
                        .background(grayBackground)
                        .cornerRadius(6.0)
                        .padding(.bottom, 20)
                    ,
                    Button("Continue", action: { [unowned self] in
                        self.view.endEditing(true)
                        self.handleSignIn()
                    })
                    .font(Font.system(size: 20))
                    .disabled(self.notValid),
                ]}.padding(16)
            }
            .bindToKeyboard(extraOffset: 16.0)
        }.layout(in: view)
    }
}
```

## Example

To run the example project, clone the repo, and do `pod install` in the Example directory first.

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

## Contirubution
The project is considered as **Open Source**. Do not hesitate to contribute.

## Author

Igor Tiukavkin, in.tyukavkin@gmail.com

## License

SmartUI is available under the MIT license. See the LICENSE file for more info.
