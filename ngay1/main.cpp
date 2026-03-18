#include <iostream>
#include <limits>     // std::numeric_limits
#include <iomanip>    // std::setprecision
#include <typeinfo>    // typeid

int main() {
    // ===== 1. bool =====
    bool b1 = true;       // khởi tạo bằng '='
    bool b2{ false };     // khởi tạo bằng '{}' (tránh narrowing)

    std::cout << std::boolalpha; // in true/false thay vì 1/0
    std::cout << "[bool] b1=" << b1 << ", b2=" << b2 << '\n';

    // ===== 2. char =====
    char c1 = 'A';
    char c2{ 97 };        // 97 là 'a' theo ASCII
    char newline = '\n';  // escape character

    std::cout << "[char] c1=" << c1 << ", c2=" << c2;
    std::cout << ", newline prints a new line here ->" << newline;

    // ===== 3. Số nguyên với kích thước và signed/unsigned =====
    short s{ -123 };              // >= 16-bit
    unsigned short us{ 65535u };  // phạm vi không âm
    int i = -1000;                // thường 32-bit
    unsigned int ui{ 4000000000u };
    long l = 1'000'000L;          // dấu ' tách hàng nghìn (C++14+)
    long long ll{ 9'223'372'036'854'775'807LL }; // tối thiểu 64-bit

    std::cout << "[integer] s=" << s
              << ", us=" << us
              << ", i=" << i
              << ", ui=" << ui
              << ", l=" << l
              << ", ll=" << ll << '\n';

    // Literal cơ số 8/16/2
    int dec = 26;           // thập phân
    int oct = 032;          // bát phân (tiền tố 0) = 26
    int hex = 0x1A;         // thập lục phân = 26
    int bin = 0b11010;      // nhị phân (C++14) = 26

    std::cout << "[literals int] dec=" << dec
              << ", oct=" << oct
              << ", hex=" << hex
              << ", bin=" << bin << '\n';

    // ===== 4. Số thực (floating-point) =====
    float f = 3.1415926f;            // hậu tố f
    double d{ 2.718281828 };         // mặc định double
    long double ld = 1.61803398875L; // hậu tố L cho long double
    double sci = 6.022e23;           // ký pháp khoa học

    std::cout << std::setprecision(10);
    std::cout << "[float] f=" << f
              << ", d=" << d
              << ", ld=" << ld
              << ", sci=" << sci << '\n';

    // ===== 5. Khởi tạo: =  vs  {}  =====
    // Dùng '{}' để tránh thu hẹp (narrowing) không chủ ý:
    int ok1{ 123 };        // OK
    // int bad{ 3.14 };    // LỖI: narrowing (giảm độ chính xác) -> hãy bật thử để thấy lỗi compile
    int ok2 = 3.14;        // HỢP LỆ nhưng bị cắt phần thập phân -> ok2 == 3

    std::cout << "[init] ok1=" << ok1 << ", ok2=" << ok2 << '\n';

    // ===== 6. sizeof & giới hạn kiểu =====
    std::cout << "[sizeof] bool=" << sizeof(bool)
              << ", char=" << sizeof(char)
              << ", int=" << sizeof(int)
              << ", long=" << sizeof(long)
              << ", long long=" << sizeof(long long)
              << ", float=" << sizeof(float)
              << ", double=" << sizeof(double)
              << ", long double=" << sizeof(long double) << '\n';

    std::cout << "[limits] int min=" << std::numeric_limits<int>::min()
              << ", max=" << std::numeric_limits<int>::max() << '\n';
    std::cout << "[limits] double min=" << std::numeric_limits<double>::lowest()
              << ", max=" << std::numeric_limits<double>::max() << '\n';

    // ===== 7. void trong hàm =====
    auto twice = [](int x) -> int { return x * 2; };
    auto printVoid = [](int x) -> void { std::cout << "[void fn] x=" << x << '\n'; };

    std::cout << "[twice] " << twice(21) << '\n';
    printVoid(42);

    return 0;
}