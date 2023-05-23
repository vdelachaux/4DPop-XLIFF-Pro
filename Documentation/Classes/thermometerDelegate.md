# thermometerDelegate

The `thermometerDelegate` class is intended to manage thermometer widgets.  

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

The class constructor `cs.thermometerDelegate.new({formObjectName})` creates a new class instance.

If the `formObjectName` parameter is ommited, the constructor use the result of **[OBJECT Get name](https://doc.4d.com/4Dv18R6/4D/18-R6/OBJECT-Get-name.301-5198296.en.html)** ( _Object current_ )

> 📌 Omitting the object name can only be used if the constructor is called from the object method.

## Summary

> 📌 All functions that return `cs.thermometerDelegate` may include one call after another. 

| Function | Action |
| -------- | ------ |  
|.**asynchronous** ()  →`cs.thermometerDelegate` | Sets the progress indicator as circular indicator displaying continuous animation |
|.**barber** ()  →`cs.thermometerDelegate` | Sets the progress indicator as bar displaying continuous animation |
|.**progress** ()  →`cs.thermometerDelegate` | Sets the progress indicator as standard progress bar |
|.**isAsynchronous** ()  →`Boolean` | Returns True if the progress indicator is asynchronous |
|.**isBarber** ()  →`Boolean` | Returns True if the progress indicator is a barber shop |
|.**isProgress** ()  →`Boolean` | Returns True if the progress indicator is a standard progress bar |
|.**getIndicatorType** ()  →`Integer` | Returns the indicator type |
|.**start** ()  →`cs.thermometerDelegate` | Starts an asynchronous progress indicator |
|.**stop** ()  →`cs.thermometerDelegate` | Stops an asynchronous  progress indicator |

> 📌 To set the value of a standard progress bar use the inherited function .**setValue**()
