# Rough template for a find module for a header-only library.
#
# Author: Andy Mroczkowski (@amrox)
# Adapted from:
#  - https://bastian.rieck.me/blog/posts/2018/cmake_tips/
#  - https://pabloariasal.github.io/2018/02/19/its-time-to-do-cmake-right/
#
# Usage:
# 
# Somewhere in your CMakelists.txt:
#
# `find_package(MyLibrary)`
#
# In targets that use this library:
#
# `target_link_libraries(MyTarget MyLibrary::MyLibrary)`
#

include(FindPackageHandleStandardArgs)

mark_as_advanced(MyLibrary_FOUND MyLibrary_INCLUDE_DIR)

find_path(
	# Set to a path to a "sentinel header" for the library
  MyLibrary_INCLUDE_DIR mylibrary/mylibrary.hpp
)

# All variables should match the first argument passed to
# find_package_handle_standard_args (including case), 
# meaning it should not # b `MYLIBRARY_INCLUDE_DIR`.
find_package_handle_standard_args(MyLibrary
  DEFAULT_MSG MyLibrary_INCLUDE_DIR
)

if(MyLibrary_FOUND)
  set(MyLibrary_INCLUDE_DIRS ${MyLibrary_INCLUDE_DIR})
endif()

# Important to check the NOT TARGET condition to avoid adding
# duplicate targets.
if(MyLibrary_FOUND AND NOT TARGET MyLibrary::MyLibrary)

  set(MyLibrary_INCLUDE_DIRS ${MyLibrary_INCLUDE_DIR})

  add_library(MyLibrary::MyLibrary INTERFACE IMPORTED)
  set_target_properties(MyLibrary::MyLibrary PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "${MyLibrary_INCLUDE_DIR}"
  )
  
  # Extra: Header-only libraries require a C++ version
  # Set the required C++ standard to 14 (introduced in CMake 3.11)
  if(NOT ${CMAKE_VERSION} VERSION_LESS "3.11.0") 
    target_compile_features(MyLibrary::MyLibrary INTERFACE cxx_std_14)
  endif()
endif()

