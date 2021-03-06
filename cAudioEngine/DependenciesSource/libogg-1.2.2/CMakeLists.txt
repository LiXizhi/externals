PROJECT(Ogg)
	
ADD_DEFINITIONS(-DLIBOGG_EXPORTS)

set (CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_SOURCE_DIR})

set(OGG_INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/include PARENT_SCOPE)

include_directories (include)
include(libogg_src_files)

add_library(Ogg STATIC ${file_root})
target_link_libraries(Ogg)

if(UNIX AND CMAKE_SIZEOF_VOID_P EQUAL 8)
	set_target_properties( Ogg PROPERTIES COMPILE_FLAGS -fPIC)
endif()

if (APPLE AND CAUDIO_IOS_BUILD)
	set_target_properties(Ogg PROPERTIES XCODE_ATTRIBUTE_GCC_THUMB_SUPPORT "NO")
	set_target_properties(Ogg PROPERTIES XCODE_ATTRIBUTE_GCC_UNROLL_LOOPS "YES")
	set_target_properties(Ogg PROPERTIES XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY "iPhone Developer")
endif()

install_all_targets(Ogg)


IF(MSVC)
	# statically link MSVC to reduce dependancies
	foreach(flag_var CMAKE_CXX_FLAGS CMAKE_CXX_FLAGS_DEBUG CMAKE_CXX_FLAGS_RELEASE CMAKE_CXX_FLAGS_MINSIZEREL CMAKE_CXX_FLAGS_RELWITHDEBINFO CMAKE_C_FLAGS CMAKE_C_FLAGS_DEBUG CMAKE_C_FLAGS_RELEASE CMAKE_C_FLAGS_MINSIZEREL CMAKE_C_FLAGS_RELWITHDEBINFO)
	 	if(${flag_var} MATCHES "/MD")
			string(REGEX REPLACE "/MD" "/MT" ${flag_var} "${${flag_var}}")
	 	endif(${flag_var} MATCHES "/MD")
	 	if(${flag_var} MATCHES "/MDd")
	 		string(REGEX REPLACE "/MDd" "/MTd" ${flag_var} "${${flag_var}}")
		endif(${flag_var} MATCHES "/MDd")
	endforeach(flag_var)
			
	# /GR- Remove RTTI to miminize the executable size
	SET(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /GR-")
	SET(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} /Zi")
ENDIF()