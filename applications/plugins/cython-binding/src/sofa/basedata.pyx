# -*- coding: UTF8 -*
import cython
from libcpp cimport bool
from libcpp.string cimport string as libcpp_string
from cython.operator cimport dereference as deref, preincrement as inc, address as address

import array
from cpython cimport array

from libc.string cimport memcpy

cdef class BaseData:
        """ A BaseData exposes the component data fields.
        
            Examples:
                aData=Simulation.getRoot().findData("gravity")
                aData.getName()
                aData.getValueString()
                aData.getValueTypeString()
                aData.dim()                     # returns a tuple with the dimension of the datafield
                str(aData)
                len(aData)
                aData.append([1,2,3])
                aData[0] = [1,2,3]              # To change the value at index 0 
        """
        def __init__(self):
                raise Exception("It is not possible to create a base data object without a pointer") 
        
        def getName(self):
                return self.realptr.getName()          

        def getValueString(self):
                """ Return the value contained in this data field converted to a string description  
                
                    Example: 
                        print("Gravity is: "+Simulation.getRoot().findData("gravity").getValueString())
                        # Gravity is: 0, 0, 0
                """
                return self.realptr.getValueString() 

        def getValueTypeString(self):
                """ Return the data type of this datafield
                
                    Example: 
                        print("Gravity is: "+Simulation.getRoot().findData("gravity").getValueTypeString())
                        # => vec3d
                """
                return self.realptr.getValueTypeString() 
        
        def dim(self):
                """ Returns a tuple containing the dimensions of the data field
                
                    Example: 
                        print("Gravity dimension is: "+Simulation.getRoot().findData("gravity").dim())
                        # Gravity dimension is (1,3) 
                        # This means there is one value of size 3 (ie one vec3). 
                """
                cdef const _AbstractTypeInfo* nfo=self.realptr.getValueTypeInfo()
                cdef const void* ptr = self.realptr.getValueVoidPtr()
                return (nfo.size(ptr)/nfo.size(), nfo.size())
        
        def setSize(self, size):
                """ change the number of element in this data field"""
                assert isinstance(size, (int)), 'size should be of integer type'
                cdef const _AbstractTypeInfo* nfo=self.realptr.getValueTypeInfo()
                cdef void* ptr = self.realptr.beginEditVoidPtr()
                cdef rowwidth = nfo.size() 
                nfo.setSize(ptr, rowwidth*size) 
                self.realptr.endEditVoidPtr()                     
                return len(self)
                
        def append(self, value):
                """ Add a new value to the data field """
                cdef const _AbstractTypeInfo* nfo=self.realptr.getValueTypeInfo()
                cdef void* ptr = self.realptr.beginEditVoidPtr()
                
                cdef rowwidth = nfo.size() 
                cdef numrow = nfo.size(ptr) / rowwidth 
                oldsize = nfo.size(ptr)
                                
                if nfo.Container() and not nfo.FixedSize():
                        nfo.setSize(ptr, nfo.size(ptr)+nfo.size())
                        
                        if rowwidth == 1:
                                if nfo.Scalar():
                                        nfo.setScalarValue(ptr, oldsize, value)
                                if nfo.Integer():
                                        nfo.setIntegerValue(ptr, oldsize, value) 
                        else:                               
                                for i in range(0, rowwidth):
                                        if nfo.Scalar():
                                                nfo.setScalarValue(ptr, oldsize+i, value[i])
                                        if nfo.Integer():
                                                nfo.setIntegerValue(ptr, oldsize+i, value[i])
                
                        self.realptr.endEditVoidPtr()
                        return
                self.realptr.endEditVoidPtr()
                raise TypeError("This DataField is not a container or it cannot be resized.")         
                        
        
                
        def setPersistent(self, bool b):
                """ By default BaseData are not serialized. You can use this function
                    to indicate the contrary.  
                     
                    This may be usefull if you are implementing editting/modelling features
                    using the script and want the changed made to the scene to be saved.          
                """
                self.realptr.setPersistent(<bool>b)   
        
        def isPersistent(self):
                """ By default BaseData are not serialized. You can use the setPersistent function
                    to indicate the contrary and the getPersistent() one to get the current state.
                    
                    Example: 
                       if node.getObject("ThisObject").isPersistent() : 
                                print("This DataField will not be serialized")  
                    This may be usefull if you are implementing editting/modelling features
                    using the script and want the changed made to the scene to be saved.          
                """
                return self.realptr.isPersistent()
        
        def __len__(self):
                cdef const _AbstractTypeInfo* nfo=self.realptr.getValueTypeInfo()
                cdef const void* ptr = self.realptr.getValueVoidPtr()
                return nfo.size(ptr)/nfo.size()
                        
        def __getitem__(self, key):
                cdef const _AbstractTypeInfo* nfo=self.realptr.getValueTypeInfo()
                cdef const void* ptr = self.realptr.getValueVoidPtr()
                cdef rowwidth = nfo.size() 
                cdef numrow = nfo.size(ptr) / rowwidth 
                if not isinstance(key, int):
                        raise TypeError("Expecting the key to be an interger while the provided value ["+str(key)+"] seems to be of type "+str(type(key)))         
                if key>=numrow:
                        raise IndexError("Key ["+str(key)+"] is to big for this array of size "+str(numrow) )
                
                py_result = []
                for i in range(0, rowwidth):
                        if nfo.Scalar():
                                py_result.append(nfo.getScalarValue(self.realptr.getValueVoidPtr(), key*rowwidth+i))
                        if nfo.Integer():
                                py_result.append(nfo.getIntegerValue(self.realptr.getValueVoidPtr(), key*rowwidth+i))
                        if nfo.Text():
                                py_result.append(nfo.getTextValue(self.realptr.getValueVoidPtr(), key*rowwidth+i))
                
                if nfo.Container():
                        return py_result
                return py_result[0]

        cdef setValueScalar(BaseData self, const _AbstractTypeInfo* nfo, void* ptr, int rowwidth, int numrow, int idx,  value):
                cdef int i=0 
                for i in range(0, rowwidth):
                        nfo.setScalarValue(ptr, idx*rowwidth+i, value[i])
        
        cdef setValueInteger(BaseData self, const _AbstractTypeInfo* nfo, void* ptr, int rowwidth, int numrow, int idx, value):
                cdef int i=0 
                for i in range(0, rowwidth):
                        nfo.setIntegerValue(ptr, idx*rowwidth+i, value[i])

        cdef setValueText(BaseData self, const _AbstractTypeInfo* nfo, void* ptr, int rowwidth, int numrow, int idx,  value):
                cdef int i=0
                for i in range(0, rowwidth):
                        nfo.setTextValue(ptr, idx*rowwidth+i, value[i])                                
        
        @cython.nonecheck(False)    
        @cython.boundscheck(False)    
        @cython.wraparound(False)    
        @cython.overflowcheck(False)  
        cdef setValuesFromArray(BaseData self, const _AbstractTypeInfo* nfo, void* ptr, array.array ca):
                        cdef int i=0
                        cdef int mi = nfo.size(ptr)
                        cdef void* rawsrcptr = ca.data.as_voidptr
                        cdef void* rawdstptr = nfo.getValuePtr(ptr) 
                         
                        #for i in range(0, mi):
                        #        nfo.setScalarValue(ptr, i, rawptr[i])
                        memcpy(rawdstptr, rawsrcptr, mi * sizeof(float))

        
        @cython.nonecheck(False)    
        @cython.boundscheck(False)    
        @cython.wraparound(False)    
        @cython.overflowcheck(False)    
        def setValues(self, values):
                """ Change the content of a complete datafield """
                cdef const _AbstractTypeInfo* nfo=self.realptr.getValueTypeInfo()
                cdef void* ptr = self.realptr.beginEditVoidPtr()
                cdef int rowwidth = nfo.size() 
                cdef int numrow = nfo.size(ptr) / rowwidth
                
                cdef int i = 0 
                cdef int j = 0 
                cdef int mi = 0    
                
                # Fast array API path.
                if isinstance(values, array.array):
                        self.setValuesFromArray(nfo, ptr, values)
                        
                elif nfo.Container():
                        # We only have one entry ...
                        if nfo.FixedSize() and rowwidth == len(values):
                                if nfo.Scalar():        
                                                self.setValueScalar(nfo, ptr, rowwidth, numrow, 0, values)
                                elif nfo.Integer():
                                                self.setValueInteger(nfo, ptr, rowwidth, numrow, 0, values)
                                elif nfo.Text():
                                                self.setValueText(nfo, ptr, rowwidth, numrow, 0, values)       
                        else:        
                                # We can loop around the container. 
                                if not nfo.FixedSize() and len(self) > len(values):
                                        print("Resize the datavalues to "+str(self)+" -> "+str(len(values))) 
                                        self.setSize(len(values))
                                
                                if nfo.Scalar():  
                                        i=0
                                        mi = len(values)               
                                        for i in range(0, mi):
                                                for j in range(0, rowwidth):
                                                        nfo.setScalarValue(ptr, i*rowwidth+j, values[i][j])
                                elif nfo.Integer():
                                        i=0                                        
                                        for v in values:
                                                for j in range(0, rowwidth):
                                                        nfo.setIntegerValue(ptr, i*rowwidth+j, v[j])
                                                i+=1
                                elif nfo.Text():
                                        i=0
                                        for v in values:
                                                for j in range(0, rowwidth):
                                                        nfo.setTextValue(ptr, i*rowwidth+j, v[j])                                
                                                i+=1
                else:
                        if nfo.Scalar():        
                                                self.setValueScalar(nfo, ptr, rowwidth, numrow, 0, values)
                        elif nfo.Integer():
                                                self.setValueInteger(nfo, ptr, rowwidth, numrow, 0, values)
                        elif nfo.Text():
                                                self.setValueText(nfo, ptr, rowwidth, numrow, 0, values)       
                        
                self.realptr.endEditVoidPtr()
                
                        
        def __setitem__(self, key, value):
                cdef const _AbstractTypeInfo* nfo=self.realptr.getValueTypeInfo()
                cdef void* ptr = self.realptr.beginEditVoidPtr()
                cdef rowwidth = nfo.size() 
                cdef numrow = nfo.size(ptr) / rowwidth 
                if not isinstance(key, int):
                        self.realptr.endEditVoidPtr()
                        raise TypeError("Expecting the key to be an interger while the provided value ["+str(key)+"] seems to be of type "+str(type(key)))         
                if key>=numrow:
                        self.realptr.endEditVoidPtr()
                        raise IndexError("Key ["+str(key)+"] is to big for this array of size "+str(rowwidth) )
                
                if nfo.Text():
                        nfo.setTextValue(ptr, key, value) 
                        self.realptr.endEditVoidPtr()
                        return       
                        
                if len(value) != rowwidth:
                        self.realptr.endEditVoidPtr()
                        raise IndexError("Value has a length of size ["+str(len(value))+"] which differ from the expected size "+str(rowwidth) )
             
                for i in range(0, rowwidth):
                        if nfo.Scalar():
                                nfo.setScalarValue(ptr, key*rowwidth+i, value[i])
                        if nfo.Integer():
                                nfo.setIntegerValue(ptr, key*rowwidth+i, value[i])
                self.realptr.endEditVoidPtr()
        
        def __repr__(self):
                return self.realptr.getValueString()
                
        def __str__(self):
                return self.realptr.getValueString()

        @staticmethod
        cdef BaseData createBaseDataFrom(_BaseData *rawptr):
                cdef BaseData pydata = BaseData.__new__(BaseData)
                pydata.realptr = rawptr
                return pydata
