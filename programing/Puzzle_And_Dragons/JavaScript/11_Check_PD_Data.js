//JSONファイルを読み込み、欲しいパラメータを抜き出す。
const fs = require('fs');
const path = require('path');
const jquery = require('./jquery/dist/jquery.min.js');

function printALLFiles(dir) {
    var array = [];
    const filenames = fs.readdirSync(dir);
    filenames.forEach(fname => {
        const fullPath = path.join(dir, fname);
        const stats = fs.statSync(fullPath);
        if (stats.isFile()) {
            // console.log(fullPath);
            array.push(fullPath);
        } else if (stats.isDirectory()) {
            var sub_array = printALLFiles(fullPath);
        }
    });
    return array;
}

function searchJSONFiles(dir) {
    var json_array = [];
    const fnames = fs.readdirSync(dir);
    var fnamePtn = /PDMonster[0-9]+\.json$/;
    fnames.forEach(function (fname) {
        const fullPath = path.join(dir, fname);
        const stats = fs.statSync(fullPath);
        if (stats.isFile()) {
            // console.log(fname);
            var m = fname.match(fnamePtn);
            if (m != null) {
                // console.log(fname);
                json_array.push(fullPath);
            }
        } else if (stats.isDirectory()) {
            var sub_array = searchJSONFiles(fullPath);
            json_array = json_array.concat(sub_array);
        }
    });
    return json_array;
}
// //カレントディレクトリ
// const dir = process.cwd();

//ディレクトリをコマンド引数で指定
dir = process.argv[2];
// var all_f_data = printALLFiles(dir);
// all_f_data.forEach(function (f) {
//     console.log('file:', f);
// });

//パズドラのモンスター毎のJSONファイルを取得
var rtn = searchJSONFiles(dir);
rtn.forEach(function (ret) {
    // console.log(ret);
    //JSONをパースする
    var obj = JSON.parse(fs.readFileSync(ret, 'utf8'));
    var number = obj.number;
    var name = obj.name;
    // console.log('Name = ', name);
    if (name) {
        if (obj.parameters) {
            var maxHP = obj.parameters.HP.最大;
            var maxAtt = obj.parameters.攻撃.最大;
            var maxRec = obj.parameters.回復.最大;
            console.log('Name = ', name,
                        '最大HP = ', maxHP,
                        '最大攻撃力 = ', maxAtt,
                        '最大回復力', maxRec
                        );    
        } else {
            console.log('Name = ', name);
        }
    }
    // var maxHP = obj.parameters.HP.最大;
    // console.log('Name = ', name, '最大HP = ', maxHP);
});