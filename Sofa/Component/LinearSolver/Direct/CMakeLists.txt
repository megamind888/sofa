cmake_minimum_required(VERSION 3.22)
project(Sofa.Component.LinearSolver.Direct LANGUAGES CXX)

set(SOFACOMPONENTLINEARSOLVERDIRECT_SOURCE_DIR "src/sofa/component/linearsolver/direct")

set(HEADER_FILES
    ${SOFACOMPONENTLINEARSOLVERDIRECT_SOURCE_DIR}/config.h.in
    ${SOFACOMPONENTLINEARSOLVERDIRECT_SOURCE_DIR}/init.h
    ${SOFACOMPONENTLINEARSOLVERDIRECT_SOURCE_DIR}/AsyncSparseLDLSolver.h
    ${SOFACOMPONENTLINEARSOLVERDIRECT_SOURCE_DIR}/AsyncSparseLDLSolver.inl
    ${SOFACOMPONENTLINEARSOLVERDIRECT_SOURCE_DIR}/BTDLinearSolver.h
    ${SOFACOMPONENTLINEARSOLVERDIRECT_SOURCE_DIR}/BTDLinearSolver.inl
    ${SOFACOMPONENTLINEARSOLVERDIRECT_SOURCE_DIR}/CholeskySolver.h
    ${SOFACOMPONENTLINEARSOLVERDIRECT_SOURCE_DIR}/CholeskySolver.inl
    ${SOFACOMPONENTLINEARSOLVERDIRECT_SOURCE_DIR}/EigenDirectSparseSolver.h
    ${SOFACOMPONENTLINEARSOLVERDIRECT_SOURCE_DIR}/EigenDirectSparseSolver.inl
    ${SOFACOMPONENTLINEARSOLVERDIRECT_SOURCE_DIR}/EigenSolverFactory.h
    ${SOFACOMPONENTLINEARSOLVERDIRECT_SOURCE_DIR}/EigenSimplicialLDLT.h
    ${SOFACOMPONENTLINEARSOLVERDIRECT_SOURCE_DIR}/EigenSimplicialLLT.h
    ${SOFACOMPONENTLINEARSOLVERDIRECT_SOURCE_DIR}/EigenSparseLU.h
    ${SOFACOMPONENTLINEARSOLVERDIRECT_SOURCE_DIR}/EigenSparseQR.h
    ${SOFACOMPONENTLINEARSOLVERDIRECT_SOURCE_DIR}/MatrixLinearSystem[BTDMatrix].h
    ${SOFACOMPONENTLINEARSOLVERDIRECT_SOURCE_DIR}/PrecomputedLinearSolver.h
    ${SOFACOMPONENTLINEARSOLVERDIRECT_SOURCE_DIR}/PrecomputedLinearSolver.inl
    ${SOFACOMPONENTLINEARSOLVERDIRECT_SOURCE_DIR}/SVDLinearSolver.h
    ${SOFACOMPONENTLINEARSOLVERDIRECT_SOURCE_DIR}/SVDLinearSolver.inl
    ${SOFACOMPONENTLINEARSOLVERDIRECT_SOURCE_DIR}/SimplicialLDLTTraits.h
    ${SOFACOMPONENTLINEARSOLVERDIRECT_SOURCE_DIR}/SimplicialLLTTraits.h
    ${SOFACOMPONENTLINEARSOLVERDIRECT_SOURCE_DIR}/SparseCholeskySolver.h
    ${SOFACOMPONENTLINEARSOLVERDIRECT_SOURCE_DIR}/SparseCholeskySolver.inl
    ${SOFACOMPONENTLINEARSOLVERDIRECT_SOURCE_DIR}/SparseCommon.h
    ${SOFACOMPONENTLINEARSOLVERDIRECT_SOURCE_DIR}/SparseLDLSolver.h
    ${SOFACOMPONENTLINEARSOLVERDIRECT_SOURCE_DIR}/SparseLDLSolver.inl
    ${SOFACOMPONENTLINEARSOLVERDIRECT_SOURCE_DIR}/SparseLDLSolverImpl.h
    ${SOFACOMPONENTLINEARSOLVERDIRECT_SOURCE_DIR}/SparseLUSolver.h
    ${SOFACOMPONENTLINEARSOLVERDIRECT_SOURCE_DIR}/SparseLUSolver.inl
    ${SOFACOMPONENTLINEARSOLVERDIRECT_SOURCE_DIR}/SparseLUTraits.h
    ${SOFACOMPONENTLINEARSOLVERDIRECT_SOURCE_DIR}/SparseQRTraits.h
    ${SOFACOMPONENTLINEARSOLVERDIRECT_SOURCE_DIR}/TypedMatrixLinearSystem[BTDMatrix].h
)

set(SOURCE_FILES
    ${SOFACOMPONENTLINEARSOLVERDIRECT_SOURCE_DIR}/init.cpp
    ${SOFACOMPONENTLINEARSOLVERDIRECT_SOURCE_DIR}/AsyncSparseLDLSolver.cpp
    ${SOFACOMPONENTLINEARSOLVERDIRECT_SOURCE_DIR}/BTDLinearSolver.cpp
    ${SOFACOMPONENTLINEARSOLVERDIRECT_SOURCE_DIR}/CholeskySolver.cpp
    ${SOFACOMPONENTLINEARSOLVERDIRECT_SOURCE_DIR}/EigenSimplicialLDLT.cpp
    ${SOFACOMPONENTLINEARSOLVERDIRECT_SOURCE_DIR}/EigenSimplicialLLT.cpp
    ${SOFACOMPONENTLINEARSOLVERDIRECT_SOURCE_DIR}/EigenSolverFactory.cpp
    ${SOFACOMPONENTLINEARSOLVERDIRECT_SOURCE_DIR}/EigenSparseLU.cpp
    ${SOFACOMPONENTLINEARSOLVERDIRECT_SOURCE_DIR}/EigenSparseQR.cpp
    ${SOFACOMPONENTLINEARSOLVERDIRECT_SOURCE_DIR}/MatrixLinearSystem[BTDMatrix].cpp
    ${SOFACOMPONENTLINEARSOLVERDIRECT_SOURCE_DIR}/PrecomputedLinearSolver.cpp
    ${SOFACOMPONENTLINEARSOLVERDIRECT_SOURCE_DIR}/SVDLinearSolver.cpp
    ${SOFACOMPONENTLINEARSOLVERDIRECT_SOURCE_DIR}/SparseLDLSolver.cpp
    ${SOFACOMPONENTLINEARSOLVERDIRECT_SOURCE_DIR}/TypedMatrixLinearSystem[BTDMatrix].cpp
)

# make sure you have threads for AsyncSparseLDLSolver
sofa_find_package(Threads REQUIRED)

sofa_find_package(Sofa.Simulation.Core REQUIRED)
sofa_find_package(Sofa.Component.LinearSolver.Iterative REQUIRED) # Only for MatrixLinearSolver which will move to core
sofa_find_package(Sofa.Component.LinearSolver.Ordering REQUIRED)

add_library(${PROJECT_NAME} SHARED ${HEADER_FILES} ${SOURCE_FILES} ${WRAPPER_FILES})

target_link_libraries(${PROJECT_NAME} PUBLIC Sofa.Simulation.Core Sofa.Component.LinearSolver.Iterative Sofa.Component.LinearSolver.Ordering)
target_link_libraries(${PROJECT_NAME} PUBLIC Threads::Threads)

sofa_create_package_with_targets(
    PACKAGE_NAME ${PROJECT_NAME}
    PACKAGE_VERSION ${Sofa_VERSION}
    TARGETS ${PROJECT_NAME} AUTO_SET_TARGET_PROPERTIES
    INCLUDE_SOURCE_DIR "src"
    INCLUDE_INSTALL_DIR "${PROJECT_NAME}"
)

cmake_dependent_option(SOFA_COMPONENT_LINEARSOLVER_DIRECT_BUILD_TESTS "Compile the automatic tests" ON "SOFA_BUILD_TESTS OR NOT DEFINED SOFA_BUILD_TESTS" OFF)
if(SOFA_COMPONENT_LINEARSOLVER_DIRECT_BUILD_TESTS)
    add_subdirectory(tests)
endif()
