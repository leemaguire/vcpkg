set(GIT_URL "git@github.com:realm/realm-cpp.git")
set(GIT_REV "43a68815c11eb7fdd8010eef91157419d2e17b64")
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/realm-cpp)

if(NOT EXISTS "${SOURCE_PATH}/.git")
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

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DREALM_CPP_NO_TESTS=ON
)

# file(GLOB HEADER_FILES "${REALMCPP_DIR}/src/cpprealm/*.hpp")
# file(INSTALL ${HEADER_FILES} DESTINATION "${CURRENT_PACKAGES_DIR}/include/cpprealm")


vcpkg_cmake_install()
vcpkg_fixup_pkgconfig()

vcpkg_cmake_config_fixup(CONFIG_PATH cmake)


file(REMOVE_RECURSE 
    "${CURRENT_PACKAGES_DIR}/debug/include"
    "${CURRENT_PACKAGES_DIR}/debug/share"
)

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
