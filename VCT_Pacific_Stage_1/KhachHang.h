//
// Created by PC on 4/9/2026.
//

#ifndef VCT_PACIFIC_STAGE_1_KHACHHANG_H
#define VCT_PACIFIC_STAGE_1_KHACHHANG_H

#include <vector>
#include <memory>
#include "Ve.h"

class KhachHang {
private:
    std::string ten;
    std::vector<std::shared_ptr<Ve>> danhSachVe;

public:
    KhachHang(std::string t);
    ~KhachHang();

    KhachHang(const KhachHang&);
    KhachHang& operator=(const KhachHang&);
    KhachHang(KhachHang&&) noexcept;
    KhachHang& operator=(KhachHang&&) noexcept;

    bool themVe(std::shared_ptr<Ve> ve);
    double tongTien() const;

    std::string getTen() const;
    void hienThiThongTin() const;

};



#endif //VCT_PACIFIC_STAGE_1_KHACHHANG_H