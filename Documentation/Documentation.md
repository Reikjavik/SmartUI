# Documentation
Here you can find some best practices and recommendations.
Table of contents:
* [What is ContainerView?](#what-is-exactly-a-containerView-and-how-to-layout-it)
* [ContainerView alignment](#what-is-containerView-alignment)
* [Updating ContainerViews](#how-to-update-redraw-a-containerView)
* [What is Binding](#what-is-binding-and-how-to-use-it)
* [Publishers](#what-is-publisher)
* [States](#can-smartui-views-have-a-state-and-be-updated-in-some-conditions)
* [Animations](#are-there-animations-available-for-smartui-views)
* [Using UIViews](#can-a-uiview-be-provided-to-smartui)
* [Custom Views and Modifiers](#how-to-create-a-custom-modifier-or-a-view)
* [ViewReader](#what-is-viewReader)

### What is exactly a ContainerView and how to layout it?
**ContainerView** is just a UIView which serves as a container for SmartUI views. The easiest way to layout ContainerView is to call an extension method for UIView **layout(in:)**
```swift
ContainerView {
    Text("Hello, world!")
}.layout(in: self.view)
```
or you can go more tradititional way
```swift
let container = ContainerView {
    Text("Hello, world!")
}
container.translatesAutoresizingMaskIntoConstraints = false
NSLayoutConstraint.activate([
    self.view.topAnchor.constraint(equalTo: container.topAnchor),
    self.view.bottomAnchor.constraint(equalTo: container.bottomAnchor),
    self.view.leadingAnchor.constraint(equalTo: container.leadingAnchor),
    self.view.trailingAnchor.constraint(equalTo: container.trailingAnchor)
])
```
### What is ContainerView alignment?
**ContainerView** also contains a parameter called ***alignment*** which allows to align its content in many different ways. By the default it uses **.center** alignment to get SwiftUI-like layout behavior. It can also be usefull in some cases to use **.fill** alignment, when content of the ContainerView must be strictly aligned to the edges.

### How to update (redraw) a ContainerView?
There is a method in ContainerView called **redraw(on:)**. This method accepts any binding as an arguement and each time when the value of the binding is updated the ContainerView will be completely redrawn. This method can be also configured with update animation from one of the list or custom.

### What is Binding and how to use it?
**Binding** is just a simple callback wrapper. Binding contains a current value variable which can be accessible any time. Ther is a subscription mechainsm provided for Bindings and some modification operators are also available:
* map
* compactMap
* filter
* merge
* combine
* debounce
* mapToVoid
* debug

Use publishers to update bindings' values.

### What is Publisher?
Publisher is a binding which provides an ability to update its value. When update method of a Publisher is called all its subscribers will be notified. Any of the modification operations transforms Publisher to a Binding.

### Can SmartUI views have a State and be updated in some conditions?
For this purpose Bindings can be used. Bindings have a method called view(onUpdate:) which returns a View that can be used in a SmartUI spec. Every time the new value provided to the Binding the View will be redrawn (also possible with animation).
```swift
let textBinding: Binding<String> = .create("Hello, world!")
ContainerView {
    textBinding.view { value in
        Text(value)
    }
}.layout(in: self.view)
```
### Are there animations available for SmartUI views?
There is a method **withAnimation(animation:trigger:content:)** which allows to create animations that will be executed when some trigger (Binding) updated. The mechanism is like in SwiftUI but the animation trigger must be explicitly specified.

### Can a UIView be provided to SmartUI?
Yes, for this purpose you can use **CustomView**
```swift
ContainerView { [unowned self] in
    List {[
        self.galleryView,
        CustomView(view: self.pageControl)
    ]}
}
```

### How to create a custom Modifier or a View?
A custom modifier can be provided in 2 possible ways. The first one is to conform to **Modifier** protocol and then use a method **add(modifier:)** of some View to apply it.
```swift
struct CustomTextModifier: Modifier {
    func modify(_ view: UIView) -> UIView {
        // some view modification
        return view
    }
}

extension Text {
    func myCustomModifier() -> Text {
        self.add(modifier: CustomTextModifier())
    }
}

Text("Hello, world!")
    .myCustomModifier()
```
The second option is to use the predefined **CustomModifier**
```swift
Text("Hello, world!")
.customModifier { view -> UIView in
    view.backgroundColor = .red
    return view
}
```

Unlike modifiers it's not possible to inherit from View to create a custom view, but you can easily create methods for creating new Views
```swift
struct MyViews {
    static func title(title: String, color: UIColor) -> Text {
        Text(title)
            .font(.headline)
            .foregroundColor(Color(color))
    }
}
```

### What is ViewReader? 
ViewReader is a wrapper which allows to get access to some specific UIView in SmartUI spec (the first in the hierarchy). 
There is a generic ViewReader for finding any of UIViews
```swift
ViewReader<UILabel> { label in
    // here you can use label to make some additional setup
    Text("Hello, world!")
        .font(.body)
}
```
If in the exmple above will be more than one Text object, the first one will be taken by the reader.

You can also use ScrollViewReader, TableViewReader and CollectionViewReader
```swift
ScrollViewReader { scrollView in
    ScrollView {
        Text("Hellow, world!")
    }
}
```