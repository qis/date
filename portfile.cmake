if(VCPKG_TARGET_IS_WINDOWS)
  message(WARNING
    "You will need to also install https://raw.githubusercontent.com/unicode-org/cldr/master/common/supplemental/windowsZones.xml into your install location.\n"
    "See https://howardhinnant.github.io/date/tz.html"
  )
endif()

vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO HowardHinnant/date
  REF 6e921e1b1d21e84a5c82416ba7ecd98e33a436d0 # 3.0.1
  SHA512 e2d29d1e3f18c2374c2c746fa796cc9b3f0d0cb79ee2cfc4462dd26262d58ca1a66167fe9f162789dee4d37d41074d16bbdbe247c8f1f5a22057f5d7f6522d3a
  HEAD_REF master
  PATCHES
    0001-fix-uwp.patch
    0002-fix-cmake-3.14.patch
)
vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    INVERTED_FEATURES
    remote-api USE_SYSTEM_TZ_DB
)

vcpkg_configure_cmake(
  SOURCE_PATH ${SOURCE_PATH}
  PREFER_NINJA
  OPTIONS
     ${FEATURE_OPTIONS}
    -DBUILD_TZ_LIB=ON
)

vcpkg_install_cmake()

if(VCPKG_TARGET_IS_WINDOWS)
  vcpkg_fixup_cmake_targets(CONFIG_PATH CMake TARGET_PATH share/date)
else()
  vcpkg_fixup_cmake_targets(CONFIG_PATH lib/cmake/date TARGET_PATH share/date)
endif()

vcpkg_copy_pdbs()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

file(INSTALL ${SOURCE_PATH}/LICENSE.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/date RENAME copyright)
