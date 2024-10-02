<!-- MARKDOWN LINKS & IMAGES -->
[release-shield]: https://img.shields.io/github/v/release/vdelachaux/4DPop-XLIFF-Pro.svg?include_prereleases
[release-url]: https://github.com/vdelachaux/4DPop-XLIFF-Pro.svg/releases/latest

[license-shield]: https://img.shields.io/github/license/vdelachaux/4DPop-XLIFF-Pro.svg

<!--BADGES-->
![Static Badge](https://img.shields.io/badge/Dev%20Component-blue?logo=4d&link=https%3A%2F%2Fdeveloper.4d.com)
![Static Badge](https://img.shields.io/badge/Project%20Dependencies-blue?logo=4d&link=https%3A%2F%2Fdeveloper.4d.com%2Fdocs%2FProject%2Fcomponents%2F%23loading-components)
<br>
[![release][release-shield]][release-url]
[![license][license-shield]](LICENSE)
<br>
<img src="https://img.shields.io/github/downloads/vdelachaux/4DPop-XLIFF-Pro/total"/>

# 4DPop XLIFF Pro

4DPop XLIFF Pro makes it clean and simple to edit XLIFF files and so localize your project.

No need to read the specification or be an XML expert, everything is done automatically for you, just stay focused on the texts you want to localize.


## Multi Languages

* Define the reference language then add as many languages as you want, files and folder are automatically created/updated.

* Manage all standards ie. Language-Regional Codes, ISO639-1 and Legacy names.
<p align="center"><img src="./assets/multilanguages.png" width="800"></p>

* When a localization isn't done, the file is updated with the source string as target string  (so **all localized files are always synchronized**).

* Automatically update the "state" attribute for the "target" string ("new", "need translation") according to the XLIFF specification, so that the created files can be edited with another XLIFF editor.

* In the editor, the not translated strings are highlighted depending the translate status (solarized light background).
<p align="center"><img src="./assets/all.png" width="800"></p>

## Duplicate resnames

* **Detecting the uniqueness of resname into a file** with auto-expanding & highlighting of duplicated items.
* The "resname" is case-sensitive, so the same resname but with a case difference is not considered duplicated.
* A "resname" is also not considered duplicated if it is loaded only on a platform.
<p align="center"><img src="./assets/duplicateResnames.png" width="800"></p>

## Notes & platform

* **Note management**

<p align="center"><img src="./assets/notes.png" width="800"></p>

* **Platform Management**. Allows you to load a different string depending on the platform.

<p align="center"><img src="./assets/platform.png" width="800"></p>

## Working language

* **Filter the working language** - Keep only at screen the reference and one localization language, all other languages continue to be synchronized.

<p align="center"><img src="./assets/fr.png" width="800"></p>

## Action menu

* Auto formatting of the resname according to the source string.
* Choosing platform.
* Set reference value to all languages.

<p align="center"><img src="./assets/actionMenu.png" width="500"></p>

## Miscellaneous

* **Automatic ID** to ensure uniqueness in the file.
* **Backup in real time**. A modification is immediatly saved and all the languages are synchronized.
* Keyboard layout & spell check according to each language.
* Import files from another project

## 4D Integration

* Drag and drop a string into the method editor to insert the loading code of the resource, or into the form editor to paste the reference.
