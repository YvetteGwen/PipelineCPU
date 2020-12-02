#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <iostream>

using std::string;
string s;

int main() {
    freopen("input.txt", "r", stdin);
    freopen("output.txt", "w", stdout);
    int cnt = 0;
    while (std::cin >> s) {
        for (int i = 0; i <= 9; i += 3)
            std::cout << "imem[" << cnt++ << "] = \'h" << s[i] << s[i + 1]
                      << "; ";
        std::cout << std::endl;
    }
    return 0;
}