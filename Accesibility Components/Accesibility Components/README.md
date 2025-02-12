# Accessibility 

### Accessibility Traits -
These are characteristics that define the element's type and state, shuch as `button`, `selected` or `link`.
Adding appropiate traits helps assistve technology describe UI components and their behaviour more accurately.

```swift
Text("Submit")
    .onTapGesture {
        print("Submitted")
    }
    .accessibilityAddTraits(.isButton)
}
```
### Label -
Provides a vocal description of the UI element that does not display text. Like an icon. Just make sure not to include text
in the label that repeats information that users already have. For example, you could use this  method to label a button
that plays music with the text `Play`. But don't use the label `Play button` because a button already has a trait that identfies 
it as a button.

```swift
Button("Submit") {
    print("Login...")
}
.accessibilityLabel("Submit details")
```
### Vaue -
This parameter allows describing the value represented by a view, but only if that's different than the view's label. As an example
for a slider that you would label as `Volume`, you cna provide the current volume setting as a value, like `60%`.

```swift
Slider(value: $volumeValue, in: 0...100)
    .accessibilityLabel("Volume")
    .accessibilityValue("\(Int(sliderValue))")
```

### Hint -
For providing additional context of directions on what the element deos offer hints. It communicates to the user what happens after
performing the interactive elements like buttons or slider. A hint could be in the form of a brief phrase, like `Purchase the item` or
`Downloads the attachment`.

```swift
Button("Submit") {
    print("Login...")
}
.accessibilityHint("Submits login for form")
```

### Accessibility Hidden -
Sometimes, certain UI elements might be irrelevant for users interacting through assistive technologies. Hiding the experience. This is
essential when chaining multiple views into a single parent element with its own accessibility declaration and omitting child elements.

```swift
Vstack(alignment: .leading) {
    Text("Cities")
        .font(.title)
        .foregroundStyle(.primary)
        .accessibilityLabel("Primary label")
        .accessiblityHidden(true)
    Text("Cities")
        .font(.title)
        .foregroundStyle(.secondary)
        .accessibilityLabel("Secondary label")
        .accessiblityHidden(true)
}
.accessibilityLabel("This will be read to the user not it child element")
```
### Behaviour -
This determines how children of the UI element should be treated by accessbility tools, providing finer control over the acceesibility tree.

There are three accessibility behaviour types: `contain`, `combin` and `ignore`(default).

`contain` behaviour treats each child of a specified container as a separate accessibility element.

Use `.contain` when you want users to interact with or receive information about each component individualy. It's particularly useful in
complex UIs where different elements have distinct function or information, such as a form with multiple input fields or a layout with various
interactive components.

```swift
VStack {
    Text("Settings")
        .accessibilityAddTraits(.isHeader)
    Slider(value: $sliderValue, in: 0...100)
        .accessibilityLabel("this will be read to the user")
        .accessibilityValue("\(Int(sliderValue))")
    Toggle("Enable Feature", isOn: $isToggleOn)
}
.accessibilityElement(children: .contain)
.accessbilityLabel("This will be read to the user too")
```

Use `.combine` behaviour merges all child elements of the container into a single accessible element.

Use `.combine` when the elements of a container are closely related and should be considered as a single interactive entity.
This is often used in simpler or smaller UI components where grouping elements can make understanding and interactive with the
content easier, such as single button with both icon and text that shuold be read as one element.

```swift
VStack {
    Text("Main content")
    Divider()
    Text("Additional information")
}
.accessibilityElement(children: .combine)
.accessibilityLabel("This will be read to the user for all child elements")
```
