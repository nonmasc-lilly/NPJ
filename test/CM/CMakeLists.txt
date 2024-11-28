cmake_minimum_required(VERSION 3.21)
project(
	"project_name"
	DESCRIPTION "project_description"
	VERSION 0.1
	LANGUAGES C
)
add_executable(
	main
	src/main.c
)
set_property(
	TARGET main
	PROPERTY C_STANDARD 90
)
