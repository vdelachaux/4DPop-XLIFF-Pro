# formDelegate

The `formDelegate` class is intended to handle a form.

## Properties

|Properties|Description|Type|default|Writable|
|----------|-----------|:-----------:|:-----------:|:-----------:|
|**.currentForm** | Current form name |`Text`|||
|**.darkScheme** | **True** if the actual color scheme is "dark" |`Boolean`|||
|**.entryOrder** |   |`Collection`|[ ]||
|**.focused** | The name of the object that has the focus in the form  |`Text`|**""**||
|**.frontmost** | True if the current window is the frontmost window |`Boolean`|||
|**.isSubform** | Is the form used as a subform  |`Boolean`|**False**|✅|
|**.lightScheme** | **True** if the actual color scheme is "light" |`Boolean`|||
|**.pageNumber** | The number of pages |`Integer`|||
|**.pages** | Names of the pages |`Object`|||
|**.toBeInitialized** | Has the form been initialized |`Boolean`|**True**|✅|
|**.worker** | Name  or ID of the worker associated associated to the form |`Text`\|`Integer`|**Null**|✅|
|**.window** | The form [window](windowDelegate.md) instance |`cs.windowDelegate`|||

## Constructor
The class constructor `cs.formDelegate.new({callbackMethodName})` creates a new class instance and init the `.callback` property if any.

## Widget Definitions

| Function | Action |
| -------- | ------ |  
|.**button** (name`:Text`{ widgetName`:Text`}) →`cs.buttonDelegate` | Instantiate a new [button](buttonDelegate.md) \*|
|.**comboBox** (name`:Text`{ widgetName`:Text`}) →`cs.comboBoxDelegate` | Instantiate a new [combo box](comboBoxDelegate.md) \*|
|.**dropDown** (name`:Text`{ widgetName`:Text`}) →`cs.dropDownDelegate` | Instantiate a new [drop down](dropDownDelegate.md) \*|
|.**group** (name`:Text`{ widgetName`:Text`}) →`cs.groupDelegate` | Instantiate a new [group](groupDelegate.md) \*|
|.**hList** (name`:Text`{ widgetName`:Text`}) →`cs.hListDelegate` | Instantiate a new [hierarchical list](hList.md) \*|
|.**input** (name`:Text`{ widgetName`:Text`}) →`cs.inputDelegate` | Instantiate a new [input](inputDelegate.md) \*|
|.**listbox** (name`:Text`{ widgetName`:Text`}) →`cs.listboxDelegate` | Instantiate a new [listbox](listboxDelegate.md) \*|
|.**picture** (name`:Text`{ widgetName`:Text`}) →`cs.pictureDelegate` | Instantiate a new [picture](pictureDelegate.md) \*|
|.**selector** (name`:Text`{ widgetName`:Text`}) →`cs.selectorDelegate` | Instantiate a new [selector](selectorDelegate.md) \*|
|.**static** (name`:Text`{ widgetName`:Text`}) →`cs.staticDelegate` | Instantiate a new [static element](staticDelegate.md) \*|
|.**stepper** (name`:Text`{ widgetName`:Text`}) →`cs.stepperDelegate` | Instantiate a new [stepper](stepperDelegate.md) \*|
|.**subform** (name`:Text`{ widgetName`:Text`}) →`cs.subformDelegate` | Instantiate a new [subform](subformDelegate.md) \*|
|.**thermometer** (name`:Text`{ widgetName`:Text`}) →`cs.thermometerDelegate` | Instantiate a new [thermometer](thermometerDelegate.md) \*|
|.**widget** (name`:Text`{ widgetName`:Text`}) →`cs.widgetDelegate` | Instantiate a new [widget](widgetDelegate.md) \*|

## Standard Suite

To do

## Functions
| Function | Action |
| -------- | ------ | 
|.**window** (name`:Text`{ widgetName`:Text`}) →`cs.windowDelegate` | The form [window](windowDelegate.md) instance \*|
|.**appendEvents** (events`:Integer`\|`Collection`) | Adds form event(s) for the current form|
|.**removeEvents** (events`:Integer`\|`Collection`) | Removes form event(s) for the current form|
|.**setEvents** (events`:Integer`\|`Collection`) | Define the event(s) for the current form|
|.**setEntryOrder** (widgetNames`:Collection`\) | Set the entry order of the current form|
|.**page** () →`:Integer` | Returns the number of the currently displayed form page|
|.**goToPage** (page`:Integer`) | Changes the currently displayed form page|
|.**refresh** ({delay`:Integer`}) | Start a timer to update the user interface. Default delay is ASAP|
|.**setCallBack** (methodName`:Text`) | Sets the call-back method|
|.**callMeBack** ()<br/>.**callMeBack** (param`:Collection`)<br/>.**callMeBack** (param;…; paramN) | Generates a CALL FORM of the form using the current callback method|
|.**callMe** (method`:Text`)<br/>.**callMe** (method`:Text`;param`:Collection`)<br>.**callMe** (method`:Text`;param;…; paramN) | Generates a CALL FORM of the current form with the passed method|
|.**setWorker** (worker`:Text`\|`Integer`) | Associates a worker to the form|
|.**callWorker** (method`:Text`)<br/>.**callWorker** (method`:Text`;param`:Collection`)<br>.**callWorker** (method`:Text`;param;…; paramN) | Assigns a task to the associated worker|
|.**callChild** (subform`:Object`\|`Text`; method`:Text`)<br/>.**callChild** (subform`:Object`\|`Text`; method`:Text`;param`:Collection`)<br>.**callChild** (subform`:Object`\|`Text`; method`:Text`;param;…; paramN) | Assigns a task to the associated worker|
|.**callParent** (eventCode`:Integer`) | Sends an event to the subform container|
|.**dimensions** () →`:Object`| Returns the form dimensions as an object {`width`,`height`}|
|.**height** () →`:Integer`| Returns the height of the form|
|.**width** () →`:Integer`| Returns the width of the form|
|.**firstPage** ()| changes the currently displayed form page to the first form page|
|.**lastPage** ()| changes the currently displayed form page to the last form page|
|.**nextPage** ()| changes the currently displayed form page to the next form page|
|.**previousPage** ()| changes the currently displayed form page to the previous form page|
|.**goTo** (widget`:Text`)| Gives the focus to a widget in the current form|
|.**removeFocus** ()| Removes any focus in the current form|
|.**setCursor** (cursor`:Integer`)| Changes the mouse cursor|
|.**restoreCursor** ()| Restores the standard mouse cursor|

\* If the `widgetName` parameter is omitted, it is assumed to be identical to the `name` parameter.