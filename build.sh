#!/bin/sh
# 由 ../台灣名產島/index.html（Artifact 版，沒有 doctype 外殼）產生 GitHub Pages 用的 index.html
cd "$(dirname "$0")"
(cd ../台灣名產島 && python3 build.py) || exit 1
SRC=../台灣名產島/index.html
{
  printf '%s\n' '<!doctype html>' '<html lang="zh-Hant">' '<head>' '<meta charset="utf-8">' \
    '<meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover">' \
    '<style>:root{padding-top:env(safe-area-inset-top,0px);padding-bottom:env(safe-area-inset-bottom,0px)}body{margin:0}img{max-width:100%}</style>' \
    '</head>' '<body>'
  grep -v -e '^<meta charset="utf-8">$' -e '^<meta name="viewport"' "$SRC"
  # 錯誤／建議回報按鈕（只放 Pages 版；Artifact 的 CSP 不允許外部 script）
  printf '%s\n' \
    '<script>window.REPORT_CONTEXT=()=>{try{if(state&&state.mode==="county"){const c=CS[state.ci];return{item:c.id||String(state.ci),itemName:c.name}}}catch(e){}return{}}</script>' \
    '<script src="https://mattsue1003.github.io/oth-report-button/report.js" data-site="台灣好味島" data-position="left" defer></script>' \
    '<script>/* 不用浮動鈕，改由標題卡右上角「⚑ 回報」開啟 */addEventListener("load",()=>{const r=document.querySelector("[data-oth-report]")?.shadowRoot,b=document.getElementById("repBtn");if(!r||!window.openReport||!b)return;const st=document.createElement("style");st.textContent=".fab{display:none!important}";r.appendChild(st);b.hidden=false;b.onclick=()=>openReport()})</script>'
  printf '%s\n' '</body>' '</html>'
} > index.html
echo "index.html $(wc -c < index.html) bytes"
