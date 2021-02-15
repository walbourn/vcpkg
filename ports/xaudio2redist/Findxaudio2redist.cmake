if(NOT WIN32)
  message(FATAL_ERROR "Findaudio2redist.cmake: Unsupported platform ${CMAKE_SYSTEM_NAME}" )
endif()

set(xaudio2redist_VERSION 1.2.4)

find_path(xaudio2redist_INCLUDE_DIR
   NAMES xaudio2redist.h
   PATH_SUFFIXES include/xaudio2redist)

find_library(xaudio2redist_LIBRARY
   NAMES xaudio2_9redist
   PATHS ${CMAKE_FIND_ROOT_PATH}/lib/
   NO_DEFAULT_PATH)

find_library(xaudio2redist_LIBRARY_DEBUG
   NAMES xaudio2_9redist
   PATHS ${CMAKE_FIND_ROOT_PATH}/debug/lib/
   NO_DEFAULT_PATH)

find_file(xaudio2redist_RUNTIME_LIBRARY
   NAMES xaudio2_9redist.dll
   PATHS ${CMAKE_FIND_ROOT_PATH}/bin/
   NO_DEFAULT_PATH)

find_file(xaudio2redist_RUNTIME_LIBRARY_DEBUG
   NAMES xaudio2_9redist.dll
   PATHS ${CMAKE_FIND_ROOT_PATH}/debug/bin/
   NO_DEFAULT_PATH)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(xaudio2redist
  FOUND_VAR xaudio2redist_FOUND
  REQUIRED_VARS
    xaudio2redist_INCLUDE_DIR
    xaudio2redist_LIBRARY
    xaudio2redist_RUNTIME_LIBRARY
  VERSION_VAR xaudio2redist_VERSION
)

if(xaudio2redist_FOUND AND NOT TARGET Microsoft::xaudio2redist)
  add_library(Microsoft::xaudio2redist SHARED IMPORTED)
  set_target_properties(Microsoft::xaudio2redist PROPERTIES
    IMPORTED_LOCATION_RELEASE "${xaudio2redist_RUNTIME_LIBRARY}"
    IMPORTED_IMPLIB_RELEASE "${xaudio2redist_LIBRARY}"
    INTERFACE_INCLUDE_DIRECTORIES "${xaudio2redist_INCLUDE_DIR}"
    IMPORTED_CONFIGURATIONS Release)
  if(EXISTS "${xaudio2redist_RUNTIME_LIBRARY_DEBUG}")
    set_property(TARGET Microsoft::xaudio2redist APPEND PROPERTY IMPORTED_CONFIGURATIONS Debug)
    set_target_properties(Microsoft::xaudio2redist PROPERTIES
      IMPORTED_LOCATION_DEBUG "${xaudio2redist_RUNTIME_LIBRARY_DEBUG}"
      IMPORTED_IMPLIB_DEBUG "${xaudio2redist_LIBRARY_DEBUG}")
  endif()
endif()
