# material_widgets

An Flutter package implementing various Material Design 3 components and layout patterns. It uses my [material_you](https://github.com/KalilDev/material_you), [flutter_monet_theme](https://github.com/KalilDev/material_theme_reverse/tree/master/dart/flutter_monet_theme), [monet_theme](https://github.com/KalilDev/material_theme_reverse/tree/master/dart/monet_theme) and [palette_from_wallpaper](https://github.com/KalilDev/palette_from_wallpaper) packages in order to implement the MD3 theming, and builds on top of them to implement the MD3 components.

## Gallery

The Material Design 3 Gallery contains every component from this package and is available through an release APK on the [Releases page](https://github.com/KalilDev/material_widgets/releases), or through the web [Here](https://kalildev.github.io/material_widgets/).

### Screenshots

![Light](assets/gallery.png)
![Dark](assets/gallery_dark.png)

## Styling

### Typography

An fully device-type aware implementation of the [Material Design 3](https://m3.material.io/) [Typography](https://m3.material.io/styles/typography/overview)

#### Images
![Phone](assets/typography/phone.png)
![Tablet](assets/typography/tablet.png)
![Desktop](assets/typography/desktop.png)

### Color system

An fully fledged implementation of the [Material Design 3](https://m3.material.io/) [Color System](https://m3.material.io/styles/color/the-color-system/key-colors-tones). It supports an baseline theme, wallpaper-based seeded themes, themes from custom seeds, and custom harmonized colors

#### Images
![Tones](assets/color/tones.png)
![Schemes](assets/color/schemes.png)
![Schemes (dark)](assets/color/schemes_dark.png)

### Elevation

An fully fledged implementation of the [Material Design 3](https://m3.material.io/) Elevation, with 5 different levels, each with an different shadow and surface tint.

#### Images
![Level 0](assets/elevation/level0.png)
![Level 1](assets/elevation/level1.png)
![Level 2](assets/elevation/level2.png)
![Level 3](assets/elevation/level3.png)
![Level 4](assets/elevation/level4.png)

## Components:

### Cards

Some components which follow the [Material Design 3](https://m3.material.io/) spec
for the [Cards](https://m3.material.io/components/cards), and an extra ColoredCard.

#### Images
![Light](assets/cards.png)
![Dark](assets/cards_dark.png)

### Chips

Some components which follow the [Material Design 3](https://m3.material.io/) spec
for the [Chips](https://m3.material.io/components/chips/overview).

#### Images
![Light](assets/chips.png)
![Dark](assets/chips_dark.png)

### Common Buttons

An style for Elevated, Text and Outlined buttons, and Filled and FiledTonal buttons which follow the [Material Design 3](https://m3.material.io/) spec
for the [Common Buttons](https://m3.material.io/components/buttons/overview).

#### Images
![Light](assets/buttons.png)
![Dark](assets/buttons_dark.png)


### Dialogs

Basic and fullscreen dialogs and animations which follow the [Material Design 3](https://m3.material.io/) spec
for the [Dialogs](https://m3.material.io/components/dialogs/overview).

#### Images
![Basic light](assets/dialogs/basic.png)
![Basic dark](assets/dialogs/basic_dark.png)
![Basic light (icon)](assets/dialogs/basic_icon.png)
![Basic dark (icon)](assets/dialogs/basic_icon_dark.png)
![Full screen light](assets/dialogs/full_screen.png)
![Full screen dark](assets/dialogs/full_screen_dark.png)

### Appbars

Various appbars and an sliver appbar which follow the [Material Design 3](https://m3.material.io/) spec
for the [Top app bar](https://m3.material.io/components/top-app-bar/overview).

#### Images
![Light](assets/appbar.png)
![Dark](assets/appbar_dark.png)

### Switch

An guesstimate of what the [Material Design 3](https://m3.material.io/) switch component will look like (Based of the measures and eyeballing from the Google Clock app).

#### Images
![Light](assets/switch.png)
![Dark](assets/switch_dark.png)

### Slider

An guesstimate of what the [Material Design 3](https://m3.material.io/) slider component will look like (Based of the eyeballing of the Material You advertising videos).

#### Images
![Light](assets/slider.png)
![Dark](assets/slider_dark.png)

### MD3FloatingActionButton

An component which follows the [Material Design 3](https://m3.material.io/) spec
for the [FAB](https://m3.material.io/components/floating-action-button) and
[Extended FAB](https://m3.material.io/components/extended-fab) components.

#### Images
##### Regular
| Color Scheme     |                             Regular (light)                              |                                      Lowered (light)                                       |                                Regular (dark)                                 |                                         Lowered (dark)                                          |
| :--------------- | :----------------------------------------------------------------------: | :----------------------------------------------------------------------------------------: | :---------------------------------------------------------------------------: | :---------------------------------------------------------------------------------------------: |
| primaryContainer | ![Regular - Primary_Container](assets/fab/Regular_Primary_Container.png) | ![Regular - Primary_Container - Lowered](assets/fab/Regular_Primary_Container_Lowered.png) | ![Regular - Primary_Container](assets/fab/Dark_Regular_Primary_Container.png) | ![Regular - Primary_Container - Lowered](assets/fab/Dark_Regular_Primary_Container_Lowered.png) |
| surface          |           ![Regular - Surface](assets/fab/Regular_Surface.png)           |           ![Regular - Surface - Lowered](assets/fab/Regular_Surface_Lowered.png)           |           ![Regular - Surface](assets/fab/Dark_Regular_Surface.png)           |           ![Regular - Surface - Lowered](assets/fab/Dark_Regular_Surface_Lowered.png)           |
| secondary        |         ![Regular - Secondary](assets/fab/Regular_Secondary.png)         |         ![Regular - Secondary - Lowered](assets/fab/Regular_Secondary_Lowered.png)         |         ![Regular - Secondary](assets/fab/Dark_Regular_Secondary.png)         |         ![Regular - Secondary - Lowered](assets/fab/Dark_Regular_Secondary_Lowered.png)         |
| tertiary         |          ![Regular - Tertiary](assets/fab/Regular_Tertiary.png)          |          ![Regular - Tertiary - Lowered](assets/fab/Regular_Tertiary_Lowered.png)          |          ![Regular - Tertiary](assets/fab/Dark_Regular_Tertiary.png)          |          ![Regular - Tertiary - Lowered](assets/fab/Dark_Regular_Tertiary_Lowered.png)          |

##### Small
| Color Scheme     |                           Regular (light)                            |                                    Lowered (light)                                     |                              Regular (dark)                               |                                       Lowered (dark)                                        |
| :--------------- | :------------------------------------------------------------------: | :------------------------------------------------------------------------------------: | :-----------------------------------------------------------------------: | :-----------------------------------------------------------------------------------------: |
| primaryContainer | ![Small - Primary_Container](assets/fab/Small_Primary_Container.png) | ![Small - Primary_Container - Lowered](assets/fab/Small_Primary_Container_Lowered.png) | ![Small - Primary_Container](assets/fab/Dark_Small_Primary_Container.png) | ![Small - Primary_Container - Lowered](assets/fab/Dark_Small_Primary_Container_Lowered.png) |
| surface          |           ![Small - Surface](assets/fab/Small_Surface.png)           |           ![Small - Surface - Lowered](assets/fab/Small_Surface_Lowered.png)           |           ![Small - Surface](assets/fab/Dark_Small_Surface.png)           |           ![Small - Surface - Lowered](assets/fab/Dark_Small_Surface_Lowered.png)           |
| secondary        |         ![Small - Secondary](assets/fab/Small_Secondary.png)         |         ![Small - Secondary - Lowered](assets/fab/Small_Secondary_Lowered.png)         |         ![Small - Secondary](assets/fab/Dark_Small_Secondary.png)         |         ![Small - Secondary - Lowered](assets/fab/Dark_Small_Secondary_Lowered.png)         |
| tertiary         |          ![Small - Tertiary](assets/fab/Small_Tertiary.png)          |          ![Small - Tertiary - Lowered](assets/fab/Small_Tertiary_Lowered.png)          |          ![Small - Tertiary](assets/fab/Dark_Small_Tertiary.png)          |          ![Small - Tertiary - Lowered](assets/fab/Dark_Small_Tertiary_Lowered.png)          |

##### Large
| Color Scheme     |                           Regular (light)                            |                                    Lowered (light)                                     |                              Regular (dark)                               |                                       Lowered (dark)                                        |
| :--------------- | :------------------------------------------------------------------: | :------------------------------------------------------------------------------------: | :-----------------------------------------------------------------------: | :-----------------------------------------------------------------------------------------: |
| primaryContainer | ![Large - Primary_Container](assets/fab/Large_Primary_Container.png) | ![Large - Primary_Container - Lowered](assets/fab/Large_Primary_Container_Lowered.png) | ![Large - Primary_Container](assets/fab/Dark_Large_Primary_Container.png) | ![Large - Primary_Container - Lowered](assets/fab/Dark_Large_Primary_Container_Lowered.png) |
| surface          |           ![Large - Surface](assets/fab/Large_Surface.png)           |           ![Large - Surface - Lowered](assets/fab/Large_Surface_Lowered.png)           |           ![Large - Surface](assets/fab/Dark_Large_Surface.png)           |           ![Large - Surface - Lowered](assets/fab/Dark_Large_Surface_Lowered.png)           |
| secondary        |         ![Large - Secondary](assets/fab/Large_Secondary.png)         |         ![Large - Secondary - Lowered](assets/fab/Large_Secondary_Lowered.png)         |         ![Large - Secondary](assets/fab/Dark_Large_Secondary.png)         |         ![Large - Secondary - Lowered](assets/fab/Dark_Large_Secondary_Lowered.png)         |
| tertiary         |          ![Large - Tertiary](assets/fab/Large_Tertiary.png)          |          ![Large - Tertiary - Lowered](assets/fab/Large_Tertiary_Lowered.png)          |          ![Large - Tertiary](assets/fab/Dark_Large_Tertiary.png)          |          ![Large - Tertiary - Lowered](assets/fab/Dark_Large_Tertiary_Lowered.png)          |

##### Expanded
| Color Scheme     |                                      Regular (light)                                       |                                               Lowered (light)                                                |                                         Regular (dark)                                          |                                                  Lowered (dark)                                                   |
| :--------------- | :----------------------------------------------------------------------------------------: | :----------------------------------------------------------------------------------------------------------: | :---------------------------------------------------------------------------------------------: | :---------------------------------------------------------------------------------------------------------------: |
| primaryContainer | ![Expanded (Shown) - Primary_Container](assets/fab/Expanded_(Shown)_Primary_Container.png) | ![Expanded (Shown) - Primary_Container - Lowered](assets/fab/Expanded_(Shown)_Primary_Container_Lowered.png) | ![Expanded (Shown) - Primary_Container](assets/fab/Dark_Expanded_(Shown)_Primary_Container.png) | ![Expanded (Shown) - Primary_Container - Lowered](assets/fab/Dark_Expanded_(Shown)_Primary_Container_Lowered.png) |
| surface          |           ![Expanded (Shown) - Surface](assets/fab/Expanded_(Shown)_Surface.png)           |           ![Expanded (Shown) - Surface - Lowered](assets/fab/Expanded_(Shown)_Surface_Lowered.png)           |           ![Expanded (Shown) - Surface](assets/fab/Dark_Expanded_(Shown)_Surface.png)           |           ![Expanded (Shown) - Surface - Lowered](assets/fab/Dark_Expanded_(Shown)_Surface_Lowered.png)           |
| secondary        |         ![Expanded (Shown) - Secondary](assets/fab/Expanded_(Shown)_Secondary.png)         |         ![Expanded (Shown) - Secondary - Lowered](assets/fab/Expanded_(Shown)_Secondary_Lowered.png)         |         ![Expanded (Shown) - Secondary](assets/fab/Dark_Expanded_(Shown)_Secondary.png)         |         ![Expanded (Shown) - Secondary - Lowered](assets/fab/Dark_Expanded_(Shown)_Secondary_Lowered.png)         |
| tertiary         |          ![Expanded (Shown) - Tertiary](assets/fab/Expanded_(Shown)_Tertiary.png)          |          ![Expanded (Shown) - Tertiary - Lowered](assets/fab/Expanded_(Shown)_Tertiary_Lowered.png)          |          ![Expanded (Shown) - Tertiary](assets/fab/Dark_Expanded_(Shown)_Tertiary.png)          |          ![Expanded (Shown) - Tertiary - Lowered](assets/fab/Dark_Expanded_(Shown)_Tertiary_Lowered.png)          |

##### Expanded (No icon)
| Color Scheme     |                                        Regular (light)                                         |                                                 Lowered (light)                                                  |                                           Regular (dark)                                            |                                                    Lowered (dark)                                                     |
| :--------------- | :--------------------------------------------------------------------------------------------: | :--------------------------------------------------------------------------------------------------------------: | :-------------------------------------------------------------------------------------------------: | :-------------------------------------------------------------------------------------------------------------------: |
| primaryContainer | ![Expanded (No icon) - Primary_Container](assets/fab/Expanded_(No_icon)_Primary_Container.png) | ![Expanded (No icon) - Primary_Container - Lowered](assets/fab/Expanded_(No_icon)_Primary_Container_Lowered.png) | ![Expanded (No icon) - Primary_Container](assets/fab/Dark_Expanded_(No_icon)_Primary_Container.png) | ![Expanded (No icon) - Primary_Container - Lowered](assets/fab/Dark_Expanded_(No_icon)_Primary_Container_Lowered.png) |
| surface          |           ![Expanded (No icon) - Surface](assets/fab/Expanded_(No_icon)_Surface.png)           |           ![Expanded (No icon) - Surface - Lowered](assets/fab/Expanded_(No_icon)_Surface_Lowered.png)           |           ![Expanded (No icon) - Surface](assets/fab/Dark_Expanded_(No_icon)_Surface.png)           |           ![Expanded (No icon) - Surface - Lowered](assets/fab/Dark_Expanded_(No_icon)_Surface_Lowered.png)           |
| secondary        |         ![Expanded (No icon) - Secondary](assets/fab/Expanded_(No_icon)_Secondary.png)         |         ![Expanded (No icon) - Secondary - Lowered](assets/fab/Expanded_(No_icon)_Secondary_Lowered.png)         |         ![Expanded (No icon) - Secondary](assets/fab/Dark_Expanded_(No_icon)_Secondary.png)         |         ![Expanded (No icon) - Secondary - Lowered](assets/fab/Dark_Expanded_(No_icon)_Secondary_Lowered.png)         |
| tertiary         |          ![Expanded (No icon) - Tertiary](assets/fab/Expanded_(No_icon)_Tertiary.png)          |          ![Expanded (No icon) - Tertiary - Lowered](assets/fab/Expanded_(No_icon)_Tertiary_Lowered.png)          |          ![Expanded (No icon) - Tertiary](assets/fab/Dark_Expanded_(No_icon)_Tertiary.png)          |          ![Expanded (No icon) - Tertiary - Lowered](assets/fab/Dark_Expanded_(No_icon)_Tertiary_Lowered.png)          |

##### Expanded (Closed)
| Color Scheme     |                                       Regular (light)                                        |                                                Lowered (light)                                                 |                                          Regular (dark)                                           |                                                   Lowered (dark)                                                    |
| :--------------- | :------------------------------------------------------------------------------------------: | :------------------------------------------------------------------------------------------------------------: | :-----------------------------------------------------------------------------------------------: | :-----------------------------------------------------------------------------------------------------------------: |
| primaryContainer | ![Expanded (Hidden) - Primary_Container](assets/fab/Expanded_(Hidden)_Primary_Container.png) | ![Expanded (Hidden) - Primary_Container - Lowered](assets/fab/Expanded_(Hidden)_Primary_Container_Lowered.png) | ![Expanded (Hidden) - Primary_Container](assets/fab/Dark_Expanded_(Hidden)_Primary_Container.png) | ![Expanded (Hidden) - Primary_Container - Lowered](assets/fab/Dark_Expanded_(Hidden)_Primary_Container_Lowered.png) |
| surface          |           ![Expanded (Hidden) - Surface](assets/fab/Expanded_(Hidden)_Surface.png)           |           ![Expanded (Hidden) - Surface - Lowered](assets/fab/Expanded_(Hidden)_Surface_Lowered.png)           |           ![Expanded (Hidden) - Surface](assets/fab/Dark_Expanded_(Hidden)_Surface.png)           |           ![Expanded (Hidden) - Surface - Lowered](assets/fab/Dark_Expanded_(Hidden)_Surface_Lowered.png)           |
| secondary        |         ![Expanded (Hidden) - Secondary](assets/fab/Expanded_(Hidden)_Secondary.png)         |         ![Expanded (Hidden) - Secondary - Lowered](assets/fab/Expanded_(Hidden)_Secondary_Lowered.png)         |         ![Expanded (Hidden) - Secondary](assets/fab/Dark_Expanded_(Hidden)_Secondary.png)         |         ![Expanded (Hidden) - Secondary - Lowered](assets/fab/Dark_Expanded_(Hidden)_Secondary_Lowered.png)         |
| tertiary         |          ![Expanded (Hidden) - Tertiary](assets/fab/Expanded_(Hidden)_Tertiary.png)          |          ![Expanded (Hidden) - Tertiary - Lowered](assets/fab/Expanded_(Hidden)_Tertiary_Lowered.png)          |          ![Expanded (Hidden) - Tertiary](assets/fab/Dark_Expanded_(Hidden)_Tertiary.png)          |          ![Expanded (Hidden) - Tertiary - Lowered](assets/fab/Dark_Expanded_(Hidden)_Tertiary_Lowered.png)          |

## Getting Started

This project is a starting point for a Dart
[package](https://flutter.dev/developing-packages/),
a library module containing code that can be shared easily across
multiple Flutter or Dart projects.

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
