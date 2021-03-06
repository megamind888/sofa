cmake_minimum_required(VERSION 3.1)
project(SofaGeneralTopology)


set(HEADER_FILES
    BezierTetrahedronSetGeometryAlgorithms.h
    BezierTetrahedronSetGeometryAlgorithms.inl
    BezierTetrahedronSetTopologyContainer.h
    BezierTriangleSetGeometryAlgorithms.h
    BezierTriangleSetGeometryAlgorithms.inl
    BezierTriangleSetTopologyContainer.h
    CubeTopology.h
    CylinderGridTopology.h
    SphereGridTopology.h
    SphereQuadTopology.h
    config.h
    initGeneralTopology.h
)

set(SOURCE_FILES
    BezierTetrahedronSetGeometryAlgorithms.cpp
    BezierTetrahedronSetTopologyContainer.cpp
    BezierTriangleSetGeometryAlgorithms.cpp
    BezierTriangleSetTopologyContainer.cpp
    CubeTopology.cpp
    CylinderGridTopology.cpp
    SphereGridTopology.cpp
    SphereQuadTopology.cpp
    initGeneralTopology.cpp
)

add_library(${PROJECT_NAME} SHARED ${HEADER_FILES} ${SOURCE_FILES})
target_link_libraries(${PROJECT_NAME} PUBLIC SofaSimulationCommon SofaBaseTopology)
set_target_properties(${PROJECT_NAME} PROPERTIES COMPILE_FLAGS "-DSOFA_BUILD_GENERAL_TOPOLOGY")
set_target_properties(${PROJECT_NAME} PROPERTIES PUBLIC_HEADER "${HEADER_FILES}")

sofa_install_targets(SofaGeneral ${PROJECT_NAME} ${PROJECT_NAME})
