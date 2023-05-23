# inputDelegate

The `inputDelegate` class is intended to handle input widget.  

> #### 📌 This class inherit from the [`widgetDelegate`](widgetDelegate.md) class

## Properties

|Properties|Description|
|----------|-----------|
|**.name** | [*inherited*](staticDelegate.md) |
|**.type** | [*inherited*](staticDelegate.md) |
|**.coordinates** | [*inherited*](staticDelegate.md) |
|**.dimensions** | [*inherited*](staticDelegate.md) |
|**.windowCoordinates** | [*inherited*](staticDelegate.md) |
|**.action** |  [*inherited*](widgetDelegate.md) |
|**.assignable** | [*inherited*](widgetDelegate.md) |
|**.pointer** | [*inherited*](widgetDelegate.md) |
|**.value** | [*inherited*](widgetDelegate.md) |

## 🔸 cs.inputDelegate.new()

The class constructor `cs.inputDelegate.new({formObjectName})` creates a new class instance.

If the `formObjectName` parameter is ommited, the constructor use the result of **[OBJECT Get name](https://doc.4d.com/4Dv18R6/4D/18-R6/OBJECT-Get-name.301-5198296.en.html)** ( _Object current_ )

> 📌 Omitting the object name can only be used if the constructor is called from the object method.

## Summary

> 📌 All functions that return `cs.inputDelegate` may include one call after another. 

| Function | Action |
| -------- | ------ |  
|.**highlight** ({start`:Integer`{; end`:Integer`}}) →`: cs.inputDelegate ` | Highlights:<br/>- All text if no parameters are passed<br/>- From `start` to the end of the text if the `end` parameter is omitted<br/>- From `start` to `end` if `start` & `end` are passed |
|.**highlightLastToEnd** () →`: cs.inputDelegate ` | Highlights the text from the last character entered to the end |
|.**highlighted** () →`:Object` | Returns the start & end positions of currently selected text as object: `{ start, end }` |
|.**highlightingStart** () →`:Integer` | Returns the start position of currently selected text |
|.**highlightingEnd** () →`:Integer` | Returns the end position of currently selected text |
|.**highlightingEnd** () →`:Integer` | Returns the end position of currently selected text |
|.**setFilter** ( filter`:Integer`) →`: cs.inputDelegate `<br/>.**setFilter** ( filter`:Text`) →`: cs.inputDelegate ` | Sets the entry filter for the widget. Use [4D constants](https://doc.4d.com/4Dv19/4D/19/Field-and-Variable-Types.302-5393351.en.html) (ie. _Is date_ or _Is integer_) for default predefined formats or pass the filter definition as text. |
|.**getFilter** () →`:Text` | Returns the current filter associated with the widget if any. |
