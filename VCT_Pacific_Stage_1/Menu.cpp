//
// Created by PC on 4/9/2026.
//

#include "Menu.h"
#include <iostream>
#include "TierB.h"
#include "TierA.h"
#include "TierS.h"
#include "ThreeDayPass.h"
#include <iomanip>
#include "Utils.h"
void Menu::hienThiMenu() {
    std::cout << "\n===== HE THONG BAN VE VCT PACIFIC STAGE 1 =====\n";
    std::cout << "1. Mua ve Tier B\n";
    std::cout << "2. Mua ve Tier A\n";
    std::cout << "3. Mua ve Tier S\n";
    std::cout << "4. Mua ve 3-Day Pass (Tier S)\n";
    std::cout << "5. Hoan ve\n";
    std::cout << "0. Ket thuc\n";
    std::cout << "============================================\n";
}


void Menu::xuLyMuaVe(KhachHang& kh) {
    int choice;

    do {
        hienThiMenu();
        std::cout << "Lua chon cua ban: ";
        std::cin >> choice;

        if (choice == 0) break;

        std::string ngay;
        if (choice >= 1 && choice <= 3) {
            std::cout << "Nhap ngay 15/05/2026, 16/05/2026 hoac 17/05/2026 (co the chon 1, 2, 3 tuong ung voi 3 ngay 15, 16, 17): ";
            std::cin >> ngay;
        }

        bool thanhCong = true;

        switch (choice) {
            case 1:
                thanhCong = kh.themVe(std::make_shared<TierB>(ngay));
                break;
            case 2:
                thanhCong = kh.themVe(std::make_shared<TierA>(ngay));
                break;
            case 3:
                thanhCong = kh.themVe(std::make_shared<TierS>(ngay));
                break;
            case 4:
                thanhCong = kh.themVe(std::make_shared<ThreeDayPass>());
                break;
            default:
                std::cout << "[ERROR] Lua chon khong hop le!\n";
                continue;
        }
        if (!thanhCong) {
            std::cout << "[ERROR] Da dat gioi han toi da 4 ve!\n";
            std::cout << "Tu dong ket thuc qua trinh mua ve do da dat den gioi han mua.\n";
            break; // <-- DÒNG QUAN TRỌNG
        }
        else {
            std::cout << "[OK] Mua ve thanh cong!\n";
        }


    } while (true);
    std::cout << std::fixed << std::setprecision(0);
    std::cout << "Tong tien phai thanh toan: "
              << formatTien(kh.tongTien())
              << " VND\n";

}

