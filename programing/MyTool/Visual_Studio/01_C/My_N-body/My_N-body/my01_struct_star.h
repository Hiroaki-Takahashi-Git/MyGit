#pragma once
//�V�̂̃f�[�^�̍\��
//�V�̂̎O�������W
typedef struct star_pos {
	float px;
	float py;
	float pz;
};
//�V�̂̎O�������x
typedef struct star_vel {
	float vx;
	float vy;
	float vz;
};
//�V�̂̎O���������x
typedef struct star_acc {
	float ax;
	float ay;
	float az;
};
//�V�̂̏��
typedef struct star_inf {
	float m;
	star_pos st_p;
	star_vel st_v;
	star_acc st_a;
};