# Create a Windows binary with options to specify both the input and output paths using C++

## Create a .cpp file

``` cpp
#include <iostream>
#include <string>
#include <Windows.h>

void createChdFiles(const std::wstring& inputPath, const std::wstring& outputPath) {
    WIN32_FIND_DATAW findData;
    std::wstring searchPath = inputPath + L"\\*";
    HANDLE hFind = FindFirstFileW(searchPath.c_str(), &findData);
    if (hFind != INVALID_HANDLE_VALUE) {
        do {
            if (!(findData.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY)) {
                std::wstring inputFile = inputPath + L"\\" + findData.cFileName;
                std::wstring outputFile = outputPath + L"\\" + findData.cFileName + L".chd";
                std::wcout << L"Creating CHD file for: " << inputFile << std::endl;
                std::wstring command = L"chdman createcd -i \"" + inputFile + L"\" -o \"" + outputFile + L"\"";
                system(command.c_str());
            }
        } while (FindNextFileW(hFind, &findData) != 0);
        FindClose(hFind);
    }
}

int main(int argc, char* argv[]) {
    if (argc != 3) {
        std::wcerr << L"Usage: " << argv[0] << " <input_path> <output_path>" << std::endl;
        return 1;
    }

    std::wstring inputPath = std::wstring_convert<std::codecvt_utf8<wchar_t>>().from_bytes(argv[1]);
    std::wstring outputPath = std::wstring_convert<std::codecvt_utf8<wchar_t>>().from_bytes(argv[2]);

    if (!CreateDirectoryW(outputPath.c_str(), NULL) && ERROR_ALREADY_EXISTS != GetLastError()) {
        std::wcerr << L"Error creating output directory." << std::endl;
        return 1;
    }

    createChdFiles(inputPath, outputPath);

    return 0;
}
```

## Steps to compile it using MinGW

- Open Command Prompt and navigate to the directory containing the file.

### Compile the code using MinGW

`g++ -o create_chd_files.exe create_chd_files.cpp -lstdc++fs`

### Once compiled successfully, you will get an executable file named create_chd_files.exe

You can then run it from the Command Prompt with the input and output paths as arguments:

```create_chd_files.exe "C:\path\to\input" "C:\path\to\output"```

Replace "C:\path\to\input" and "C:\path\to\output" with the actual input and output paths. This program will create CHD files for all files in the input directory and save them in the output directory.
