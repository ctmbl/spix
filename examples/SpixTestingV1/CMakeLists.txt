cmake_minimum_required(VERSION 3.12)
project(SpixTestingV1 LANGUAGES CXX)

set(SPIX_QT_MAJOR "5" CACHE STRING "Major Qt version to build Spix against")

set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/../../cmake/modules")

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

#
# Dependencies
#
find_package(Threads REQUIRED)
find_package(AnyRPC REQUIRED)
find_package(Qt${SPIX_QT_MAJOR} COMPONENTS Core Quick REQUIRED)
find_package(Spix CONFIG REQUIRED)

add_executable(SpixTestingV1 "main.cpp" "qml.qrc")
target_compile_definitions(SpixTestingV1 PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(SpixTestingV1 PRIVATE Threads::Threads Qt${SPIX_QT_MAJOR}::Core Qt${SPIX_QT_MAJOR}::Quick Spix::Spix)
