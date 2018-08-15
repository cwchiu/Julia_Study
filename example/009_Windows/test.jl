using Pkg
Pkg.activate(".")

using Test
# Win32 : DWORD WINAPI GetTickCount(void)
tickCount = ccall( (:GetTickCount, "kernel32"), stdcall, UInt32, () )
println(tickCount)

# Win32 : int MessageBox(DWORD, LPCTSTR, LPCTSTR, UINT) 
const MB_OK = 0x0
const ID_OK = 0x1
ret = ccall( (:MessageBoxA, "user32"), stdcall, Int32, (Int32, Cstring, Cstring, UInt32), 0, "Hello", "World", MB_OK)
@test ret == ID_OK
    