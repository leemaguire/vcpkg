set(GIT_URL "git@github.com:realm/realm-cpp.git")
set(GIT_REV "05b48476dfd0a37d6d6f44ff81711be22699ccf1")
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/realm-cpp)
find_program(GIT git)

if(NOT EXISTS "${SOURCE_PATH}/.git")
    vcpkg_execute_required_process(
        COMMAND ${GIT} clone ${GIT_URL} 
        WORKING_DIRECTORY ${CURRENT_BUILDTREES_DIR}
        LOGNAME clone
    )

endif()

vcpkg_execute_required_process(
  COMMAND ${GIT} checkout lm/vcpkg
  WORKING_DIRECTORY ${SOURCE_PATH}
  LOGNAME checkout
)

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

vcpkg_cmake_install()

message(${VCPKG_LIBRARY_LINKAGE})

vcpkg_cmake_config_fixup(PACKAGE_NAME "cpprealm" CONFIG_PATH "cmake")

file(REMOVE_RECURSE 
    "${CURRENT_PACKAGES_DIR}/debug/include"
    "${CURRENT_PACKAGES_DIR}/debug/share"
)

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
