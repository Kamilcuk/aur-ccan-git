cmake_minimum_required (VERSION 3.0)
project(ccan)

MACRO(SUBDIRLIST result curdir)
  FILE(GLOB children RELATIVE ${curdir} ${curdir}/*)
  SET(dirlist "")
  FOREACH(child ${children})
    IF(IS_DIRECTORY ${curdir}/${child})
      LIST(APPEND dirlist ${child})
    ENDIF()
  ENDFOREACH()
  SET(${result} ${dirlist})
ENDMACRO()
SUBDIRLIST(modules ${CMAKE_SOURCE_DIR}/ccan/ccan)

set(exclude altstack jmap jset nfs ogg_to_pcm tal/talloc wwviaudio)
list(REMOVE_ITEM modules ${exclude})

add_custom_command(
	OUTPUT ccan/config.h
	COMMAND $(MAKE) -C${CMAKE_SOURCE_DIR}/ccan config.h
)
add_custom_target(ccan_config_h DEPENDS ccan/config.h)

include_directories(ccan)

foreach(module ${modules})
	file(GLOB src ccan/ccan/${module}/*.c)
	if(src)
		add_library(${module} SHARED ${src})
		add_dependencies(${module} ccan_config_h)
		install(TARGETS ${module} DESTINATION lib/ccan)
	endif() 
	file(GLOB headers ccan/ccan/${module}/*.h)
	install(FILES ${headers} DESTINATION include/ccan/${module})
endforeach()
