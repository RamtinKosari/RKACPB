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
    set(SUCCESS       "${TAB}${GREEN}[SUCCESS]${TEXT}")
    set(FAILED        "${TAB}${RED}[FAILED]${TEXT}")
    set(RKACPB           "${CYAN}[RKACPB]${TEXT}")
  endif ()

# - Specify CMake Version
cmake_minimum_required(VERSION 3.10)

# - Project Name
message("${RKACPB} Initializing Project ...${RESET}")
project(run)
message("${RKACPB} Set Project Name to ${LIGHT}${PROJECT_NAME}${RESET}")

# - Check Operating System
message("${RKACPB} Operating System Name : ${LIGHT}${CMAKE_SYSTEM_NAME}${RESET}")
if (CMAKE_SYSTEM_NAME STREQUAL "Linux" OR CMAKE_SYSTEM_NAME STREQUAL "Darwin")
    message("${SUCCESS} Valid Operating System${RESET}")
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
# message("${RKACPB} Operating System : ${LIGHT}${PROCE}${RESET}")
# message("${RKACPB} Operating System : ${LIGHT}${CMAKE_}${RESET}")

# - Set C++ Standard
set(CMAKE_CXX_STANDARD 11)

# - Find Requiered Packages
if (DEFINED _USE_PACKAGES)
    foreach(UserPackage ${_USE_PACKAGES})
        message("${RKACPB} Finding Package ${LIGHT}${UserPackage}${TEXT} ...${RESET}")
        find_package(${UserPackage} REQUIRED)
        message("${SUCCESS} Package ${LIGHT}${UserPackage}${TEXT} has been Found${RESET}")
    endforeach()
else ()
    message("${RKACPB} No Additional Package Given${RESET}")
endif ()

# - Add Source Files
if (DEFINED _SRC)
    foreach(SOURCE_FILE ${_SRC})
        message("${RKACPB} Checking Input Source ${LIGHT}${SOURCE_FILE}${RESET}")
        if (EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/${SOURCE_FILE}")
            message("${SUCCESS} Found Source File ${LIGHT}${SOURCE_FILE}${RESET}")
        else ()
            message("${FAILED} Source File ${LIGHT}${SOURCE_FILE}${TEXT} Not Found${RESET}")
            return()
        endif ()
    endforeach()
else ()
    message("${RKACPB} Checking Source File ...${RESET}")
    message("${FAILED} No Selected Source File ...${RESET}")
    return()
endif ()

# - Add Executable
add_executable(${PROJECT_NAME} ${_SRC})

# - Link the Libraries in _USE_PACKAGES
if (DEFINED _USE_PACKAGES)
message("${RKACPB} Linking Packages ...${RESET}")
    foreach(UserPackage ${_USE_PACKAGES})
        if(${UserPackage}_LIBS)
            target_link_libraries(${PROJECT_NAME} PRIVATE ${${UserPackage}_LIBS})
        elseif(${UserPackage}_LIBRARIES)
            target_link_libraries(${PROJECT_NAME} PRIVATE ${${UserPackage}_LIBRARIES})
        else()
            message(FATAL_ERROR "Library variable not found for ${UserPackage}")
        endif()
    endforeach()
endif ()

# - Define RKACPB Macro
target_compile_definitions(${PROJECT_NAME} PRIVATE RKACPB="Project Compiles Under RKACPB Support")
