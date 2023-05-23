# staticDelegate

The `cs.staticDelegate` class is the parent class of all form objects classes<img src="./staticDelegate/static.png">

> 📌 The `group` class can also refer to this class even if it's not inheritance
	
## Properties

|Properties|Description|Type||
|----------|-----------|:--:|-------|
|**.name** | The name of the form object| `Text`
|**.type** | The type of the form object| `Integer` | Use the [Form object Types](https://doc.4d.com/4Dv18R6/4D/18-R6/Form-Object-Types.302-5199153.en.html) constant theme
|**.coordinates** | The coordinates of the form object in the form| `Object` |{`left`,`top`,`right`,`bottom`}|
|**.dimensions** | The dimensions of the form object| `Object` |{`width`,`height`}|
|**.windowCoordinates** | The coordinates of the form object in the current window| `Object` |{`left`,`top`,`right`,`bottom`}|

## 🔸 cs.staticDelegate.new()

The class constructor `cs.staticDelegate.new({formObjectName})` creates a new class instance.

If the `formObjectName` parameter is ommited, the constructor use the result of **[OBJECT Get name](https://doc.4d.com/4Dv19/4D/19/OBJECT-Get-name.301-5392401.en.html)** (_Object current_ )
> 📌 Omitting the object name can only be used if the constructor is called from the object method.

## Summary

> 📌 All functions that return `cs.staticDelegate` may include one call after another. 

| Function | Action |
| -------- | ------ |  
|.**show** ({state`:Boolean`}) →`cs.staticDelegate` | To make the object visible (no parameter) or invisible (`state` = **False**) | 
|.**hide** () →`cs.staticDelegate` | To hide the object |
|.**enable** ({state`:Boolean`}) →`cs.staticDelegate` | To enable (no parameter) or disable (`state` = **False**) the object |
|.**disable** () →`cs.staticDelegate` | To disable the object |
|.**setCoordinates** (left`:Integer `; top`:Integer`; {right`:Integer`; bottom`:Integer`}}) →`cs.staticDelegate` | To modifies the coordinates and, optionally, the size of the object \* |
|.**setCoordinates** (coordinates`:Object`) →`cs.staticDelegate` | "left", "top"{, "right", "bottom"}\*|
|.**getCoordinates** () →`Object` | Returns the updated coordinates object\* |
|.**bestSize** (alignement`:Integer`{ ; minWidth`:Integer`{ ; maxWidth`:Integer`}}) →`cs.staticDelegate` | Set the size of the object to its best size according to its content (e.g. a localized string) \* |
|.**bestSize** ({options`:Object`}) →`cs.staticDelegate` |{"alignement"}{, "minWidth"}{, "maxWidth"}\*  |
|.**moveHorizontally** (offset`:Integer`) →`cs.staticDelegate` | To move the object horizontally \*  |
|.**moveVertically** (offset`:Integer`) →`cs.staticDelegate` | To move the object vertically \*  |
|.**resizeHorizontally** (offset`:Integer`) →`cs.staticDelegate` | To resize the object horizontally \*  |
|.**resizeVertically** (offset`:Integer`) →`cs.staticDelegate` | To resize the object vertically \*  |
|.**moveAndResizeHorizontally** (offset`:Integer`;resize`:Integer`) →`cs.staticDelegate` | To move and resize the object horizontally \*  |
|.**moveAndResizeVertically** (offset`:Integer`;resize`:Integer`) →`cs.staticDelegate` | To move and resize the object vertically \*  |
|.**setDimension** (width`:Integer` ;{ height`:Integer`}) →`cs.staticDelegate` | To modify the object width & height \*  |
|.**setHeight** (height`:Integer`) →`cs.staticDelegate` | To modify the object height \*  |
|.**setWidth** (width`:Integer` ) →`cs.staticDelegate` | To modify the object width \*  |
|.**setTitle** (title`:Text`) →`cs.staticDelegate` | To change the title of the object (if the title is a `resname`, the localization is performed) \** |
|.**title** () →`Text` | Returns the title of the object \** |
|.**setFont** (fontName`:Text`}) →`cs.staticDelegate` | To set the font|
|.**setFontStyle** ({style`:Integer`}) →`cs.staticDelegate` | To set the style of the title (use the 4D constants _Bold_, _Italic_, _Plain_, _Underline_) Default = _Plain_ \** |
|.**setColors** (foreground{; background{; altBackground }}) →`cs.staticDelegate` | To set the object color(s)  |
|.**getForegroundColor** () →`Text` | To get the foreground color of the object |
|.**isVisible** () →`Boolean` | Returns **True** if the object is visible and **False** otherwise |
|.**isHidden** () →`Boolean` | Returns **False** if the object is not visible and **False** otherwise |
|.**isEnabled** () →`Boolean` | Returns **True** if the object is enabled and **False** otherwise |
|.**updateCoordinates** (left`:Integer`; top`:Integer`; right`:Integer`; bottom`:Integer`)   →`cs.staticDelegate` | To update `coordinates`, `dimensions` and `windowCoordinates` properties |
|.**addToGroup** (group : cs.groupDelegate) →`cs.staticDelegate` | Adds the current widget to a [**`group`**](groupDelegate.md) |
    
\* Automatically update the `coordinates`, `dimensions` and `windowCoordinates` properties.    
\** Can be applied to a static text and will be avalaible for the inherited classes (buttons, check boxes, radio buttons, …)
