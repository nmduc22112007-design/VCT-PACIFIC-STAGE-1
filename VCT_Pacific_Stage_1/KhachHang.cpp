#include "KhachHang.h"
#include <iostream>
#include <iomanip>
#include "Utils.h"
// Constructor
KhachHang::KhachHang(std::string t) : ten(t) {}

// Destructor
KhachHang::~KhachHang() {}

// Copy constructor (Rule of Five)
KhachHang::KhachHang(const KhachHang& other)
    : ten(other.ten), danhSachVe(other.danhSachVe) {}

// Copy assignment
KhachHang& KhachHang::operator=(const KhachHang& other) {
    if (this != &other) {
        ten = other.ten;
        danhSachVe = other.danhSachVe;
    }
    return *this;
}

// Move constructor
KhachHang::KhachHang(KhachHang&& other) noexcept
    : ten(std::move(other.ten)),
      danhSachVe(std::move(other.danhSachVe)) {}

// Move assignment
KhachHang& KhachHang::operator=(KhachHang&& other) noexcept {
    if (this != &other) {
        ten = std::move(other.ten);
        danhSachVe = std::move(other.danhSachVe);
    }
    return *this;
}

// Getter ten khach hang
std::string KhachHang::getTen() const {
    return ten;
}

// Them ve (toi da 4 ve)
bool KhachHang::themVe(std::shared_ptr<Ve> ve) {
    if (danhSachVe.size() >= 4)
        return false;

    danhSachVe.push_back(ve);
    return true;
}

// Tinh tong tien ve
double KhachHang::tongTien() const {
    double sum = 0;
    for (const auto& v : danhSachVe) {
        sum += v->tinhGia();
    }
    return sum;
}

// Hien thi thong tin khach hang
void KhachHang::hienThiThongTin() const {
    std::cout << "Khach hang: " << ten << "\n";
    std::cout << "So luong ve: " << danhSachVe.size() << "\n";

    for (size_t i = 0; i < danhSachVe.size(); ++i) {
        std::cout << "  Ve " << i + 1
                  << " | Ngay: " << danhSachVe[i]->getNgaySuDung()
                  << " | Gia: " << danhSachVe[i]-> tinhGia() << " VND\n";
    }
    std::cout << std::fixed << std::setprecision(0);
    std::cout << "Tong tien: " << formatTien(tongTien()) << " VND\n";
    std::cout << "-------------------------------------\n";
}
bool KhachHang::hoanVe(size_t index) {
    if (index >= danhSachVe.size())
        return false;

    danhSachVe.erase(danhSachVe.begin() + index);
    return true;
}

void KhachHang::hoanTatCaVe() {
    danhSachVe.clear();
}

bool KhachHang::daHetVe() const {
    return danhSachVe.empty();
}