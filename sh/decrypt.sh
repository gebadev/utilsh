#!/bin/bash
# 指定フォルダ配下の .gpg ファイルをGnuPG共通鍵暗号方式で復号する
# 使い方: ./decrypt.sh <対象フォルダ>

TARGET_DIR="$1"

if [[ -z "$TARGET_DIR" || ! -d "$TARGET_DIR" ]]; then
    echo "使い方: $0 <対象フォルダ>"
    exit 1
fi

read -rsp "パスフレーズ: " PASSPHRASE; echo

find "$TARGET_DIR" -type f -name "*.gpg" | while read -r FILE; do
    OUTPUT="${FILE%.gpg}"
    gpg --batch --yes --passphrase-fd 3 \
        --decrypt \
        --output "$OUTPUT" "$FILE" \
        3<<< "$PASSPHRASE" \
        && echo "復号完了: $FILE" \
        || echo "復号失敗: $FILE"
done
unset PASSPHRASE