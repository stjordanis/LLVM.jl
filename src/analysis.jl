export verify

function verify(mod::Module)
    outerror = Ref{Cstring}()
    status =
        BoolFromLLVM(API.LLVMVerifyModule(ref(mod), API.LLVMReturnStatusAction, outerror))

    if status
        error = unsafe_string(outerror[])
        API.LLVMDisposeMessage(outerror[])
        throw(error)
    end
end

function verify(fn::Function)
    status = BoolFromLLVM(API.LLVMVerifyFunction(ref(fn), API.LLVMReturnStatusAction))

    if status
        throw("broken function")
    end
end
