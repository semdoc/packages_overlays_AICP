#!/bin/bash

my_path="$(dirname "$0")"

# Get overlay generation functions
. "$my_path"/generate_overlay.sh

dd_path="../../../external/DarkCroc-Android-theme"

if [ ! -d "$dd_path" ]; then
    echo "Cannot access $dd_path"
    exit 1
fi


# Prepare theme variants

"$dd_path/generate_type3/gen.sh" > /dev/null


# Generate themes

overlay_path="$dd_path/app/src/main/assets/overlays"
overlay_package="com.aicp.overlay.defaultdark"
overlay_package_black="com.aicp.overlay.defaultblack"
product_packages_makefile="$my_path/product_packages_dark.mk"

fix_dd() {
    basename="$1"

    if [ -d "$my_path/$basename-System" ]; then

        # Don't overlay accent, we have extra overlays for that
        remove_tag "$my_path/$basename-System/res/values/colors.xml" "color" "accent_material_light"
        remove_tag "$my_path/$basename-System/res/values/colors.xml" "color" "accent_material_dark"
        remove_tag "$my_path/$basename-System/res/values/colors.xml" "color" "accent_device_default_light"
        remove_tag "$my_path/$basename-System/res/values/colors.xml" "color" "accent_device_default_dark"
        remove_tag "$my_path/$basename-System/res/values/colors.xml" "color" "accent_device_default_700"
        remove_tag "$my_path/$basename-System/res/values/colors.xml" "color" "accent_device_default_50"
        rm "$my_path/$basename-System/res/values/type1a.xml"

    fi

    if [ -d "$my_path/$basename-Settings" ]; then

        # Remove custom homepage colors, 3rd party apps will provide own colors either way
        rm "$my_path/$basename-Settings/res/values/colors_homepage.xml"

    fi

}

# Clean previous makefile
rm -f "$product_packages_makefile"


generate_overlay "$overlay_path" "$my_path/DefaultDark-System" "android" \
                     "$overlay_package" "" "$product_packages_makefile" || exit $?

generate_overlay "$overlay_path" "$my_path/DefaultDark-SystemUI" "com.android.systemui" \
                     "$overlay_package" "SystemUI" "$product_packages_makefile" || exit $?


generate_overlay "$overlay_path" "$my_path/DefaultDark-Calculator" "com.android.calculator2" \
                     "$overlay_package" "ExactCalculator" "$product_packages_makefile" || exit $?

generate_overlay "$overlay_path" "$my_path/DefaultDark-Contacts" "com.android.contacts" \
                     "$overlay_package" "Contacts" "$product_packages_makefile" || exit $?

generate_overlay "$overlay_path" "$my_path/DefaultDark-DeskClock" "com.android.deskclock" \
                     "$overlay_package" "DeskClock" "$product_packages_makefile" || exit $?

generate_overlay "$overlay_path" "$my_path/DefaultDark-Dialer" "com.android.dialer" \
                     "$overlay_package" "Dialer" "$product_packages_makefile" || exit $?

generate_overlay "$overlay_path" "$my_path/DefaultDark-DocumentsUI" "com.android.documentsui" \
                     "$overlay_package" "DocumentsUI" "$product_packages_makefile" || exit $?

generate_overlay "$overlay_path" "$my_path/DefaultDark-Messaging" "com.android.messaging" \
                     "$overlay_package" "messaging" "$product_packages_makefile" || exit $?

generate_overlay "$overlay_path" "$my_path/DefaultDark-PackageInstaller" "com.android.packageinstaller" \
                     "$overlay_package" "PackageInstaller" "$product_packages_makefile" || exit $?

generate_overlay "$overlay_path" "$my_path/DefaultDark-Phone" "com.android.phone" \
                     "$overlay_package" "com.android.phone.common" "$product_packages_makefile" || exit $?

generate_overlay "$overlay_path" "$my_path/DefaultDark-Telecom" "com.android.server.telecom" \
                     "$overlay_package" "Telecom" "$product_packages_makefile" || exit $?

generate_overlay "$overlay_path" "$my_path/DefaultDark-SettingsIntelligence" "com.android.settings.intelligence" \
                     "$overlay_package" "SettingsIntelligence" "$product_packages_makefile" || exit $?

generate_overlay "$overlay_path" "$my_path/DefaultDark-Settings" "com.android.settings" \
                     "$overlay_package" "Settings" "$product_packages_makefile" || exit $?

fix_dd DefaultDark


generate_overlay "$overlay_path" "$my_path/DefaultBlack-System" "android" \
                     "$overlay_package_black" "" "$product_packages_makefile" \
                     1:b:More_black_backgrounds || exit $?

generate_overlay "$overlay_path" "$my_path/DefaultBlack-SystemUI" "com.android.systemui" \
                     "$overlay_package_black" "SystemUI" "$product_packages_makefile" \
                     1:a:Black_QS || exit $?

fix_dd DefaultBlack

override_package "$my_path/DefaultDark-SystemUI" "SysuiDarkThemeOverlay"


# Clean up theme variants
"$dd_path/generate_type3/clean.sh" > /dev/null