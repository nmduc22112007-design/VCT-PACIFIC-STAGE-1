#include <iostream>
#include <string>
using namespace std;

int main() {
    string a = "Hello ";
    string b = "World!";
    string c = a + b; // Nối chuỗi
    cout << c << endl; // In ra Hello World
    cout << "Do tay chuoi c:" << c.length() << endl; // In ra độ dài của chuỗi c
    if (a == "Hello") {
        cout << "Chuoi a = Hello" << endl;
    }
    string s;
    cout << "Nhap 1 cau co dau cach:";
    getline(cin, s); // đọc dòng có khoảng trắng
    cout << "Ban vua nhap: " << s << endl;
    return 0;
}
