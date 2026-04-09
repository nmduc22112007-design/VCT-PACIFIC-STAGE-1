cmake_minimum_required(VERSION 4.1)
project(VCT_Pacific_Stage_1)

set(CMAKE_CXX_STANDARD 20)

add_executable(VCT_Pacific_Stage_1 main.cpp
        Menu.cpp
        Menu.h
        Entity.cpp
        Entity.h
        Ve.cpp
        Ve.h
        TierB.cpp
        TierB.h
        TierA.cpp
        TierA.h
        TierS.cpp
        TierS.h
        ThreeDayPass.cpp
        ThreeDayPass.h
        KhachHang.cpp
        KhachHang.h
        TickerManager.cpp
        TickerManager.h
        Utils.cpp
        Utils.h)
