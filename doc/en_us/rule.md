
**Lang:** 
[![zh_CN](https://img.shields.io/badge/rule.md-简体中文-blue)](rule.md)
[![en_US](https://img.shields.io/badge/rule.md-English%20(US)-blue)](doc/en_us/rule.md)

---

# Adaptation Instructions

## Principle

The module takes effect by replacing `/data/system/cloudFeature_navigation_bar_immersive_rules_list.xml`. The rules are located in [immerse_rules.xml](/module/immerse_rules.xml), and the files within the module are modified based on the source file.

## Tutorial

The NBIRules tag contains the application list, formatted as:
`<package name="Application Package Name" enable="true" activityRule="Rule List" disableVersionCode="818"/>`  
The disableVersionCode field is optional.

The rule list format is:  
`Rule1,Rule2...`

Rule format is:  
`Activity ID:Adaptation Method`

- Specifically, `*` can be used to represent all Activities of the application.

Adaptation methods are represented by numbers, with the following rules:

- `0`: Default application style.
- `1:Color`: Navigation bar background is set to the specified color (ARGB format). The color is represented as a signed 32-bit integer (hexadecimal -> decimal -> -2^32); lowercase English words can also be used (e.g., white), but the available range is unknown and not recommended.
    - `1:0`: Transparent (0x00000000).
    - `1:-16777216`: Opaque black (0xFF000000).
    - `1:-1`: Opaque white (0xFFFFFFFF).
- `2`: Navigation bar floats and displays above the application, which may cause some occlusion.

## Recommendations

For most applications, you can quickly adapt by globally applying floating display + main interface default/color matching.

You can get [some experience](https://github.com/Ianzb/MiNavBarImmerse/discussions) for specific applications here and share your own experiences.

Due to limited author resources, uncommon software or software not used by the author will not be actively adapted. When submitting an Issue, please provide screenshots, application package name, necessary Activity adaptation information, and specific adaptation requirements; when submitting a PR, it is recommended to perform local verification in advance, fill in [list.csv](list.csv), and modify [changelog.md](changelog.md).
Some large company software may not take effect.

### Floating Display

* Recommended for Activity pages with scrollable information flows, including search, settings, maps, etc., in most software, where there are no fixed components like bottom navigation bars.
* If the software itself shares one Activity across many pages, and the UI of this Activity varies significantly across different pages, consider using this method. If you find that some pages have occluded content affecting usage, and the original effect is not so unacceptable, please abandon the adaptation.

### Color Matching

* For Activities with bottom navigation bars, you can use the background color of the bottom bar for color matching.
* Since dynamic color matching is not supported, please do not use this on interfaces that support themes/skins/light-dark modes.
* If you are only dissatisfied with the application's built-in color filling adaptation but cannot use color matching to adapt to multiple colors, maintain the default.

* A small number of applications have built-in adaptations that cannot be overridden by the module, and there is currently no solution. Some applications may exhibit bugs like turning black on certain pages; please decisively abandon adaptation in such cases.
