#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <iostream>

using std::string;
string s;

string conv(char c) {
    string rs = "";
    switch (c) {
    case '0':
        rs = "0000";
        break;
    case '1':
        rs = "0001";
        break;
    case '2':
        rs = "0010";
        break;
    case '3':
        rs = "0011";
        break;
    case '4':
        rs = "0100";
        break;
    case '5':
        rs = "0101";
        break;
    case '6':
        rs = "0110";
        break;
    case '7':
        rs = "0111";
        break;
    case '8':
        rs = "1000";
        break;
    case '9':
        rs = "1001";
        break;
    case 'a':
        rs = "1010";
        break;
    case 'b':
        rs = "1011";
        break;
    case 'c':
        rs = "1100";
        break;
    case 'd':
        rs = "1101";
        break;
    case 'e':
        rs = "1110";
        break;
    case 'f':
        rs = "1111";
        break;
    }
    return rs;
}

int main() {
    freopen("input.txt", "r", stdin);
    freopen("output.txt", "w", stdout);
    int cnt = 0;
    while (std::getline(std::cin, s)) {
        std::cout << cnt++ << ": data <= 32'b" << conv(s[0]) << conv(s[1])
                  << conv(s[3]) << conv(s[4]) << conv(s[6]) << conv(s[7])
                  << conv(s[9]) << conv(s[10]) << ";" << std::endl;
    }
    return 0;
}