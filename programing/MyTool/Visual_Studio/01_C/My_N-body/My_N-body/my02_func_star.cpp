#include "pch.h"
#include "my01_struct_star.h"
float calc_dist (star_pos *pos1, star_pos *pos2, float *dist)
{
	//差分を計算
	float dx = pos1->px - pos2->px;
	float dy = pos1->py - pos2->py;
	float dz = pos1->pz - pos2->pz;

	float ret = 0;
	float d = dx * dx + dy * dy + dz * dz;

	*dist = d;

	if (d <= 0)
	{
		ret = -1;
	}

	return ret;
}
float calc_pos(float dt, star_pos *cur_p, star_vel *cur_vel, star_pos *new_pos)
{
	float ret = 0;

	new_pos->px = cur_p->px + cur_vel->vx * dt;
	new_pos->py = cur_p->py + cur_vel->vy * dt;
	new_pos->pz = cur_p->pz + cur_vel->vz * dt;

	return ret;
}
float calc_vel(float dt, star_vel *cur_v, star_acc *cur_acc, star_vel *new_vel)
{
	float ret = 0;

	new_vel->vx = cur_v->vx + cur_acc->ax * dt;
	new_vel->vy = cur_v->vy + cur_acc->ay * dt;
	new_vel->vz = cur_v->vz + cur_acc->az * dt;

	return ret;
}
float calc_acc(std::vector<star_inf> &in_pos)
{
	float ret = 0;
	int i, j;
	int N_star;
	float dx, dy, dz;
	float dist1;
	float dist2;
	float dist3;
	float m;
	float inv_dist1;

	star_pos p1, p2;
	star_acc acc;


	N_star = (int)in_pos.size();

	for (i = 0; i < N_star; i++)
	{
		memset(&p1, 0x00, sizeof(p1));
		memset(&acc, 0x00, sizeof(acc));
		p1 = in_pos.at(i).st_p;

		for (j = 0; j < N_star; j++)
		{
			memset(&p2, 0x00, sizeof(p2));
			p2 = in_pos.at(j).st_p;
			m = in_pos.at(j).m;

			if (j == i)
			{
				continue;
			}

			//天体同士の距離を計算
			dx = p2.px - p1.px;
			dy = p2.py - p1.py;
			dz = p2.pz - p1.pz;

			ret = calc_dist(&p1, &p2, &dist1);
			dist2 = dist1 * dist1;
			dist3 = dist2 * dist1;
			inv_dist1 = 1 / sqrt(dist3);

			//加速度を計算
			acc.ax += m * dx * inv_dist1;
			acc.ay += m * dy * inv_dist1;
			acc.az += m * dz * inv_dist1;
		}
		//std::printf("%.3lf\t%.3lf\t%.3lf\n", acc.ax, acc.ay, acc.az);

		//加速度の値を代入
		memcpy_s(&in_pos.at(i).st_a, sizeof(star_acc), &acc, sizeof(star_acc));
		//std::printf("%.3lf\t%.3lf\t%.3lf\n",
		//	in_pos.at(i).st_a.ax,
		//	in_pos.at(i).st_a.ay,
		//	in_pos.at(i).st_a.az);
	}
	return ret;
}
float update_inf(float dt, std::vector<star_inf> &old_inf, std::vector<star_inf> &new_inf)
{
	int i;
	float ret = 0;

	int N_sz = (int)new_inf.size();
	//std::cout << "Size : " << N_sz << std::endl;

	star_inf new_star;

	int N = (int)old_inf.size();

	for (i = 0; i < N; i++)
	{
		memset(&new_star, 0x00, sizeof(new_star));

		//天体の位置を更新
		ret = calc_pos(dt, &old_inf.at(i).st_p, &old_inf.at(i).st_v, &new_star.st_p);
		
		//天体の速度を更新
		ret = calc_vel(dt, &old_inf.at(i).st_v, &old_inf.at(i).st_a, &new_star.st_v);

		//天体の質量をコピー
		new_star.m = old_inf.at(i).m;

		std::printf("%f\t%f\t%f\t%f\t%f\t%f\t%f\n"
			, old_inf.at(i).m
			, old_inf.at(i).st_p.px, old_inf.at(i).st_p.py, old_inf.at(i).st_p.pz
			, old_inf.at(i).st_v.vx, old_inf.at(i).st_v.vy, old_inf.at(i).st_v.vz);

		if (N_sz == 0)
		{
			new_inf.push_back(new_star);
		}
		else {
			memcpy_s(&new_inf.at(i), sizeof(star_inf), &new_star, sizeof(star_inf));
		}
	}

	return ret;
}