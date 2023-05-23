# buttonDelegate

The `buttonDelegate` class is intended to manage button widgets.  

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

## Constructor

The class constructor `cs.buttonDelegate.new({formObjectName})` creates a new class instance.

If the `formObjectName` parameter is ommited, the constructor use the result of **[OBJECT Get name](https://doc.4d.com/4Dv18R6/4D/18-R6/OBJECT-Get-name.301-5198296.en.html)** ( _Object current_ )

> 📌 Omitting the object name can only be used if the constructor is called from the object method.

## Summary

> 📌 All functions that return `cs.buttonDelegate` may include one call after another. 

| Function | Action |
| -------- | ------ |  
|.**highlightShortcut** () →`cs.buttonDelegate` | Tryes to underline the first capital letter or, if not found the first letter, corresponding to the associated key shortcut |
|.**setLinkedPopupMenu** () →`cs.buttonDelegate` | Associates a linked pop-up menu with the button |
|.**setSeparatePopupMenu** () →`cs.buttonDelegate` | Associates a separate pop-up menu with the button |
|.**setNoPopupMenu** () →`cs.buttonDelegate` | Removes the pop-up menu associated with the button if any |
|.**horizontalMargin** () →`Integer` | Returns the number of pixels delimiting the inside left and right margins of the button (areas that the icon and the text must not encroach upon). |
|.**horizontalMargin** (pixel`:Integer`) →`cs.buttonDelegate` | Sets the number of pixels delimiting the inside left and right margins of the button (areas that the icon and the text must not encroach upon). |
|.**is3DButton** () →`Boolean` | Returns True if the current button is a 3D button. |


