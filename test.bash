#!/bin/bash -xv
# SPDX-FileCopyrightText: 2026 Sora Makino
# SPDX-License-Identifier: BSD-3-Clause

ng () {
    echo "${1}行目が違うよ"
    res=1
}

res=0

### NORMAL INPUT ###
# 1.5秒間動かして Ctrl+C（SIGINT）で停止し、出力されるか確認
out=$(timeout --preserve-status -s INT 1.5 ./clock)
status=$?
[ "${status}" = 0 ] || [ "${status}" = 130 ] || ng "$LINENO"

lines=$(echo "${out}" | wc -l)
[ "${lines}" -ge 1 ] || ng "$LINENO"

echo "${out}" | grep -Eq '^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}$'
[ "$?" = 0 ] || ng "$LINENO"

### STRANGE INPUT ###
# 余計な引数を渡したときにエラー終了するか確認
out=$(./clock 123 2>/dev/null)
[ "$?" = 1 ]      || ng "$LINENO"
[ "${out}" = "" ] || ng "$LINENO"

out=$(./clock abc 2>/dev/null)
[ "$?" = 1 ]      || ng "$LINENO"
[ "${out}" = "" ] || ng "$LINENO"

[ "${res}" = 0 ] && echo OK
exit $res
