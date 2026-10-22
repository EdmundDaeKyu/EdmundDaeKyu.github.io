> 전기 함정은 대시로 피해 없이 통과할 수 있으나, 위에 머무르면 피해와 오작동 누적이 계속 쌓입니다.

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
- 피해는 틱마다 7.8, 초당 26입니다.
- 전기 누적이 45를 넘으면 오작동이 발생합니다. 2.5초 동안 대시로도 빠져나갈 수 없습니다.
- 피해는 대상마다 따로 계산합니다.

## 대시 통과 시 피해 없음 근거
- 대시는 본 게임의 기본 회피 수단입니다.
- 대시 통과에도 불이익을 주면 대시 회피라는 기본 규칙과 충돌합니다.
- 따라서 불이익은 함정 위에 머무를 때만 적용합니다.

## 레벨 디자인 적용
- 함정은 한 칸(2m) 타일이며, 일렬로 붙은 칸 수에 따라 대시 한 번의 통과 여부가 결정됩니다.
- 쇼크링 전투방은 외벽을 따라 도는 길을 전기 함정으로 막았습니다.
- 따라서 엄폐 지점은 가운데 I자 엄폐물만 남습니다.
- 바람개비 전투방 가운데의 전기 함정 두 칸은 지름길입니다.
- 이 지름길을 지나려면 대시를 쓰거나 피해를 감수해야 합니다.
