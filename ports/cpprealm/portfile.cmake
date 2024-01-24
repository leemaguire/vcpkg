vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO realm/realm-cpp
    REF "v${VERSION}"
    SHA512 cf21ffc73be08204c16da7bf83fdd92fe801a1ee3ca32abbfd8f8deb2430817407fe971a2dfad20fdf7965f7d592e2a0835e9cb63c8db32cc763ef0d5f75150f
    PATCHES
        fix-config.patch
)

set(REALMCPP_DIR ${SOURCE_PATH})

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO catchorg/Catch2
    REF "v3.4.0"
    SHA512 3b452378201ac53c9ffba7801231aa3b32c5fb496f01d670fcee25baf95f405e565ae2aafba49ea5694f906fc61a8b04592c68b9fb12839767070587a48c89fa
)
set(CATCH2_DIR ${SOURCE_PATH})

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO realm/realm-core
    REF "v13.25.1"
    SHA512 35a0b3b68abbd3fa42b7ead76b39bafef7472d831af20714115b1b09ece4398b176e12679a4b8b95f0d823048aff263d441405efdcd841b24efeb1ccd7a2fd71
)
set(REALMCORE_DIR ${SOURCE_PATH})

file(COPY ${CATCH2_DIR}/ DESTINATION ${REALMCORE_DIR}/external/catch)
file(COPY ${REALMCORE_DIR}/ DESTINATION ${REALMCPP_DIR}/realm-core)

vcpkg_cmake_configure(
    SOURCE_PATH ${REALMCPP_DIR}
)

vcpkg_cmake_install()
vcpkg_copy_pdbs()
vcpkg_fixup_pkgconfig()

# file(GLOB HEADER_FILES "${REALMCPP_DIR}/src/cpprealm/*.hpp")
# file(INSTALL ${HEADER_FILES} DESTINATION "${CURRENT_PACKAGES_DIR}/include/cpprealm")

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/lib/cmake")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/lib/cmake")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")

file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
configure_file("${CMAKE_CURRENT_LIST_DIR}/usage" "${CURRENT_PACKAGES_DIR}/share/${PORT}/usage" COPYONLY)