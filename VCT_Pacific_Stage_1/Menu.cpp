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
#include <algorithm>
void Menu::hienThiMenu() {
    std::cout << "\n===== HE THONG BAN VE VCT PACIFIC STAGE 1 =====\n";
    std::cout << "1. Mua ve Tier B\n";
    std::cout << "2. Mua ve Tier A\n";
    std::cout << "3. Mua ve Tier S\n";
    std::cout << "4. Mua ve 3-Day Pass (Tier S)\n";
    std::cout << "5. Hoan ve\n";
    std::cout << "0. Ket thuc\n";
    std::cout << "===============================================\n";
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
            std::cout << "Nhap ngay 15/05/2026, 16/05/2026 hoac 17/05/2026: ";
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

            case 5: {   // ===== HOAN VE =====
                if (kh.getSoLuongVe() == 0) {
                    std::cout << "[INFO] Khach hang khong co ve nao de hoan!\n";
                    thanhCong = true;
                    break;
                }

                kh.hienThiThongTin();

                int luaChonHoan;
                std::cout << "1. Hoan 1 ve\n";
                std::cout << "2. Hoan nhieu ve\n";
                std::cout << "Lua chon: ";
                std::cin >> luaChonHoan;

                if (luaChonHoan == 1) {
                    size_t idx;
                    std::cout << "Nhap so thu tu ve muon hoan: ";
                    std::cin >> idx;

                    if (kh.hoanVe(idx - 1))
                        std::cout << "[OK] Hoan ve thanh cong!\n";
                    else
                        std::cout << "[ERROR] Ve khong hop le!\n";
                }

                else if (luaChonHoan == 2) {
                    int soLuong;
                    std::cout << "Nhap so luong ve muon hoan: ";
                    std::cin >> soLuong;

                    std::vector<size_t> dsIndex;

                    for (int i = 0; i < soLuong; ++i) {
                        size_t idx;
                        std::cout << "Nhap so thu tu ve thu " << i + 1 << ": ";
                        std::cin >> idx;

                        // Chuyen sang index 0-based
                        dsIndex.push_back(idx - 1);
                    }

                    // Sap xep giam dan
                    std::sort(dsIndex.rbegin(), dsIndex.rend());

                    bool loi = false;
                    for (size_t index : dsIndex) {
                        if (!kh.hoanVe(index)) {
                            std::cout << "[ERROR] Hoan ve that bai tai ve so "
                                      << index + 1 << "!\n";
                            loi = true;
                            break;
                        }
                    }

                    if (!loi) {
                        std::cout << "[OK] Da hoan ve theo yeu cau!\n";
                        kh.hienThiThongTin();
                    }
                }

                else {
                    std::cout << "[ERROR] Lua chon khong hop le!\n";
                }

                break;
            }
            default:
                std::cout << "[ERROR] Lua chon khong hop le!\n";
                continue;
        }
        if (!thanhCong && choice >= 1 && choice <= 4) {
            std::cout << "[ERROR] Da dat gioi han toi da 4 ve!\n";
            std::cout << "Tu dong ket thuc qua trinh mua ve do da dat den gioi han mua.\n";
            break; // <-- DÒNG QUAN TRỌNG
        }
        if (thanhCong && choice >= 1 && choice <= 4) {
            std::cout << "[OK] Mua ve thanh cong!\n";
        }


    } while (true);
    std::cout << std::fixed << std::setprecision(0);
    std::cout << "Tong tien phai thanh toan: "
              << formatTien(kh.tongTien())
              << " VND\n";

}