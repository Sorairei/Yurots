cmake_minimum_required(VERSION 3.15)
project(YurOTS VERSION 0.9.4 LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS ON)

# Output binary directly to root directory
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR})

# Sources list
set(YUROTS_SOURCES
    source/aac.cpp
    source/account.cpp
    source/actions.cpp
    source/allocator.cpp
    source/chat.cpp
    source/commands.cpp
    source/container.cpp
    source/creature.cpp
    source/exception.cpp
    source/fileloader.cpp
    source/game.cpp
    source/guilds.cpp
    source/houses.cpp
    source/ioaccount.cpp
    source/ioaccountxml.cpp
    source/iomapbin.cpp
    source/iomapotbm.cpp
    source/iomapxml.cpp
    source/ioplayer.cpp
    source/ioplayerxml.cpp
    source/item.cpp
    source/itemloader.cpp
    source/items.cpp
    source/logger.cpp
    source/loginqueue.cpp
    source/luascript.cpp
    source/magic.cpp
    source/map.cpp
    source/md5.cpp
    source/monster.cpp
    source/monsters.cpp
    source/networkmessage.cpp
    source/npc.cpp
    source/otserv.cpp
    source/player.cpp
    source/position.cpp
    source/protocol.cpp
    source/protocol76.cpp
    source/pvparena.cpp
    source/readables.cpp
    source/scheduler.cpp
    source/spawn.cpp
    source/spells.cpp
    source/status.cpp
    source/summons.cpp
    source/thing.cpp
    source/tile.cpp
    source/tools.cpp
)

add_executable(yurots ${YUROTS_SOURCES})

# Target Include Directories
target_include_directories(yurots PRIVATE
    ${CMAKE_SOURCE_DIR}/source
    ${CMAKE_SOURCE_DIR}
    /usr/local/include
    /usr/include/libxml2
)

# Feature & Engine Preprocessor Definitions
target_compile_definitions(yurots PRIVATE
    BOOST_BIND_GLOBAL_PLACEHOLDERS
    TLM_BUY_SELL
    TLM_SERVER_SAVE
    TLM_HOUSE_SYSTEM
    BDB_UTEVO_LUX
    WOLV_LOAD_NPC
    BD_HOUSE_WINDOW
    TR_ANTI_AFK
    ELEM_VIP_LIST
    TR_SUMMONS
    TRS_GM_INVISIBLE
    TLM_SKULLS_PARTY
    BRN_EXIVA
    SD_BURST_ARROW
    BDB_REPLACE_SPEARS
    BD_ITEM_LOOK
    SM_RELOAD_CONFIG
    JD_DEATH_LIST
    CT_EXANI_TERA
    CVS_DAY_CYCLE
    TJ_MONSTER_BLOOD
    JD_WANDS
    __DEBUG_PLAYERS__
    YUR_CVS_MODS
    YUR_ICE_RAPIER
    YUR_AOL
    YUR_LOGIN_QUEUE
    YUR_MULTIPLIERS
    YUR_BOH
    YUR_NPC_EXT
    YUR_GUILD_SYSTEM
    YUR_CMD_EXT
    YUR_ITEM_EXT
    YUR_ACT_EXT
    YUR_NO_MONSTER_HEAL
    YUR_PVP_ARENA
    YUR_RINGS_AMULETS
    YUR_CONFIG_CAP
    YUR_FIGHT_MODE
    YUR_READABLES
    YUR_LEARN_SPELLS
    YUR_HEAL_EXHAUST
    YUR_SHUTDOWN
    YUR_ROOKGARD
    YUR_LIGHT_ITEM
    YUR_CLEAN_MAP
    YUR_GM_LOOK
    YUR_HIGH_LEVELS
    YUR_PREMIUM_PROMOTION
    YUR_INVISIBLE
    YUR_DRAINS
    YUR_BUILTIN_AAC
)

# Platform-specific configurations
if(WIN32)
    target_compile_definitions(yurots PRIVATE WIN32 _CONSOLE)
    target_link_libraries(yurots PRIVATE ws2_32 wsock32)
    if(MSVC)
        target_compile_options(yurots PRIVATE /W3 /O2)
    else()
        target_compile_options(yurots PRIVATE -O2 -w -fpermissive)
    endif()
else()
    target_compile_options(yurots PRIVATE -O2 -w -fpermissive)
    find_package(Threads REQUIRED)
    target_link_libraries(yurots PRIVATE Threads::Threads)
endif()

# Dependencies
find_package(LibXml2 QUIET)
if(LibXml2_FOUND)
    target_link_libraries(yurots PRIVATE LibXml2::LibXml2)
else()
    target_link_libraries(yurots PRIVATE xml2)
endif()

find_package(Boost QUIET COMPONENTS regex system)
if(Boost_FOUND)
    target_link_libraries(yurots PRIVATE Boost::regex Boost::system)
else()
    target_link_libraries(yurots PRIVATE boost_regex boost_system)
endif()

# Lua 5.0 libraries
target_link_libraries(yurots PRIVATE lua lualib)
