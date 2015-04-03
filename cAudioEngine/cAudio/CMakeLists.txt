PROJECT(cAudio)
	
if(CAUDIO_STATIC)
	ADD_DEFINITIONS(-DCAUDIO_STATIC_LIB)
endif()
if(BUILD_ON_ANDROID)
    add_definitions(-DANDROID)
endif()
# generate cAudioBuildSettings.h 
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/../CMake/Templates/cAudioBuildSettings.h.in ${CMAKE_BINARY_DIR}/include/cAudioBuildSettings.h @ONLY)
install(FILES ${CMAKE_BINARY_DIR}/include/cAudioBuildSettings.h DESTINATION include/cAudio)
INSTALL(DIRECTORY include/ DESTINATION include/cAudio FILES_MATCHING PATTERN "*.h")

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_SOURCE_DIR})
set(CAUDIO_INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/include ${CMAKE_BINARY_DIR}/include PARENT_SCOPE)

include(cAudio_src_files.cmake)		
add_library(cAudio ${CAUDIO_LIB_TYPE} ${file_root})

if(CAUDIO_ENABLE_OGG)
	include_directories (include Headers ${CMAKE_BINARY_DIR}/include ${OPENAL_INCLUDE_DIRS} ${OGG_INCLUDE_DIR} ${VORBIS_INCLUDE_DIR})
	target_link_libraries(cAudio Vorbis Ogg ${OPENAL_LIBRARIES})
	add_dependencies(cAudio Vorbis Ogg)
else()
	include_directories (include Headers ${CMAKE_BINARY_DIR}/include ${OPENAL_INCLUDE_DIRS})
	target_link_libraries(cAudio ${OPENAL_LIBRARIES})
endif()

if (APPLE AND CAUDIO_IOS_BUILD)
	set_target_properties(cAudio PROPERTIES XCODE_ATTRIBUTE_GCC_THUMB_SUPPORT "NO")
	set_target_properties(cAudio PROPERTIES XCODE_ATTRIBUTE_GCC_UNROLL_LOOPS "YES")
	set_target_properties(cAudio PROPERTIES XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY "iPhone Developer")
endif()

install_all_targets(cAudio)

####################################################
# ParaEngine related 
# ParaEngineClient_SOURCE_DIR can be used to specify a single base
# folder where the required dependencies may be found.

set(ParaEngineClient_SOURCE_DIR ${PARAENGINE_ROOT}/Mobile/trunk/ParaCraftMobile/frameworks/runtime-src/Classes CACHE PATH "Path to ParaEngine Src")
include_directories("${ParaEngineClient_SOURCE_DIR}")
include_directories("${ParaEngineClient_SOURCE_DIR}/Core")
include_directories("${ParaEngineClient_SOURCE_DIR}/NPL")
include_directories("${PROJECT_SOURCE_DIR}/../Plugins/mp3Decoder/include/")

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