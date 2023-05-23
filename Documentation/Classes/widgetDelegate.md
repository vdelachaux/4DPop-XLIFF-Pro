# widgetDelegate

The `widgetDelegate` class is intended to manipulate active form objects.  
It's a transition class between the **`staticDelegate`** class and more specific classes like `input`, `button`, `listbox`…

> #### 📌 This class inherit from the [`staticDelegate`](staticDelegate.md) class

## Properties

|Properties|Description|Type||
|----------|-----------|:--:|-------|
|**.name** | [*inherited*](staticDelegate.md) |
|**.type** | [*inherited*](staticDelegate.md) |
|**.coordinates** | [*inherited*](staticDelegate.md) |
|**.dimensions** | [*inherited*](staticDelegate.md) |
|**.windowCoordinates** | [*inherited*](staticDelegate.md) |
|**.action** | The name & , if any, parameter of the standard action associated with the object | `Text` | cf. [Standard actions](https://doc.4d.com/4Dv18R6/4D/18-R6/Standard-actions.300-5217689.en.html)|
|**.assignable** | Is the object accessible by a pointer | `Boolean` | **True** or **False** it depends |
|**.pointer** | The pointer, if any, to the widget | `Pointer` | **Nil** if not assignable |
|**.value** | The value of the datasource, if any | `Variant` |  |

## Constructor

The class constructor `cs.widgetDelegate.new({formObjectName})` creates a new class instance.

If the `formObjectName` parameter is ommited, the constructor use the result of **[OBJECT Get name](https://doc.4d.com/4Dv18R6/4D/18-R6/OBJECT-Get-name.301-5198296.en.html)** ( _Object current_ )

> 📌 Omitting the object name can only be used if the constructor is called from the object method.

## Summary

> 📌 All functions that return `cs.widgetDelegate` may include one call after another. 

| Function | Action |
| -------- | ------ |  
|.**updatePointer** () →`Pointer` | Update of the widget pointer. Useful when reloading the form |
|.**pointer** () →`Pointer` | Returns the pointer to the widget |
|.**setFormat** (format`:Text`) →`cs.widgetDelegate` | Sets the format for the widget |
|.**setPicture** (proxy`:Text`) →`cs.widgetDelegate` | Attaches an image to the widget - *cf*. *infra* |
|.**getEnterable** () →`Boolean` | Returns **True** if the widget is enterable |
|.**enterable** ({`Boolean`}) →`cs.widgetDelegate` | Makes the widget enterable (or not if Boolean is false) |
|.**notEnterable** () →`cs.widgetDelegate` | Makes the widget not enterable |
|.**draggable** ({enabled`:Boolean`{; automatic`:Boolean`}}) →`cs.widgetDelegate` | Sets the drag options for the widget <br/> Default: draggable and not automatic|
|.**notDraggable** () →`cs.widgetDelegate` | Disables the draggable option of the widget|
|.**droppable** ({accept`:Boolean`{; automatic`:Boolean`}}) →`cs.widgetDelegate` | Sets the drop options for the widget <br/> Default: accept drop and not automatic|
|.**notDroppable** () →`cs.widgetDelegate` | Disables the droppable option of the widget|
|.**getValue** () →`Variant` | Returns the current value of the data source for the widget|
|.**setValue** ( value`:Variant`) →`cs.widgetDelegate` | Sets the value of the current data source for the widget|
|.**clear** () →`cs.widgetDelegate` | Sets empty value to the datasource according to its type |
|.**touch** () →`cs.widgetDelegate` | Forces the update of the widget by reassigning the same value to the data source. |
|.**setCallback** (formula`:4D.Function`) →`cs.widgetDelegate` | Sets a formula associated with the widget. *cf*. **catch**() & **execute**() |
|.**catch** ({formEvent`:Object`{; event`:Integer`}}) →`Boolean`<br/>.**catch** ({formEvent`:Object`{; events`:Collection`}}) →`Boolean`| Returns **True** if the widget is causing the form event and executes the `callback` formula if it exists. <br/>Pass an event code or collection of event codes to restrict the response to these events. |
|.**execute** () | Executes the `callback` formula associated to the widget |
|.**getHelpTip** () →`Text` | Returns the help message associated with the widget|
|.**setHelpTip** ({`Text`}) →`cs.widgetDelegate` | Sets the help tip associated with the widget.  If no parameter , the help tip will be removed. |
|.**removeHelpTip** () →`cs.widgetDelegate` | Removes the help tip associated with the widget. |
|.**getShortcut** () →`Object` | Returns the keyboard shortcut associated with the widget as an object{"key", "modifier"}|
|.**setShortcut** ( key`:Text`{; modifier`:Integer`}) →`cs.widgetDelegate` | Sets the keyboard shortcut associated with the widget|
|.**focus** () →`cs.widgetDelegate` | Gives focus to the widget |
|.**addEvent** ( event`:Integer`) →`cs.widgetDelegate`<br/>.**addEvent** ( events`:Collection`) →`cs.widgetDelegate` | Adds one or more  form events to the widget |
|.**removeEvent** ( event`:Integer`) →`cs.widgetDelegate`<br/>.**removeEvent** ( events`:Collection`) →`cs.widgetDelegate` | Removes one or more  form events to the widget |



## 🔹 .setPicture()
.**setPicture** ({ proxy`:Text`} ) →`cs.widgetDelegate`

This function is intended to set the image of the compatible `3D button`, `3D checkbox`, `3D radio button`, `picture button`, `picture popup menu`, `listbox header` or `static picture`.

Possible values for the `proxy` parameter are:

* The string `#{folder/}picturename` or `file:{folder/}picturename` if the picture comes from a file stored in the `Resources` folder
* A variable name if the picture comes from a `picture variable`
* ~~A number, preceded with a question mark (ex.: “?250”) if the picture comes from a `picture library`~~

If the `proxy` parameter is omitted, the picture is removed
