> 숲길은 자갈로 갈 길을 보여 주고, 실제로 걸을 수 있는 범위는 보이는 경계에 맞춰 그보다 넓게 둡니다.

## 길의 단면 !wide
::: svg
<svg viewBox="0 0 800 210" xmlns="http://www.w3.org/2000/svg">
<rect x="0" y="60" width="100" height="100" fill="#5B606B" fill-opacity="0.18"/>
<circle cx="30" cy="85" r="18" fill="#5B606B" fill-opacity="0.45"/>
<circle cx="70" cy="125" r="16" fill="#5B606B" fill-opacity="0.45"/>
<rect x="100" y="60" width="130" height="100" fill="#0077A3" fill-opacity="0.12"/>
<rect x="230" y="60" width="340" height="100" fill="#D9D7CF"/>
<rect x="570" y="60" width="130" height="100" fill="#0077A3" fill-opacity="0.12"/>
<rect x="700" y="60" width="100" height="100" fill="#5B606B" fill-opacity="0.18"/>
<circle cx="735" cy="90" r="16" fill="#5B606B" fill-opacity="0.45"/>
<circle cx="772" cy="130" r="18" fill="#5B606B" fill-opacity="0.45"/>
<line x1="100" y1="40" x2="100" y2="170" stroke="#C2185B" stroke-width="3" stroke-dasharray="8 6"/>
<line x1="700" y1="40" x2="700" y2="170" stroke="#C2185B" stroke-width="3" stroke-dasharray="8 6"/>
<line x1="110" y1="30" x2="690" y2="30" stroke="#0077A3" stroke-width="2"/>
<path d="M110,30 l10,-6 v12 z M690,30 l-10,-6 v12 z" fill="#0077A3"/>
<text x="400" y="22" text-anchor="middle" font-size="16" fill="#0077A3">걸을 수 있는 범위</text>
<text x="400" y="116" text-anchor="middle" font-size="18" fill="#17181C">자갈길 (가야 할 길)</text>
<text x="165" y="116" text-anchor="middle" font-size="16" fill="#17181C">숲 바닥</text>
<text x="635" y="116" text-anchor="middle" font-size="16" fill="#17181C">숲 바닥</text>
<text x="50" y="190" text-anchor="middle" font-size="15" fill="#5B606B">나무, 덤불, 바위</text>
<text x="750" y="190" text-anchor="middle" font-size="15" fill="#5B606B">나무, 덤불, 바위</text>
<text x="400" y="190" text-anchor="middle" font-size="15" fill="#C2185B">점선: 보이지 않는 벽</text>
</svg>
:::

## 쓰러진 나무 자리
- 걸을 수 있는 폭이 자갈길 폭으로 좁아진다.
- 나무 양 끝은 숲에 막혀 있어 옆으로 돌아갈 수 없다.
- 그래서 대시 말고는 넘어갈 방법이 없다.

## 화면을 가리지 않게
- 카메라는 피치 -72°로 위에서 내려다보며 플레이어를 따라간다.
- 화면 아래쪽에 큰 나무가 있으면 플레이어를 가리므로, 그쪽에는 덤불과 풀만 둔다.
