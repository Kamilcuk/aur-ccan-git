cmake_minimum_required (VERSION 3.0)
project(ccan)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -O2 -Wall -Wstrict-prototypes -Wold-style-definition -Wundef -Wmissing-prototypes -Wmissing-declarations -Wpointer-arith -Wwrite-strings ")
add_definitions(-DCCAN_STR_DEBUG=1)

file(GLOB_RECURSE modules_info ccan/ccan/*/_info)
set(modules "")
foreach(i ${modules_info})
	string(REGEX REPLACE "/_info$" "" i "${i}")
	string(REGEX REPLACE "^.*/ccan/ccan/" "" i "${i}")
	list(APPEND modules "${i}")
endforeach()

set(exclude altstack jmap jset nfs ogg_to_pcm tal/talloc wwviaudio)
list(REMOVE_ITEM modules ${exclude})

add_custom_command(
	OUTPUT ccan/config.h
	COMMAND $(MAKE) -C${CMAKE_SOURCE_DIR}/ccan config.h
)
add_custom_target(ccan_config_h DEPENDS ccan/config.h)

include_directories(ccan)

foreach(module ${modules})
	set(path "ccan/ccan/${module}")
	file(GLOB src ${path}/*.c)  
	if(src)
		string(REPLACE "/" "_" modulename "${module}")
		add_library(${modulename} SHARED ${src})
		add_dependencies(${modulename} ccan_config_h)
		install(TARGETS ${modulename} DESTINATION lib/ccan)
	endif() 
	file(GLOB_RECURSE headers ${path}/*.h)
	install(FILES ${headers} DESTINATION include/ccan/${module})
endforeach()
