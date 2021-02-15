set(VERSION 1.2.4)

vcpkg_fail_port_install(ON_TARGET "OSX" "Linux" "UWP" "ANDROID" "ARM")
vcpkg_check_linkage(ONLY_DYNAMIC_CRT)

vcpkg_download_distfile(ARCHIVE
    URLS "https://www.nuget.org/api/v2/package/Microsoft.XAudio2.Redist/${VERSION}"
    FILENAME "microsoft.xaudio2.redist.zip"
    SHA512 02ee409f6a1411e97fb7bb837d7a5e3f09af259040e4dec46bc16a1a8db89fb862f1f7fa23748164331368df3378b9a9bfd80d6f8549326628c544467cdc94b7
)

vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE ${ARCHIVE}
    NO_REMOVE_ONE_LEVEL
)

set(RELEASE_BIN_DIR "${SOURCE_PATH}/build/native/release/bin/${VCPKG_TARGET_ARCHITECTURE}")
set(RELEASE_LIB_DIR "${SOURCE_PATH}/build/native/release/lib/${VCPKG_TARGET_ARCHITECTURE}")
set(RELEASE_LIBS
   ${RELEASE_LIB_DIR}/xapobaseredist.lib
   ${RELEASE_LIB_DIR}/xapobaseredist_md.lib
   ${RELEASE_LIB_DIR}/xaudio2_9redist.lib)

set(DEBUG_BIN_DIR "${SOURCE_PATH}/build/native/release/bin/${VCPKG_TARGET_ARCHITECTURE}")
set(DEBUG_LIB_DIR "${SOURCE_PATH}/build/native/release/lib/${VCPKG_TARGET_ARCHITECTURE}")
set(DEBUG_LIBS
   ${DEBUG_LIB_DIR}/xapobaseredist.lib
   ${DEBUG_LIB_DIR}/xapobaseredist_md.lib
   ${DEBUG_LIB_DIR}/xaudio2_9redist.lib)

file(COPY "${SOURCE_PATH}/build/native/include/" DESTINATION ${CURRENT_PACKAGES_DIR}/include/${PORT})

file(COPY ${RELEASE_LIBS} DESTINATION ${CURRENT_PACKAGES_DIR}/lib)
file(COPY ${DEBUG_LIBS} DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib)

file(COPY ${RELEASE_BIN_DIR}/xaudio2_9redist.dll DESTINATION ${CURRENT_PACKAGES_DIR}/bin)
file(COPY ${DEBUG_BIN_DIR}/xaudio2_9redist.dll DESTINATION ${CURRENT_PACKAGES_DIR}/debug/bin)

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/Findxaudio2redist.cmake" DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT})
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/vcpkg-cmake-wrapper.cmake" DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT})

file(INSTALL ${SOURCE_PATH}/LICENSE.TXT DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
