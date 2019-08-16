#include "pch.h"
#include "com_func.h"
#include "my01_struct_star.h"
std::vector<std::string> split_str(const std::string &str, char delim)
{
	std::vector<std::string> res;
	size_t current = 0, found;
	while ((found = str.find_first_of(delim, current)) != std::string::npos) {
		res.push_back(std::string(str, current, found - current));
		current = found + 1;
	}

	res.push_back(std::string(str, current, str.size() - current));
	return res;
}
float read_data(std::string fname, std::vector<star_inf> &st_info)
{
	float ret;
	star_inf rd_star;

	std::ifstream ifs;
	std::string str;

	ret = 0;

	//std::cout << "FileName : " << fname << std::endl;
	ifs.open(fname, std::ios::in);
	if (!ifs) {
		std::cout << "ファイルが開けません。" << std::endl;
		ret = -1;
		return ret;
	}
	std::cout << "ファイルの読み込みが終わりました。" << std::endl;

	while (std::getline(ifs, str))
	{
		std::cout << str << std::endl;

		memset(&rd_star, 0x00, sizeof(rd_star));

		std::vector<std::string> linedata = split_str(str, '\t');

		rd_star.m = stof(linedata.at(0));
		rd_star.st_p.px = stof(linedata.at(1));
		rd_star.st_p.py = stof(linedata.at(2));
		rd_star.st_p.pz = stof(linedata.at(3));
		rd_star.st_v.vx = stof(linedata.at(4));
		rd_star.st_v.vy = stof(linedata.at(5));
		rd_star.st_v.vz = stof(linedata.at(6));

		st_info.push_back(rd_star);
		linedata.clear();
	}

	ifs.close();
	
	return ret;
}