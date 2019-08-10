#pragma once
//天体のデータの構造
//天体の三次元座標
typedef struct star_pos {
	float px;
	float py;
	float pz;
};
//天体の三次元速度
typedef struct star_vel {
	float vx;
	float vy;
	float vz;
};
//天体の三次元加速度
typedef struct star_acc {
	float ax;
	float ay;
	float az;
};
//天体の情報
typedef struct star_inf {
	float m;
	star_pos st_p;
	star_vel st_v;
	star_acc st_a;
};