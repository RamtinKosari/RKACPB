# - CMake Message Colors
if(NOT WIN32)
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
        message("${RKACPB} Finding Package ${LIGHT}${UserPackage}${TEXT} ...${RESET}")
        find_package(${UserPackage} REQUIRED)
        message("${SUCCESS} Package ${LIGHT}${UserPackage}${TEXT} has been Found${RESET}")
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
            message("${FAILED} Source File ${LIGHT}${SOURCE_FILE}${TEXT} Not Found${RESET}")
            return()
        endif()
    endforeach()
else()
    message("${RKACPB} Checking Source File ...${RESET}")
    message("${FAILED} No Selected Source File ...${RESET}")
    return()
endif()

# - Add Executable
add_executable(${PROJECT_NAME} ${_SRC})

# - Link the Libraries in _USE_PACKAGES
if (DEFINED _USE_PACKAGES)
message("${RKACPB} Linking Packages ...${RESET}")
    foreach(UserPackage ${_USE_PACKAGES})
        target_link_libraries(${PROJECT_NAME} PRIVATE ${UserPackage})
        message("${SUCCESS} Package ${LIGHT}${UserPackage}${TEXT} has been Linked to Target${RESET}")
    endforeach()
endif()
