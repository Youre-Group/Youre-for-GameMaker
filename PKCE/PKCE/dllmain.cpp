#include "pch.h"
#include <iostream>
#include "PKCEHelper.h"
#define GMDLL extern "C" __declspec(dllexport)



GMDLL char* GenerateCodeChallenge(char* code_verifier) {

    PKCEHelper pkce{};
    std::string code_verifier_hex = pkce.convertStringToHex(code_verifier);
    std::string challenge64 = pkce.base64_encode2(pkce.getSHA256HashFromHex(code_verifier_hex));
    const char* charPtr = challenge64.c_str();
	return (char*)charPtr;
}

GMDLL char* HexToBase64(char* code_verifier) {

    PKCEHelper pkce{};
    std::string challenge64 = pkce.base64_encode2(code_verifier);
    const char* charPtr = challenge64.c_str();
    return (char*)charPtr;
}