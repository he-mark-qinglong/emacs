# Mark Zhao 2013-04-01 ynsjzch@163.com
import lldb
import string

def is_dnc_object_type(type):
    while(type):
        if(type.GetName() == "dnc::object"):
            return 1
        type = type.GetDirectBaseClassAtIndex(0)
        if(type):
            type = type.GetType()
    return 0    

def is_dnc_objet(obj):
    return is_dnc_object_type(obj.GetType())

def is_dnc_string_type(type):
    return type.GetName() == "dnc::string"

def is_dnc_string_object(obj):
    return is_dnc_string_type(obj.GetType())

def print_dnc_null_object(var):
    print "(" + var.GetType().GetName() + ") " + var.GetName() + " = null"

def print_dnc_handle(mh):
    value=string.atoi(mh.GetValue(),16)
    if(value == 0):
        print "null",
    handle_type=lldb.target.FindTypes('dnc::handle').GetTypeAtIndex(0)
    handle_type_p=handle_type.GetPointerType()
    mh = mh.Cast(handle_type_p)
    mh=mh.dynamic
    #type=mh.GetType().GetPointeeType()
    print mh.Dereference(),

def print_dnc_object(var):
    mh=var.GetChildMemberWithName('mh');    
    value=string.atoi(mh.GetValue(),16)
    if(value == 0):
        print_dnc_null_object(var)
        return
    print_dnc_handle(mh)
    print
    
    

#get dnc string by C string
def get_dnc_string_for_handle(mh):
    value=string.atoi(mh.GetValue(),16)
    if(value == 0):
        return "null"

    handle_type=lldb.target.FindTypes('dnc::handle').GetTypeAtIndex(0)
    handle_type_p=handle_type.GetPointerType()
    mh = mh.Cast(handle_type_p)
    mh=mh.dynamic
    data=mh.GetChildMemberWithName('data');
    type=lldb.target.FindTypes("char").GetTypeAtIndex(0);
    type = type.GetPointerType()
    data = data.Cast(type)
    return data.GetSummary()

def get_dnc_string(var):
    mh=var.GetChildMemberWithName('mh');
    return get_dnc_string_for_handle(mh)
    
def print_dnc_string_object(var):    
    print "(dnc::string) " + var.GetName() + " = " + get_dnc_string(var)

def is_dnc_vector_object(var):
    if(not is_dnc_objet(var)):
        return 0
    if(var.GetType().GetNumberOfDirectBaseClasses() == 0):
        return 0
    type = var.GetType()
    name = type.GetName()
    name = name[0:12]
    return name == "dnc::vector<"

def pointer_add_1(ptr_value):
    type = ptr_value.GetType()
    T = type.GetPointeeType()
    unit = T.size
    if(is_dnc_object_type(T)):
        unit = type.size # sizeof pointer
    value=string.atoi(ptr_value.GetValue(),16)
    return ptr_value.CreateValueFromExpression(
        "gudx_dnc_vector_temp",
        "("+T.GetName()+"*)" + str(value + unit))

def print_array_aux_string(ptr):
    str_handle = ptr.CreateValueFromExpression(
        "gudx_dnc_string_temp","*(dnc::string::handle**)" + ptr.GetValue())
    print get_dnc_string_for_handle(str_handle),

def print_array_aux_value(ptr):
    print ptr.Dereference().GetValue(),

def print_array_aux_object(ptr):
    handle = ptr.CreateValueFromExpression(
        "$","*(dnc::object::handle**)" + ptr.GetValue())
    print
    print_dnc_handle(handle)

def print_array_aux(data,count,print_func):
    for i in range(0,count):
        if(i > 0):
            print ",",
        print_func(data)
        data = pointer_add_1(data)


def print_array(data,count):
    T = data.GetType()
    T = T.GetPointeeType()
    if(is_dnc_string_type(T)):
        print_array_aux(data,count,print_array_aux_string)
    elif(is_dnc_object_type(T)):
        print
        print_array_aux(data,count,print_array_aux_object)
        print
    else:
        print_array_aux(data,count,print_array_aux_value)
            
    
def print_dnc_vector_object(var):
    T = var.GetType().GetTemplateArgumentType(0)
    mh=var.GetChildMemberWithName('mh');
    value=string.atoi(mh.GetValue(),16)
    if(value == 0):
        print_dnc_null_object(var)
        return

    handle_type=lldb.target.FindTypes('dnc::handle').GetTypeAtIndex(0)
    handle_type_p=handle_type.GetPointerType()
    mh = mh.Cast(handle_type_p)
    mh=mh.dynamic
    data=mh.GetChildMemberWithName('data');
    size=mh.GetChildMemberWithName('size');
    size = string.atoi(size.GetValue())
    data = data.Cast(T.GetPointerType())

    count = size
    max_count = 60
    if(size > max_count):
        count = max_count
    print "(" + var.GetType().GetName() + ") " + var.GetName() + " = @" + str(size) +" {",
        
    print_array(data,count)

    if(size > max_count):
        print "...",
    print "}"
        

def print_variant(obj_name):
    var=lldb.frame.FindVariable(obj_name)
    
    if(is_dnc_string_object(var)):
        print_dnc_string_object(var)
    elif(is_dnc_vector_object(var)):
        print_dnc_vector_object(var)
    elif(is_dnc_objet(var)):
        print_dnc_object(var)    
    else:
        print var

## command script import ~/site-lisp/gudx.py
