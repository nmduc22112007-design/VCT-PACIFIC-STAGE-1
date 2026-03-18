#include <iostream>
#include <vector>
using namespace std;
//using bubble sort:
    void bubbleSort(int a[], int n) {
        for (int i = 0; i < n-1; i++) {
            //step i
            for (int j = 0; j < n-1-i; j++) {
                if (a[j] > a[j+1]) {
                    int tg = a[j];
                    a[j] = a[j+1];
                    a[j+1] = tg;
                }
            }
        }
    }
    //using vector:
    void bubbleSort(vector<int> & a) {
        for (int i = 0; i < a.size() -1-i; i++) {
            // step i
            for (int j = 0; j < a.size() -1-i;j++) {
                if (a[j] > a [j+1]) {
                    int temp = a[j];
                    a[j] = a[j+1];
                    a[j+1] = temp;
                }
            }
        }
    }
