CXX = g++
CXXFLAGS = -std=gnu++11 -O2 -w -fpermissive \
           -DBOOST_BIND_GLOBAL_PLACEHOLDERS \
           -I. -I/usr/local/include -I/usr/include/libxml2 \
           -DTLM_BUY_SELL \
           -DTLM_SERVER_SAVE \
           -DTLM_HOUSE_SYSTEM \
           -DBDB_UTEVO_LUX \
           -DWOLV_LOAD_NPC \
           -DBD_HOUSE_WINDOW \
           -DTR_ANTI_AFK \
           -DELEM_VIP_LIST \
           -DTR_SUMMONS \
           -DTRS_GM_INVISIBLE \
           -DTLM_SKULLS_PARTY \
           -DBRN_EXIVA \
           -DSD_BURST_ARROW \
           -DBDB_REPLACE_SPEARS \
           -DBD_ITEM_LOOK \
           -DSM_RELOAD_CONFIG \
           -DJD_DEATH_LIST \
           -DCT_EXANI_TERA \
           -DCVS_DAY_CYCLE \
           -DTJ_MONSTER_BLOOD \
           -DJD_WANDS \
           -D__DEBUG_PLAYERS__ \
           -DYUR_CVS_MODS \
           -DYUR_ICE_RAPIER \
           -DYUR_AOL \
           -DYUR_LOGIN_QUEUE \
           -DYUR_MULTIPLIERS \
           -DYUR_BOH \
           -DYUR_NPC_EXT \
           -DYUR_GUILD_SYSTEM \
           -DYUR_CMD_EXT \
           -DYUR_ITEM_EXT \
           -DYUR_ACT_EXT \
           -DYUR_NO_MONSTER_HEAL \
           -DYUR_PVP_ARENA \
           -DYUR_RINGS_AMULETS \
           -DYUR_CONFIG_CAP \
           -DYUR_FIGHT_MODE \
           -DYUR_READABLES \
           -DYUR_LEARN_SPELLS \
           -DYUR_HEAL_EXHAUST \
           -DYUR_SHUTDOWN \
           -DYUR_ROOKGARD \
           -DYUR_LIGHT_ITEM \
           -DYUR_CLEAN_MAP \
           -DYUR_GM_LOOK \
           -DYUR_HIGH_LEVELS \
           -DYUR_PREMIUM_PROMOTION \
           -DYUR_INVISIBLE \
           -DYUR_DRAINS \
           -DYUR_BUILTIN_AAC

LIBS = -L/usr/local/lib -llua -llualib -lxml2 -lboost_regex -lboost_system -lpthread

SRCS = aac.cpp \
       account.cpp \
       actions.cpp \
       allocator.cpp \
       chat.cpp \
       commands.cpp \
       container.cpp \
       creature.cpp \
       fileloader.cpp \
       game.cpp \
       guilds.cpp \
       houses.cpp \
       ioaccount.cpp \
       ioaccountxml.cpp \
       iomapbin.cpp \
       iomapotbm.cpp \
       iomapxml.cpp \
       ioplayer.cpp \
       ioplayerxml.cpp \
       item.cpp \
       itemloader.cpp \
       items.cpp \
       logger.cpp \
       loginqueue.cpp \
       luascript.cpp \
       magic.cpp \
       map.cpp \
       md5.cpp \
       monster.cpp \
       monsters.cpp \
       networkmessage.cpp \
       npc.cpp \
       otserv.cpp \
       player.cpp \
       position.cpp \
       protocol.cpp \
       protocol76.cpp \
       pvparena.cpp \
       readables.cpp \
       scheduler.cpp \
       spawn.cpp \
       spells.cpp \
       status.cpp \
       summons.cpp \
       thing.cpp \
       tile.cpp \
       tools.cpp

OBJS = $(SRCS:.cpp=.o)
TARGET = ../yurots

all: $(TARGET)

$(TARGET): $(OBJS)
	@printf "\033[1;33m[ LINK ]\033[0m \033[1;37m%s\033[0m\n" "$(TARGET)"
	@$(CXX) $(CXXFLAGS) -o $(TARGET) $(OBJS) $(LIBS)
	@printf "\033[1;32m[  OK  ]\033[0m \033[1;32mBuild completed successfully -> %s\033[0m\n" "$(TARGET)"

%.o: %.cpp
	@printf "\033[1;36m[ CXX  ]\033[0m %s\n" "$<"
	@$(CXX) $(CXXFLAGS) -c $< -o $@

clean:
	@printf "\033[1;33m[ CLEAN ]\033[0m Cleaning object files and binary...\n"
	@rm -f $(OBJS) $(TARGET)
