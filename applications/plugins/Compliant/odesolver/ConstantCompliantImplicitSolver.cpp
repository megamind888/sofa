#include "ConstantCompliantImplicitSolver.h"

#include <sofa/component/linearsolver/EigenSparseMatrix.h>
#include <sofa/component/linearsolver/EigenVector.h>
#include <sofa/core/ObjectFactory.h>
#include <sofa/simulation/common/MechanicalOperations.h>
#include <sofa/simulation/common/VectorOperations.h>

#include "assembly/AssemblyVisitor.h"
#include "constraint/ConstraintValue.h"



namespace sofa {
namespace component {
namespace odesolver {

SOFA_DECL_CLASS(ConstantCompliantImplicitSolver);
int ConstantCompliantImplicitSolverClass = core::RegisterObject("Pre-assembled AssembedSolver").add< ConstantCompliantImplicitSolver >();

using namespace sofa::defaulttype;
using namespace sofa::helper;
using namespace core::behavior;



void ConstantCompliantImplicitSolver::perform_assembly( const core::MechanicalParams *mparams, system_type& sys )
{
    if( assemblyVisitor ) return;

    assemblyVisitor = new simulation::AssemblyVisitor(mparams);

    // fetch nodes/data
    send( *assemblyVisitor );

    // assemble system
    sys = assemblyVisitor->assemble();
}



}
}
}