#include <iostream>
using namespace std;
int main() {
    int celcius;
    cout << "Nhap so do C: ";
    cin >> celcius;
    int fahr;
    fahr = celcius * 1.8 + 32;
    cout << celcius << " Do C chuyen sang do F se la " << fahr << " Do F" << endl;
}