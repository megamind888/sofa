cmake_minimum_required(VERSION 3.22)

project(Sofa.Component.Mapping.NonLinear_test)

set(SOURCE_FILES
    AreaMapping_test.cpp
    DistanceMapping_test.cpp
    DistanceMultiMapping_test.cpp
    RigidMapping_test.cpp
    SquareDistanceMapping_test.cpp
    SquareMapping_test.cpp
    VolumeMapping_test.cpp
)

add_executable(${PROJECT_NAME} ${SOURCE_FILES})
target_link_libraries(${PROJECT_NAME} Sofa.Testing Sofa.Component.Mapping.Testing)
target_link_libraries(${PROJECT_NAME} Sofa.Component.Mapping.NonLinear Sofa.Component.Topology.Container.Dynamic Sofa.Component.StateContainer)


add_test(NAME ${PROJECT_NAME} COMMAND ${PROJECT_NAME})
