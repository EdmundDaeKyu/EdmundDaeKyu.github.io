> 전기 함정은 대시로는 피해 없이 건널 수 있지만, 위에 머무르면 피해와 오작동 누적이 계속 쌓입니다.

## 위에 서 있을 때 !wide
::: svg
<svg viewBox="0 0 600 150" xmlns="http://www.w3.org/2000/svg" font-family="sans-serif" font-size="13">
<rect x="40" y="52" width="520" height="26" rx="4" fill="#E07020" fill-opacity="0.18"/>
<line x1="40" y1="65" x2="560" y2="65" stroke="#E07020" stroke-width="2"/>
<circle cx="40" cy="65" r="10" fill="#C2185B"/><text x="40" y="69.5" fill="#FFFFFF" text-anchor="middle" font-size="12">1</text>
<circle cx="144" cy="65" r="10" fill="#C2185B"/><text x="144" y="69.5" fill="#FFFFFF" text-anchor="middle" font-size="12">2</text>
<circle cx="248" cy="65" r="10" fill="#C2185B"/><text x="248" y="69.5" fill="#FFFFFF" text-anchor="middle" font-size="12">3</text>
<circle cx="352" cy="65" r="10" fill="#C2185B"/><text x="352" y="69.5" fill="#FFFFFF" text-anchor="middle" font-size="12">4</text>
<circle cx="456" cy="65" r="10" fill="#C2185B"/><text x="456" y="69.5" fill="#FFFFFF" text-anchor="middle" font-size="12">5</text>
<circle cx="560" cy="65" r="12" fill="#1E7FD0"/><text x="560" y="69.5" fill="#FFFFFF" text-anchor="middle" font-size="12">6</text>
<text x="40" y="36" fill="#17181C">밟는 순간 첫 틱</text>
<text x="560" y="36" fill="#1E7FD0" text-anchor="end">6틱(약 1.5초): 오작동</text>
<line x1="40" y1="105" x2="560" y2="105" stroke="#D9D7CF" stroke-width="1.5"/>
<text x="40" y="125" fill="#5B606B" text-anchor="middle">0</text>
<text x="144" y="125" fill="#5B606B" text-anchor="middle">0.3</text>
<text x="248" y="125" fill="#5B606B" text-anchor="middle">0.6</text>
<text x="352" y="125" fill="#5B606B" text-anchor="middle">0.9</text>
<text x="456" y="125" fill="#5B606B" text-anchor="middle">1.2</text>
<text x="560" y="125" fill="#5B606B" text-anchor="middle">1.5초</text>
</svg>
:::
- 틱마다 7.8, 초당 26의 피해가 들어간다.
- 전기 누적이 45를 넘으면 오작동에 걸려 2.5초 동안 대시로도 빠져나갈 수 없다.
- 피해는 대상마다 따로 계산한다.

## 대시로 건너면 피해가 없는 이유
- 대시는 이 게임의 기본 회피 수단이다.
- 대시로 건너는 것까지 불이익을 주면 대시로 피한다는 기본 규칙과 충돌한다.
- 그래서 불이익은 위에 머무르는 것에만 준다.

## 레벨 디자인에서 쓰는 법
- 함정은 한 칸(2m) 타일이고, 일렬로 몇 칸이 붙어 있느냐에 따라 대시 한 번에 건널 수 있는지가 달라진다.
- 쇼크링 전투방은 외벽을 따라 도는 길을 전기 함정으로 막았다.
- 그래서 엄폐할 곳으로는 가운데 I자 엄폐물만 남는다.
- 바람개비 전투방 가운데의 전기 함정 두 칸은 지름길이지만, 지나가려면 대시를 쓰거나 피해를 감수해야 한다.
