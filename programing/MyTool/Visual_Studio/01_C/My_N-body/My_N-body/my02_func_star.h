#pragma once
#include "pch.h"
#include "my01_struct_star.h"
float calc_dist(star_pos *pos1, star_pos *pos2, float *dist);
float calc_pos(float dt, star_pos *cur_p, star_vel *cur_vel, star_pos *new_pos);
float calc_vel(float dt, star_vel *cur_v, star_acc *cur_acc, star_vel *new_vel);
float calc_acc(std::vector<star_inf> &in_pos);
float update_inf(float dt, std::vector<star_inf> &old_inf, std::vector<star_inf> &new_inf);
