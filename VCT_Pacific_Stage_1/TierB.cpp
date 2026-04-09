//
// Created by PC on 4/9/2026.
//

#include "TierB.h"

TierB::TierB(std::string ngay)
    : Ve(ngay, 399000) {}

double TierB::tinhHeSoGia() const {
    return 1.0;
}
