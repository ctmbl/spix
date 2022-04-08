import QtQuick 2.13

Item {
    property string themeName: "ocean"
    property var theme: oceanTheme
    property string customThemeUrl

    readonly property string lightThemeName : "light"
    readonly property string oceanThemeName : "ocean"
    readonly property string darkThemeName : "dark"
    readonly property string customThemeName : "custom"

    onThemeNameChanged: {
        switch (themeName) {
        case lightThemeName:
            theme = lightTheme
            break
        case oceanThemeName:
            theme = oceanTheme
            break
        case darkThemeName:
            theme = darkTheme
            break
        case customThemeName:
            theme = customTheme
            break
        }
    }

    readonly property var lightTheme: LightTheme {}
    readonly property var oceanTheme: OceanTheme {}
    readonly property var darkTheme: DarkTheme {}
    readonly property var customTheme: CustomTheme {}

    readonly property var colorNames : [
                      "basicColor0",
                      "basicColor1",
                      "basicColor2",
                      "basicColor3",
                      "primaryColor0",
                      "primaryColor1",
                      "primaryColor2",
                      "primaryColor3",
                      "primaryColor4",
                      "primaryColor5",
                      "primaryColor6",
                      "primaryColor7",
                      "primaryColor8",
                      "primaryColor9",
                      "primaryColor10",
                      "primaryColor11",
                      "primaryColor12",
                      "primaryColor13",
                      "primaryColor14",
                      "primaryColor15",
                      "primaryColor16",
                      "primaryColor17",
                      "primaryColor18",
                      "primaryColor19",
                      "primaryColor20",
                      "primaryColor21",
                      "primaryColor22",
                      "primaryColor23",
                      "primaryColor24",
                      "primaryColor25",
                      "primaryColor26",
                      "primaryColor27",
                      "primaryColor28",
                      "primaryColor29",
                      "primaryColor30",
                      "primaryColor31",
                      "primaryColor32",
                      "primaryColor33",
                      "primaryColor34",
                      "primaryColor35",
                      "primaryColor36",
                      "primaryColor37",
                      "primaryColor38",
                      "primaryColor39",
                      "primaryColor40",
                      "primaryColor41",
                      "primaryColor42",
                      "primaryColor43",
                      "primaryColor44",
                      "primaryColor45",
                      "accentColor0",
                      "accentColor1",
                      "accentColor2",
                      "accentColor4"  ]

    Loader {
        id: customThemeLoader
        source : customThemeUrl
        onLoaded: {
            // copy all data in customTheme to ensure properties are not readonly and we can use the palette editor
            for (var i = 0; i < colorNames.length; ++i) {
                customTheme[colorNames[i]] = customThemeLoader.item[colorNames[i]]
            }
            themeName = customThemeName
        }
    }
}
