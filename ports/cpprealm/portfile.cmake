# vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

# vcpkg_from_github(
#     OUT_SOURCE_PATH SOURCE_PATH
#     REPO realm/realm-cpp
#     REF "v${VERSION}"
#     SHA512 cf21ffc73be08204c16da7bf83fdd92fe801a1ee3ca32abbfd8f8deb2430817407fe971a2dfad20fdf7965f7d592e2a0835e9cb63c8db32cc763ef0d5f75150f
#     PATCHES
#         fix-config.patch
# )

set(GIT_URL "git@github.com:realm/realm-cpp.git")
set(GIT_REV "43a68815c11eb7fdd8010eef91157419d2e17b64")
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/realm-cpp)
message(STATUS "curr buildtree ${CURRENT_BUILDTREES_DIR}")

if(NOT EXISTS "${SOURCE_PATH}/.git")
    message(STATUS "Cloning")
    vcpkg_execute_required_process(
        COMMAND ${GIT} clone ${GIT_URL} 
        WORKING_DIRECTORY ${CURRENT_BUILDTREES_DIR}
        LOGNAME clone
    )

endif()


find_program(GIT git)
vcpkg_execute_required_process(
  COMMAND ${GIT} submodule update --init --recursive
  WORKING_DIRECTORY ${SOURCE_PATH}
  LOGNAME submodules
)

message(STATUS "curr buildtree ${CURRENT_BUILDTREES_DIR}")

vcpkg_cmake_configure(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS -DREALM_CPP_NO_TESTS=ON
)

vcpkg_cmake_install()


# file(GLOB HEADER_FILES "${REALMCPP_DIR}/src/cpprealm/*.hpp")
# file(INSTALL ${HEADER_FILES} DESTINATION "${CURRENT_PACKAGES_DIR}/include/cpprealm")

# file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/lib/cmake")
# file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/lib/cmake")
file(REMOVE_RECURSE
    "${CURRENT_PACKAGES_DIR}/debug/include"
    "${CURRENT_PACKAGES_DIR}/debug/share"
)

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")