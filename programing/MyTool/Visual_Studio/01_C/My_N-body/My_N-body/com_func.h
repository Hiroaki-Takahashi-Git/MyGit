#pragma once
#include "my01_struct_star.h"
std::vector<std::string> split_str(const std::string &str, char delim);
float read_data(std::string fname, std::vector<star_inf> &st_info);