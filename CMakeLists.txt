CMAKE_MINIMUM_REQUIRED(VERSION 2.8 FATAL_ERROR)
CMAKE_POLICY(VERSION 2.8)

SET(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake" "${CMAKE_MODULE_PATH}")

FIND_PACKAGE(Torch REQUIRED)

IF(APPLE)
  # work around for mac os x bug:
  # http://stackoverflow.com/questions/16286588/cuda-5-0-cmake-and-make-failing-on-osx-10-8-3
  if (NOT DEFINED CUDA_HOST_COMPILER AND CMAKE_C_COMPILER_ID STREQUAL "Clang" AND EXISTS /usr/bin/gcc)
    set(CUDA_HOST_COMPILER /usr/bin/gcc CACHE FILEPATH "Host side compiler used by NVCC")
    message(STATUS "Setting CMAKE_HOST_COMPILER to /usr/bin/gcc instead of ${CMAKE_C_COMPILER}.")
  endif()
ENDIF()

FIND_PACKAGE(CUDA 5.5 REQUIRED)

LIST(APPEND CUDA_NVCC_FLAGS "-arch=sm_20 -g")

INCLUDE_DIRECTORIES("${Torch_INSTALL_INCLUDE}/THC")
LINK_DIRECTORIES("${Torch_INSTALL_LIB}")

FILE(GLOB src-cuda *.cu)

FILE(GLOB luasrc *.lua)

CUDA_ADD_LIBRARY(badmm MODULE ${src-cuda})
# TARGET_LINK_LIBRARIES(badmm luaT THC TH)
IF(APPLE)
  SET_TARGET_PROPERTIES(badmm PROPERTIES
    LINK_FLAGS "-undefined dynamic_lookup")
ENDIF()

### Torch packages supposes libraries prefix is "lib"
SET_TARGET_PROPERTIES(badmm PROPERTIES
  PREFIX "lib"
  IMPORT_PREFIX "lib")

INSTALL(TARGETS badmm
  RUNTIME DESTINATION "${Torch_INSTALL_LUA_CPATH_SUBDIR}"
  LIBRARY DESTINATION "${Torch_INSTALL_LUA_CPATH_SUBDIR}")

INSTALL(
  FILES
  ${luasrc}
  DESTINATION "${Torch_INSTALL_LUA_PATH_SUBDIR}/badmm")
