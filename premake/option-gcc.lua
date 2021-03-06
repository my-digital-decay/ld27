--------------------------------------------------------------------------------
--- file: option-gcc.lua
--- gcc custom build option
---

local match = string.match
function trim(s)
  return match(s,'^()%s*$') and '' or match(s,'^%s*(.*%S)')
end

newoption {
  trigger = "gcc",
  value = "GCC",
  description = "Choose GCC flavor",
  allowed = {
    { "osx", "Mac OS X" },
    { "ios", "iOS" },
    { "linux", "Linux" },
  }
}

if "gmake" == _ACTION then
  if nil == _OPTIONS.gcc then
    print("GCC flavor must be specified!")
    os.exit(1)
  end

  if "osx" == _OPTIONS.gcc then
--    premake.gcc.cc = "gcc-4.8"
--    premake.gcc.cxx = "g++-4.8"
--    linkoptions { "-L\"" .. trim(os.outputof("brew --cellar")) .. "/gcc48/4.8.1/gcc/lib/i386\"" }
    location (ROOT_PATH .. "/build/" .. _ACTION .. "-osx")
    DEV_PATH = trim(os.outputof("xcode-select --print-path")) .. "/Platforms/MacOSX.platform/Developer"
  end

  if "ios" == _OPTIONS.gcc then
    location (ROOT_PATH .. "/build/" .. _ACTION .. "-ios")
    DEV_PATH = trim(os.outputof("xcode-select --print-path")) .. "/Platforms/iPhoneOS.platform/Developer"
  end

  if "linux" == _OPTIONS.gcc then
    location (ROOT_PATH .. "/build/" .. _ACTION .. "-linux")
  end

  OUT_PATH = (ROOT_PATH .. "/out/" .. _OPTIONS.gcc)
elseif nil ~= _OPTIONS.os then
  OUT_PATH = (ROOT_PATH .. "/out/" .. _OPTIONS.os)
end

