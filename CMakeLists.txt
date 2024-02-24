# - CMake Message Colors
if(NOT WIN32)
    string(ASCII 27 Esc)
    set(TAB           "   ")
    set(RESET         "${Esc}[m")
    set(GREEN         "${Esc}[38;2;0;255;0m")
    set(RED           "${Esc}[38;2;255;0;0m")
    set(SUCCESS       "${TAB}${GREEN}[SUCCESS]${RESET}")
    set(FAILED        "${TAB}${RED}[FAILED]${RESET}")
    set(BLUE          "${Esc}[38;2;106;140;150m")
    set(CYAN          "${Esc}[38;2;0;255;255m")
    set(LIGHT         "${Esc}[38;2;170;170;170m")
    set(TEXT          "${BLUE}")
    set(RKACPB           "${CYAN}[RKACPB]${TEXT}")
  endif()

# - Specify CMake Version
cmake_minimum_required(VERSION 3.10)

# - Project Name
message("${RKACPB} Initializing Project ...${RESET}")
project(run)
message("${RKACPB} Set Project Name to ${LIGHT}${PROJECT_NAME}${RESET}")

# - Set C++ Standard
set(CMAKE_CXX_STANDARD 11)

# - Find Requiered Packages
if (DEFINED _USE_PACKAGES)
    foreach(UserPackage ${_USE_PACKAGES})
        message("${RKACPB} Finding Package ${LIGHT}${UserPackage}${RESET} ...${RESET}")
        find_package(${UserPackage} REQUIRED)
        message("${TAB}${SUCCESS} Package ${LIGHT}${UserPackage}${RESET} has been Found${RESET}")
    endforeach()
else()
    message("${RKACPB} No Additional Package Given${RESET}")
endif()

# - Add Source Files
if (DEFINED _SRC)
    foreach(SOURCE_FILE ${_SRC})
        message("${RKACPB} Checking Input Source ${LIGHT}${SOURCE_FILE}${RESET}")
        if (EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/${SOURCE_FILE}")
            message("${SUCCESS} Found Source File ${LIGHT}${SOURCE_FILE}${RESET}")
        else()
            message("${FAILED} Source File ${LIGHT}${SOURCE_FILE}${RESET} ${RESET} Not Found")
        endif()
    endforeach()
else()
    message("${RKACPB} Checking Source File ...${RESET}")
    message("${FAILED} No Selected Source File ...${RESET}")
endif()