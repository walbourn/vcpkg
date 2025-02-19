set(GDK_EDITION_NUMBER 241001)

vcpkg_download_distfile(ARCHIVE
    URLS "https://www.nuget.org/api/v2/package/Microsoft.GDK.PC/${VERSION}"
    FILENAME "ms-gdk.${VERSION}.zip"
    SHA512 47cd422fddce2594626c3c0319965a66bdd422dde79474d2ba1993feaeb9d7dadc684f7cd297d13e14fe526f06d64856f5de70b97242ba529777a3101423a3bc
)

vcpkg_extract_source_archive(
    PACKAGE_PATH
    ARCHIVE ${ARCHIVE}
    NO_REMOVE_ONE_LEVEL
)

vcpkg_cmake_configure(
    SOURCE_PATH "${PACKAGE_PATH}/native/${GDK_EDITION_NUMBER}/GRDK")

vcpkg_cmake_install()

vcpkg_cmake_config_fixup(CONFIG_PATH share/playfab.multiplayer.cpp)
vcpkg_cmake_config_fixup(CONFIG_PATH share/playfab.party.cpp)
vcpkg_cmake_config_fixup(CONFIG_PATH share/playfab.partyxboxlive.cpp)
vcpkg_cmake_config_fixup(CONFIG_PATH share/playfab.services.c)
vcpkg_cmake_config_fixup(CONFIG_PATH share/xbox.gameruntime)
vcpkg_cmake_config_fixup(CONFIG_PATH share/xbox.game.chat.2.cpp.api)
vcpkg_cmake_config_fixup(CONFIG_PATH share/xbox.libhttpclient)
vcpkg_cmake_config_fixup(CONFIG_PATH share/xbox.services.api.c)
vcpkg_cmake_config_fixup(CONFIG_PATH share/xbox.xcurl.api)

file(INSTALL "${PACKAGE_PATH}/native/bin/" DESTINATION "${CURRENT_PACKAGES_DIR}/tools")
file(INSTALL "${PACKAGE_PATH}/native/bin/GameConfigEditorDependencies" DESTINATION "${CURRENT_PACKAGES_DIR}/tools")

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

file(REMOVE
    "${CURRENT_PACKAGES_DIR}/debug/lib/Microsoft.Xbox.Services.142.GDK.C.lib"
    "${CURRENT_PACKAGES_DIR}/debug/lib/Microsoft.Xbox.Services.142.GDK.C.pdb"
    "${CURRENT_PACKAGES_DIR}/debug/lib/Microsoft.Xbox.Services.GDK.C.Thunks.lib"
    "${CURRENT_PACKAGES_DIR}/debug/lib/Microsoft.Xbox.Services.GDK.C.Thunks.pdb"
    )

file(REMOVE
    "${CURRENT_PACKAGES_DIR}/lib/Microsoft.Xbox.Services.142.GDK.C.debug.lib"
    "${CURRENT_PACKAGES_DIR}/lib/Microsoft.Xbox.Services.142.GDK.C.debug.pdb"
    "${CURRENT_PACKAGES_DIR}/lib/Microsoft.Xbox.Services.GDK.C.Thunks.debug.lib"
    "${CURRENT_PACKAGES_DIR}/lib/Microsoft.Xbox.Services.GDK.C.Thunks.debug.pdb"
    )

vcpkg_install_copyright(FILE_LIST "${PACKAGE_PATH}/LICENSE.md")
