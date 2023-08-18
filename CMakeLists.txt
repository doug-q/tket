cmake_minimum_required(VERSION 3.26.0)

project(tket-umbrella CXX)

include(FetchContent)

set(LINK_OPTIONS -fuse-ld=lld)
set(CMAKE_JOB_POOLS compile=4 link=2)
set(CMAKE_JOB_POOL_COMPILE compile)
set(CMAKE_JOB_POOL_LINK link)
set(BUILD_SHARED_LIBS 1)


FetchContent_Declare(tklog
  SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/libs/tklog
  OVERRIDE_FIND_PACKAGE
)

FetchContent_Declare(test-tklog
  SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/libs/tklog
  SOURCE_SUBDIR test
)

FetchContent_Declare(tkassert
  SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/libs/tkassert
  OVERRIDE_FIND_PACKAGE
)

FetchContent_Declare(test-tkassert
  SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/libs/tkassert
  SOURCE_SUBDIR test
)

FetchContent_Declare(tkrng
  SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/libs/tkrng
  OVERRIDE_FIND_PACKAGE
)

FetchContent_Declare(test-tkrng
  SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/libs/tkrng
  SOURCE_SUBDIR test
)

FetchContent_Declare(tktokenswap
  SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/libs/tktokenswap
  OVERRIDE_FIND_PACKAGE
)

FetchContent_Declare(test-tktokenswap
  SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/libs/tktokenswap
  SOURCE_SUBDIR test
)

FetchContent_Declare(tkwsm
  SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/libs/tkwsm
  OVERRIDE_FIND_PACKAGE
)

FetchContent_Declare(test-tkwsm
  SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/libs/tkwsm
  SOURCE_SUBDIR test
)

set(BUILD_TKET_TEST ON)
set(BUILD_TKET_PROPTEST ON)
FetchContent_Declare(tket
  SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/tket
  OVERRIDE_FIND_PACKAGE
)

FetchContent_Declare(pytket
  SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/pytket
)

FetchContent_MakeAvailable(
  tklog
  test-tklog
  tkassert
  test-tkassert
  tkrng
  test-tkrng
  tktokenswap
  test-tktokenswap
  tkwsm
  test-tkwsm
  tket
  # pytket
)

add_library(tklog::tklog ALIAS tklog)
add_library(tkassert::tkassert ALIAS tkassert)
add_library(tkrng::tkrng ALIAS tkrng)
add_library(tktokenswap::tktokenswap ALIAS tktokenswap)
add_library(tkwsm::tkwsm ALIAS tkwsm)
add_library(tket::tket ALIAS tket)

include(CTest)

add_test(NAME test-tklog COMMAND test-tklog)
add_test(NAME test-tkassert COMMAND test-tkassert)
add_test(NAME test-tkrng COMMAND test-tkrng)
add_test(NAME test-tktokenswap COMMAND test-tktokenswap)
add_test(NAME test-tkwsm COMMAND test-tkwsm)
add_test(NAME test-tket COMMAND test-tket)
add_test(NAME proptest-tket COMMAND proptest-tket)

target_link_libraries(tket PRIVATE flint)
set_target_properties(tket PROPERTIES
  INSTALL_RPATH_USE_LINK_PATH 1
)

set_property(TARGET tket APPEND PROPERTY INSTALL_RPATH "\${ORIGIN}")

set(venv ${CMAKE_CURRENT_BINARY_DIR}/_venv)
set(pip ${venv}/bin/pip)

message(STATUS "venv: ${venv}")

add_custom_command(OUTPUT ${venv}
  COMMAND rm -rf ${venv}
  COMMAND python3 -m venv ${venv}
  COMMAND "${pip}" install -r ${CMAKE_CURRENT_SOURCE_DIR}/pytket/tests/requirements.txt
  DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/pytket/tests/requirements.txt
)

set_property(DIRECTORY PROPERTY GENERATED ${venv})

add_custom_target(pytket ALL
  COMMAND env
    "tket_DIR=${tket_BINARY_DIR}"
    "tklog_DIR=${tklog_BINARY_DIR}"
    "tkassert_DIR=${tkassert_BINARY_DIR}"
    "tkrng_DIR=${tkrng_BINARY_DIR}"
    "tktokenswap_DIR=${tktokenswap_BINARY_DIR}"
    "tkwsm_DIR=${tkwsm_BINARY_DIR}"
    "NO_CONAN=1"
    "${pip}" install ${CMAKE_CURRENT_SOURCE_DIR}/pytket
  DEPENDS tket ${venv}
  USES_TERMINAL
)

add_test(NAME test-pytket
  COMMAND ${venv}/bin/python -m pytest ${CMAKE_CURRENT_SOURCE_DIR}/pytket/tests --ignore=simulator/
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/pytket
)
