#!/bin/bash -xv
# SPDX-FileCopyrightText: 2026 Sora Makino
# SPDX-License-Identifier: BSD-3-Clause

ng () {
    echo "${1}行目が違うよ"
    res=1
}

res=0

### NORMAL INPUT ###
# 3回指定で3行出力され、YYYY-MM-DD HH:MM:SS 形式になっているか確認
out=$(./clock 3)
[ "$?" = 0 ] || ng "$LINENO"
lines=$(echo "${out}" | wc -l)
[ "${lines}" = 3 ] || ng "$LINENO"

echo "${out}" | grep -Eq '^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}$'
[ "$?" = 0 ] || ng "$LINENO"

# 引数なし（連続表示）で起動し、1.5秒後に停止したとき2行出力されるか確認
out=$(timeout -s INT 1.5 ./clock)
lines=$(echo "${out}" | wc -l)
[ "${lines}" = 2 ] || ng "$LINENO"

### STRANGE INPUT ###
out=$(./clock 0 2>/dev/null)
[ "$?" = 1 ]      || ng "$LINENO"
[ "${out}" = "" ] || ng "$LINENO"

out=$(./clock -1 2>/dev/null)
[ "$?" = 1 ]      || ng "$LINENO"
[ "${out}" = "" ] || ng "$LINENO"

out=$(./clock abc 2>/dev/null)
[ "$?" = 1 ]      || ng "$LINENO"
[ "${out}" = "" ] || ng "$LINENO"

out=$(./clock 1 2 2>/dev/null)
[ "$?" = 1 ]      || ng "$LINENO"
[ "${out}" = "" ] || ng "$LINENO"

[ "${res}" = 0 ] && echo OK
exit $res
