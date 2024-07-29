# - CMake Message Colors
if (NOT WIN32)
    string(ASCII 27 Esc)
    set(TAB           "   ")
    set(RESET         "${Esc}[m")
    set(GREEN         "${Esc}[38;2;0;255;0m")
    set(RED           "${Esc}[38;2;255;0;0m")
    set(BLUE          "${Esc}[38;2;106;140;150m")
    set(CYAN          "${Esc}[38;2;0;255;255m")
    set(LIGHT         "${Esc}[38;2;170;170;170m")
    set(TEXT          "${BLUE}")
    set(RKACPB        "${CYAN}[RKACPB]${TEXT}")
    set(SUCCESS       "${RKACPB} ${GREEN}[SUCCESS]${TEXT}")
    set(FAILED        "${RKACPB} ${RED}[FAILED]${TEXT}")
  endif ()

# - Specify CMake Version
cmake_minimum_required(VERSION 3.10)

# - Project Name
message("${RKACPB} Initializing Project ...${RESET}")
project(run)
message("${RKACPB} Set Project Name to ${LIGHT}${PROJECT_NAME}${RESET}")

# - Check Operating System
message("${RKACPB} Operating System Name : ${LIGHT}${CMAKE_SYSTEM_NAME}${RESET}")
if (CMAKE_SYSTEM_NAME STREQUAL "Linux" OR CMAKE_SYSTEM_NAME STREQUAL "Darwin" OR CMAKE_SYSTEM_NAME STREQUAL "Android")
    message("${SUCCESS} Validate Operating System${RESET}")
else ()
    message("${FAILED} Invalid Operating System${RESET}")
    return()
endif ()
message("${RKACPB} Operating System Version : ${LIGHT}${CMAKE_SYSTEM_VERSION}${RESET}")
message("${RKACPB} Operating System Processor: ${LIGHT}${CMAKE_SYSTEM_PROCESSOR}${RESET}")

# - Show Processor Model
execute_process(
    COMMAND bash -c "lscpu | grep -F 'Model name:' | awk '{for (i=3; i<=NF; i++) printf \"%s \", $i; print \"\"}'"
    OUTPUT_VARIABLE CPU_MODEL
    RESULT_VARIABLE RESULT
)
string(REGEX REPLACE "\n" "" CPU_MODEL "${CPU_MODEL}")
message("${RKACPB} Processor Model Name : ${LIGHT}${CPU_MODEL}${RESET}")

# - Show Processor Cores
include(ProcessorCount)
ProcessorCount(NPROC)
message("${RKACPB} Processor Cores : ${LIGHT}${NPROC}${RESET}")

# - Show CPU Frequency
execute_process(
    COMMAND bash -c "echo \"$(lscpu | grep -F 'CPU max MHz:' | awk '{print $4}') GHz\""
    OUTPUT_VARIABLE MAX_PROC_SPEED
    RESULT_VARIABLE RESULT
)
string(REGEX REPLACE "\n" "" MAX_PROC_SPEED "${MAX_PROC_SPEED}")
execute_process(
    COMMAND bash -c "echo \"$(lscpu | grep -F 'CPU min MHz:' | awk '{print $4}') GHz\""
    OUTPUT_VARIABLE MIN_PROC_SPEED
    RESULT_VARIABLE RESULT
)
string(REGEX REPLACE "\n" "" MIN_PROC_SPEED "${MIN_PROC_SPEED}")
execute_process(
    COMMAND bash -c "cat /proc/cpuinfo | grep 'cpu MHz' | awk '{total += $4; count++} END {print total/count}' | bc -l"
    OUTPUT_VARIABLE CURRENT_PROC_SPEED
    RESULT_VARIABLE RESULT
)
string(REGEX REPLACE "\n" " GHz" CURRENT_PROC_SPEED "${CURRENT_PROC_SPEED}")
message("${RKACPB} Processor Frequency : ${RESET}")
message("${TAB}${TEXT}Maximum ${LIGHT}${MAX_PROC_SPEED}${RESET}")
message("${TAB}${TEXT}Minimum ${LIGHT}${MIN_PROC_SPEED}${RESET}")
message("${TAB}${TEXT}Current ${LIGHT}${CURRENT_PROC_SPEED}${RESET}")

# - Show Cache Line Size
execute_process(
    COMMAND bash -c "lscpu | grep -E 'L1d cache|cache line size' | awk '{print $3}'"
    OUTPUT_VARIABLE CACHE_LINE_SIZE
    RESULT_VARIABLE RESULT
)
string(REGEX REPLACE "\n" "" CACHE_LINE_SIZE "${CACHE_LINE_SIZE}")
message("${RKACPB} Cache Line Size : ${LIGHT}${CACHE_LINE_SIZE}${RESET}")

# - Show Used Storage
execute_process(
    COMMAND bash -c "df -h | awk '/\\/$/ {print $3\" / \"$2\" Used\"}'"
    OUTPUT_VARIABLE DISK_USAGE
    RESULT_VARIABLE RESULT
)
string(REGEX REPLACE "\n" "" DISK_USAGE "${DISK_USAGE}")
execute_process(
    COMMAND bash -c "echo \"($(df -h | awk '/\\/$/ {printf \"%0.3f%\", ($3/$2) * 100}'))\""
    OUTPUT_VARIABLE DISK_USAGE_PERCENT
    RESULT_VARIABLE RESULT
)
string(REGEX REPLACE "\n" "" DISK_USAGE_PERCENT "${DISK_USAGE_PERCENT}")
message("${RKACPB} Used Storage : ${LIGHT}${DISK_USAGE} ${DISK_USAGE_PERCENT}${RESET}")

# - Set C++ Standard
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# - Find Requiered Packages
if (DEFINED _USE_PACKAGES)
    foreach(UserPackage ${_USE_PACKAGES})
        # - Handle Specific Packages
        if (UserPackage STREQUAL "OpenGL")          # - Handle OpenGL
            # - Handle Policy CMP0072
            if (POLICY CMP0072)
                cmake_policy(SET CMP0072 NEW)
            endif()
        elseif (UserPackage STREQUAL "SFML")        # - Handle SFML
            # - Handle Policy CMP0072
            find_package(SFML 2.5 COMPONENTS graphics window system REQUIRED)
            continue()
        endif()
        # - Find Package
        message("${RKACPB} Finding Package ${LIGHT}${UserPackage}${TEXT} ...${RESET}")
        find_package(${UserPackage} REQUIRED)
        message("${SUCCESS} Package ${LIGHT}${UserPackage}${TEXT} has been Found${RESET}")
    endforeach()
else ()
    message("${RKACPB} No Additional Package Given${RESET}")
endif ()

# - Add Source Files
if (DEFINED _SRC)
    set(DIRECTORY_SET)
    set(HEADER_MACROS)
    foreach(SOURCE_FILE ${_SRC})
        # - Check Source File
        if (EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/${SOURCE_FILE}")
            message("${SUCCESS} Found Source File ${LIGHT}${SOURCE_FILE}${RESET}")
            get_filename_component(DIR "${CMAKE_CURRENT_SOURCE_DIR}/${SOURCE_FILE}" DIRECTORY)
            list(APPEND DIRECTORY_SET ${DIR})
            # - Process Header Files
            if ("${SOURCE_FILE}" MATCHES "\\.(hpp|h)$")
                get_filename_component(BASENAME "${SOURCE_FILE}" NAME_WE)
                string(TOUPPER "${BASENAME}" MACRO_NAME)
                string(REPLACE " " "_" MACRO_NAME "${MACRO_NAME}")
                list(APPEND HEADER_MACROS "HAS_RKACPB_MODULE_${MACRO_NAME}")
            endif()
        else ()
            message("${FAILED} Source File ${LIGHT}${SOURCE_FILE}${TEXT} Not Found${RESET}")
            return()
        endif ()
    endforeach()
    # - Include Directories
    list(REMOVE_DUPLICATES DIRECTORY_SET)
    foreach(DIR ${DIRECTORY_SET})
        message("${SUCCESS} Including Directory ${LIGHT}${DIR}${RESET}")
        include_directories(${DIR})
    endforeach()
else ()
    message("${FAILED} No Selected Source File ...${RESET}")
    return()
endif ()

# - Add Executable
add_executable(${PROJECT_NAME} ${_SRC})

# - Define Project Modules Macros
foreach(MACRO ${HEADER_MACROS})
    target_compile_definitions(${PROJECT_NAME} PRIVATE ${MACRO})
    message("${SUCCESS} Defining Macro ${CYAN}${MACRO}${RESET}")
endforeach()

# - Link the Libraries in _USE_PACKAGES
if (DEFINED _USE_PACKAGES)
message("${RKACPB} Linking Packages ...${RESET}")
    foreach(UserPackage ${_USE_PACKAGES})
        # - Handle Default Styles
        if(${UserPackage}_LIBS)                 # - Handle LIBS
            target_link_libraries(
                ${PROJECT_NAME} PRIVATE
                ${${UserPackage}_LIBS}
            )
            continue()
        elseif(${UserPackage}_LIBRARIES)        # - Handle LIBRARIES
            target_link_libraries(
                ${PROJECT_NAME} PRIVATE
                ${${UserPackage}_LIBRARIES}
            )
            continue()
        elseif(${UserPackage}_LIB)              # - Handle LIB
            target_link_libraries(
                ${PROJECT_NAME} PRIVATE
                ${${UserPackage}_LIB}
            )
            continue()
        elseif(${UserPackage}_LIBRARY)          # - Handle LIBRARY
            target_link_libraries(
                ${PROJECT_NAME} PRIVATE
                ${${UserPackage}_LIBRARY}
            )
            continue()
        endif()
        # - Handle Specific Packages
        if (UserPackage STREQUAL "OpenGL")      # - Handle OpenGL
            target_link_libraries(
                ${PROJECT_NAME} PRIVATE
                OpenGL::GL
            )
        elseif (UserPackage STREQUAL "glfw3")   # - Handle GLFW
            target_link_libraries(
                ${PROJECT_NAME} PRIVATE
                glfw
            )
        elseif (UserPackage STREQUAL "GLEW")    # - Handle GLEW
            target_link_libraries(
                ${PROJECT_NAME} PRIVATE
                GLEW::GLEW
            )
        elseif (UserPackage STREQUAL "SFML")    # - Handle SFML
            target_link_libraries(
                ${PROJECT_NAME} PRIVATE
                sfml-graphics
                sfml-window
                sfml-system
            )
        else()
            message(FATAL_ERROR "Library variable not found for ${UserPackage}")
        endif()
    endforeach()
endif ()

# - Define RKACPB Macro
target_compile_definitions(${PROJECT_NAME} PRIVATE RKACPB="Project Compiles Under RKACPB Support")
