#!/bin/bash
# 指定フォルダ配下のファイルをGnuPG共通鍵暗号方式で暗号化する
# 使い方: ./encrypt.sh <対象フォルダ>

TARGET_DIR="$1"

if [[ -z "$TARGET_DIR" || ! -d "$TARGET_DIR" ]]; then
    echo "使い方: $0 <対象フォルダ>"
    exit 1
fi

read -rsp "パスフレーズ: " PASSPHRASE; echo
read -rsp "パスフレーズ（確認）: " PASSPHRASE2; echo

if [[ "$PASSPHRASE" != "$PASSPHRASE2" ]]; then
    echo "エラー: パスフレーズが一致しません。"
    exit 1
fi

find "$TARGET_DIR" -type f ! -name "*.gpg" | while read -r FILE; do
    gpg --batch --yes --passphrase-fd 3 \
        --symmetric --cipher-algo AES256 \
        --output "${FILE}.gpg" "$FILE" \
        3<<< "$PASSPHRASE" \
        && echo "暗号化完了: $FILE" \
        || echo "暗号化失敗: $FILE"
done
unset PASSPHRASE
unset PASSPHRASE2