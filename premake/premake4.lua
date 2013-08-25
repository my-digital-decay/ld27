--------------------------------------------------------------------------------
--- file: premake.lua
--- ld27 build
---

--ORANGE_PATH = "../../orange"
MOAI_PATH = "../moai"
ROOT_PATH = ".."
DEV_PATH = ""
OUT_PATH = (ROOT_PATH .. "/out/")

LIBMOAI_DEFINES = {
  "FT2_BUILD_LIBRARY",
  "USE_UNTZ",
}

LIBMOAI_DEBUG_DEFINES = {
  "FT_DEBUG_LEVEL_ERROR",
  "FT_DEBUG_LEVEL_TRACE",
}

LIBMOAI_RELEASE_DEFINES = {
}

--------------------------------------------------------------------------------
solution "ld27"
  configurations { "debug", "release" }

  --- custom options
  dofile "option-gcc.lua"

  objdir (OUT_PATH .. "/obj")

  flags {
    "StaticRuntime",
    "NoMinimalRebuild",
    "NoPCH",
--    "NativeWChar",
    "NoRTTI",
    "NoExceptions",
    "NoEditAndContinue",
--    "FloatFast",
  }

  --- clean configuration to start
  configuration {}
    defines {
      "HAVE_MEMMOVE",
      "TIXML_USE_STL",
      "XML_STATIC",
      "SQLITE_ENABLE_COLUMN_METADATA",
      "SQLITE_ENABLE_FTS3",
      "SQLITE_ENABLE_FTS3_PARENTHESIS",
    }
    buildoptions {
      "-nostdinc",
    }
    linkoptions {
      "-nodefaultlibs",
    }

  configuration "debug"
    defines {
      "_DEBUG",
      "DEBUG",
    }
    flags {
      "Symbols",
    }

  configuration "release"
    defines {
      "_RELEASE",
      "NDEBUG",
    }
    flags {
      "OptimizeSpeed",
 --     "Symbols",
    }

  configuration "osx"
    flags {
      "EnableSSE2"
    }
    defines {
      "MACOSX",
      "DARWIN_NO_CARBON",
      "POSIX",
--      "L_ENDIAN",
    }
    buildoptions {
      "-F\"" .. DEV_PATH .. "/SDKs/MacOSX10.7.sdk/System/Library/Frameworks\"",
      "-I\"" .. DEV_PATH .. "/SDKs/MacOSX10.7.sdk/usr/include\"",
      "-I\"" .. DEV_PATH .. "/SDKs/MacOSX10.7.sdk/usr/include/c++/4.2.1\"",
      "-I/usr/llvm-gcc-4.2/lib/gcc/i686-apple-darwin11/4.2.1/include",
    }
    linkoptions {
      "-F\"" .. DEV_PATH .. "/SDKs/MacOSX10.7.sdk/System/Library/Frameworks\"",
      "-L\"" .. DEV_PATH .. "/SDKs/MacOSX10.7.sdk/usr/lib\"",
    }

  configuration "linux"
    flags {
      "EnableSSE2"
    }
    defines {
      "LINUX",
--      "L_ENDIAN",
      "POSIX",
--      "__SDL__",
    }

  ------------------------------------------------------------------------------
  --- @section MOAI Libs

  dofile (MOAI_PATH .. "/premake/libmoai-3rdparty.lua")
  dofile (MOAI_PATH .. "/premake/libmoai-core.lua")
  dofile (MOAI_PATH .. "/premake/libmoai-sim.lua")
  dofile (MOAI_PATH .. "/premake/libmoai-untz.lua") -- sound
  dofile (MOAI_PATH .. "/premake/libmoai-util.lua")

  ------------------------------------------------------------------------------
  --- @section ZL

  dofile (MOAI_PATH .. "/premake/libzl-gfx.lua")
  dofile (MOAI_PATH .. "/premake/libzl-util.lua")
  dofile (MOAI_PATH .. "/premake/libzl-vfs.lua")

  ------------------------------------------------------------------------------
  --- @section ld27 

  project "ld27"
    kind "ConsoleApp"
    language "C++"
    defines {
      "GLFW_INCLUDE_NONE",
    }
    files {
      ROOT_PATH .. "/src/*.cpp",
    }
    includedirs {
      MOAI_PATH .. "/src",
      MOAI_PATH .. "/src/config",
      MOAI_PATH .. "/3rdparty/glfw-2.7.8/include",
      ROOT_PATH .. "/src",
    }
    links {
      "libmoai-core",
      "libmoai-util",
      "libmoai-3rdparty",
      "libmoai-untz", -- sound
      "libmoai-sim",
      "libzl-gfx",
      "libzl-util",
      "libzl-vfs",
    }

    --- cross-platform configuration specific settings
    debug_cfg = configuration "debug"
      targetname "ld27-d"
      targetdir (OUT_PATH .. "/debug")

    release_cfg = configuration "release"
      targetname "ld27"
      targetdir (OUT_PATH .. "/release")

    --- platform specific settings
    --- osx
    configuration "osx"
      linkoptions {
        "-framework AudioToolbox", -- Untz
        "-framework AudioUnit", -- Untz
        "-framework CoreFoundation",
        "-framework Cocoa",
        "-framework IOKit",
        "-framework OpenGL",
        "../../moai/3rdparty/glfw-2.7.8/lib/cocoa/libglfw.a",
        "-lstdc++",
        "-lc",
      }
    prebuildcommands {
      "@cd ../../moai/3rdparty/glfw-2.7.8/lib/cocoa && $(MAKE) -f Makefile.cocoa libglfw.a"
    }

    configuration { "osx", "debug" }
      postbuildcommands {
        "@mkdir ../../bin 2>/dev/null; true",
        "@mkdir ../../bin/osx 2>/dev/null; true",
        "@cp " .. debug_cfg.targetdir .. "/ld27-d ../../bin/osx/",
      }

    configuration { "osx", "release" }
      postbuildcommands {
        "@mkdir ../../bin 2>/dev/null; true",
        "@mkdir ../../bin/osx 2>/dev/null; true",
        "@cp " .. release_cfg.targetdir .. "/ld27 ../../bin/osx/",
      }

    --- linux
    configuration "linux"
      linkoptions {
        "-L/usr/lib/i386-linux-gnu",
        "-lSDL",
        "-lSDL_sound",
        MOAI_PATH .. "/3rdparty/glfw-2.7.8/lib/xxx/libglfw.a",
        "-lstdc++",
        "-lc",
      }

    configuration { "linux", "debug" }
      postbuildcommands {
        "@mkdir ../../bin 2>/dev/null; true",
        "@mkdir ../../bin/linux 2>/dev/null; true",
        "@cp " .. release_cfg.targetdir .. "/ld27-d ../../bin/linux/"
      }

    configuration { "linux", "release" }
      postbuildcommands {
        "@mkdir ../../bin 2>/dev/null; true",
        "@mkdir ../../bin/linux 2>/dev/null; true",
        "@cp " .. release_cfg.targetdir .. "/ld27 ../../bin/linux/"
      }

  ------------------------------------------------------------------------------

