//
// Created by PC on 4/9/2026.
//

#include "TierS.h"

TierS::TierS(std::string ngay)
    : Ve(ngay, 1299000) {}

double TierS::tinhHeSoGia() const {
    return 3.26;
}
