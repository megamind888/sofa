#include <SofaComponentBase/initComponentBase.h>
#include <SofaComponentCommon/initComponentCommon.h>
#include <SofaComponentGeneral/initComponentGeneral.h>
#include <SofaComponentAdvanced/initComponentAdvanced.h>
#include <SofaComponentMisc/initComponentMisc.h>
#include <SofaSimulationCommon/init.h>
#include <SofaSimulationGraph/init.h>

#include <SofaTest/Sofa_test.h>
using sofa::Sofa_test;

#include <sofa/defaulttype/Vec.h>
using sofa::defaulttype::Vec4d ;

#include <sofa/core/objectmodel/Data.h>
using sofa::core::objectmodel::Data ;

#include <sofa/defaulttype/Color.h>
using sofa::defaulttype::RGBAColor ;

class Color_Test : public Sofa_test<>
{
public:
    void SetUp() ;
    void TearDown() ;;
    void checkCreateFromString() ;
    void checkCreateFromDouble() ;
    void checkEquality() ;
    void checkGetSet() ;
    void checkColorDataField() ;
};

void Color_Test::SetUp()
{
    sofa::simulation::common::init();
    sofa::simulation::graph::init();
}

void Color_Test::TearDown()
{
    sofa::simulation::common::cleanup();
    sofa::simulation::graph::cleanup();
}

void Color_Test::checkCreateFromString()
{
    EXPECT_EQ( RGBAColor::fromString("white"), RGBAColor(1.0,1.0,1.0,1.0) ) ;
    EXPECT_EQ( RGBAColor::fromString("black"), RGBAColor(0.0,0.0,0.0,1.0) ) ;
    EXPECT_EQ( RGBAColor::fromString("red"), RGBAColor(1.0,0.0,0.0,1.0) ) ;
    EXPECT_EQ( RGBAColor::fromString("green"), RGBAColor(0.0,1.0,0.0,1.0) ) ;
    EXPECT_EQ( RGBAColor::fromString("blue"), RGBAColor(0.0,0.0,1.0,1.0) ) ;
    EXPECT_EQ( RGBAColor::fromString("cyan"), RGBAColor(0.0,1.0,1.0,1.0) ) ;
    EXPECT_EQ( RGBAColor::fromString("magenta"), RGBAColor(1.0,0.0,1.0,1.0) ) ;
    EXPECT_EQ( RGBAColor::fromString("yellow"), RGBAColor(1.0,1.0,0.0,1.0) ) ;
    EXPECT_EQ( RGBAColor::fromString("yellow"), RGBAColor(1.0,1.0,0.0,1.0) ) ;
    EXPECT_EQ( RGBAColor::fromString("gray"), RGBAColor(0.5,0.5,0.5,1.0) ) ;

    RGBAColor color;
    EXPECT_TRUE( RGBAColor::read("white", color) ) ;
    EXPECT_FALSE( RGBAColor::read("invalidcolor", color) ) ;

    /// READ RGBA colors
    EXPECT_EQ( RGBAColor::fromString("1 2 3 4"), RGBAColor(1.0,2.0,3.0,4.0) ) ;
    EXPECT_EQ( RGBAColor::fromString("0 0 3 4"), RGBAColor(0.0,0.0,3.0,4.0) ) ;

    /// READ RGB colors
    EXPECT_EQ( RGBAColor::fromString("1 2 3"), RGBAColor(1.0,2.0,3.0,1.0) ) ;
    EXPECT_EQ( RGBAColor::fromString("0 0 3"), RGBAColor(0.0,0.0,3.0,1.0) ) ;

    RGBAColor color2;
    EXPECT_TRUE( RGBAColor::read("1 2 3 4", color2) ) ;
    EXPECT_EQ( color2, RGBAColor(1,2,3,4));

    EXPECT_TRUE( RGBAColor::read("0 0 3 4", color2) ) ;
    EXPECT_EQ( color2, RGBAColor(0,0,3,4));

    EXPECT_TRUE( RGBAColor::read("1 2 3", color2) ) ;
    EXPECT_EQ( color2, RGBAColor(1,2,3,1));

    EXPECT_FALSE( RGBAColor::read("1 2 3 4 5", color2) ) ;
    EXPECT_FALSE( RGBAColor::read("1 a 3 4", color2) ) ;
    EXPECT_FALSE( RGBAColor::read("-1 2 3 5", color2) ) ;

    ///# short hexadecimal notation
    EXPECT_EQ( RGBAColor::fromString("#000"), RGBAColor(0.0,0.0,0.0,1.0) ) ;
    EXPECT_EQ( RGBAColor::fromString("#0000"), RGBAColor(0.0,0.0,0.0,0.0) ) ;

    EXPECT_TRUE( RGBAColor::read("#ABA", color2) ) ;
    EXPECT_TRUE( RGBAColor::read("#FFAA", color2) ) ;

    EXPECT_TRUE( RGBAColor::read("#aba", color2) ) ;
    EXPECT_TRUE( RGBAColor::read("#ffaa", color2) ) ;

    EXPECT_FALSE( RGBAColor::read("#ara", color2) ) ;
    EXPECT_FALSE( RGBAColor::read("#ffap", color2) ) ;
    EXPECT_FALSE( RGBAColor::read("##fapa", color2) ) ;
    EXPECT_FALSE( RGBAColor::read("#f#apa", color2) ) ;

    ///# long hexadecimal notation
    EXPECT_EQ( RGBAColor::fromString("#000000"), RGBAColor(0.0,0.0,0.0,1.0) ) ;
    EXPECT_EQ( RGBAColor::fromString("#00000000"), RGBAColor(0.0,0.0,0.0,0.0) ) ;

    EXPECT_TRUE( RGBAColor::read("#AABBAA", color2) ) ;
    EXPECT_TRUE( RGBAColor::read("#FFAA99AA", color2) ) ;

    EXPECT_FALSE( RGBAColor::read("#aabraa", color2) ) ;
    EXPECT_FALSE( RGBAColor::read("#fffapaba", color2) ) ;
    EXPECT_FALSE( RGBAColor::read("##fpaapddda", color2) ) ;
    EXPECT_FALSE( RGBAColor::read("#fasdqdpa", color2) ) ;

}

void Color_Test::checkCreateFromDouble()
{
    EXPECT_EQ( RGBAColor::fromDouble(1.0,1.0,1.0,1.0), RGBAColor(1.0,1.0,1.0,1.0)) ;
    EXPECT_EQ( RGBAColor::fromDouble(1.0,0.0,1.0,1.0), RGBAColor(1.0,0.0,1.0,1.0)) ;
    EXPECT_EQ( RGBAColor::fromDouble(1.0,1.0,0.0,1.0), RGBAColor(1.0,1.0,0.0,1.0)) ;
    EXPECT_EQ( RGBAColor::fromDouble(1.0,1.0,1.0,0.0), RGBAColor(1.0,1.0,1.0,0.0)) ;

    Vec4d tt(2,3,4,5) ;
    EXPECT_EQ( RGBAColor::fromVec4(tt), RGBAColor(2,3,4,5)) ;
}

void Color_Test::checkGetSet()
{
    RGBAColor a;
    a.r(1);
    EXPECT_EQ(a.r(), 1.0) ;

    a.g(2);
    EXPECT_EQ(a.g(), 2.0) ;

    a.b(3);
    EXPECT_EQ(a.b(), 3.0) ;

    a.a(4);
    EXPECT_EQ(a.a(), 4.0) ;

    EXPECT_EQ(a, RGBAColor(1.0,2.0,3.0,4.0)) ;
}

void Color_Test::checkColorDataField()
{
    Data<RGBAColor> color ;

    EXPECT_FALSE(color.read("invalidcolor"));

    EXPECT_TRUE(color.read("white"));
    EXPECT_EQ(color.getValue(), RGBAColor(1.0,1.0,1.0,1.0));

    EXPECT_TRUE(color.read("blue"));
    EXPECT_EQ(color.getValue(), RGBAColor(0.0,0.0,1.0,1.0));

    std::stringstream tmp;
    tmp << color ;

    EXPECT_TRUE(color.read(tmp.str()));
    EXPECT_EQ(color.getValue(), RGBAColor(0.0,0.0,1.0,1.0));
}

void Color_Test::checkEquality()
{
    EXPECT_EQ(RGBAColor(), RGBAColor());
    EXPECT_EQ(RGBAColor(0.0,1.0,2.0,3.0), RGBAColor(0.0,1.0,2.0,3.0));

    EXPECT_NE(RGBAColor(0.1,1.0,2.0,3.0), RGBAColor(0.0,1.0,2.0,3.0));
    EXPECT_NE(RGBAColor(0.1,1.1,2.0,3.0), RGBAColor(0.1,1.0,2.0,3.0));
    EXPECT_NE(RGBAColor(0.1,1.1,2.1,3.0), RGBAColor(0.1,1.1,2.0,3.0));
    EXPECT_NE(RGBAColor(0.1,1.1,2.1,3.1), RGBAColor(0.1,1.1,2.1,3.0));
}

TEST_F(Color_Test, checkColorDataField)
{
    this->checkColorDataField() ;
}

TEST_F(Color_Test, checkCreateFromString)
{
    this->checkCreateFromString() ;
}

TEST_F(Color_Test, checkCreateFromDouble)
{
    this->checkCreateFromString() ;
}

TEST_F(Color_Test, checkEquality)
{
    this->checkEquality() ;
}

