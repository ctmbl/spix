set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

#
# Dependencies
#
# find_package(Threads REQUIRED)
# find_package(AnyRPC REQUIRED)
find_package(Qt${SPIX_QT_MAJOR} COMPONENTS Core Quick REQUIRED)
# find_package(Spix CONFIG REQUIRED)

add_executable(SpixTestingV1 "main.cpp" "qml.qrc" "workbench_enums.cpp")
target_compile_definitions(SpixTestingV1 PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(SpixTestingV1 PRIVATE Qt${SPIX_QT_MAJOR}::Core Qt${SPIX_QT_MAJOR}::Quick Spix)

