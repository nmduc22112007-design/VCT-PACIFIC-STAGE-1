#include <iostream>
using namespace std;

int main() {
    int N;
    int giaithua = 1;

    cout << "Nhap so nguyen N: ";
    cin >> N;

    if (N < 0) {
        cout << "Khong co giai thua cho so am!" << endl;
        return 0;
    }

    for (int i = 1; i <= N; i++) {
        giaithua *= i;
    }

    cout << "Giai thua cua " << N << " la: " << giaithua << endl;

    return 0;
}