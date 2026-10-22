> 격자 한 칸과 대시 거리를 맞춰 둡니다. 도면의 칸 수만으로 이동과 회피를 계산할 수 있습니다.

## 대시 거리의 기준 !wide
::: svg
<svg viewBox="0 0 600 190" xmlns="http://www.w3.org/2000/svg" font-family="sans-serif" font-size="14">
<line x1="20" y1="140" x2="390" y2="140" stroke="#D9D7CF" stroke-width="2"/>
<rect x="100" y="100" width="200" height="40" fill="#F2C230" fill-opacity="0.55" stroke="#5B606B" stroke-width="1.5"/>
<text x="200" y="125" fill="#17181C" text-anchor="middle">낮은 엄폐물 1칸 (2m)</text>
<circle cx="20" cy="130" r="9" fill="#0077A3"/>
<path d="M20,95 Q195,20 370,95" fill="none" stroke="#0077A3" stroke-width="3"/>
<path d="M370,95 L356,84 L360,99 Z" fill="#0077A3"/>
<text x="195" y="40" fill="#0077A3" text-anchor="middle" font-size="16">대시 3.5m</text>
<line x1="350" y1="132" x2="350" y2="148" stroke="#C2185B" stroke-width="2"/>
<line x1="20" y1="162" x2="100" y2="162" stroke="#5B606B"/>
<line x1="100" y1="162" x2="300" y2="162" stroke="#5B606B"/>
<line x1="300" y1="162" x2="350" y2="162" stroke="#5B606B"/>
<text x="60" y="182" fill="#5B606B" text-anchor="middle">0.8m</text>
<text x="200" y="182" fill="#5B606B" text-anchor="middle">2m</text>
<text x="325" y="182" fill="#5B606B" text-anchor="middle">0.5m</text>
<text x="495" y="118" fill="#17181C" text-anchor="middle">넘는 데 필요한 거리 3.3m</text>
<text x="495" y="142" fill="#5B606B" text-anchor="middle">대시 3.5m 이내</text>
</svg>
:::
- 엄폐물 앞 0.8m + 칸 2m + 착지 0.5m = 3.3m.
- 두 칸이 붙어 있으면 대시로 통과할 수 없습니다.
- 더 먼 거리는 다리 사이버웨어가 필요합니다.

## 통로와 문
- 내비게이션 반지름이 0.75m이므로 한 칸(2m) 통로의 실제 폭은 0.5m입니다.
- 따라서 통로는 최소 두 칸(4m)으로 냅니다.
- 문 앞 통로가 막히면 방을 나갈 수 없습니다. 따라서 문 앞 통로의 엄폐물은 제거됩니다.

## 그 밖의 칸
| 칸 | 규칙 |
|---|---|
| 벽 (`X`) | 대시로 통과 가능. 높이 4m로 시야와 총알 차단 |
| 전기 발판 (`z`) | 상시 작동. 대시로 2칸까지 피해 없이 통과, 걸으면 0.3초마다 7.8 피해 |
| 폭발물 | 방마다 3개. 미배치 시 동선을 막지 않는 곳에 무작위 배치 |
| 보상 자리 (`F`) | 가운데를 채우는 배치에서는 반드시 지정 |

## 벽의 기획 의도
- 넓게 펼쳐진 방에서 제한된 엄폐물인 벽을 적절히 활용해 적의 시야와 공격으로부터 숨는 플레이를 요구합니다.
- 벽 뒤의 적은 플레이어를 보거나 쏠 수 없습니다.
- 따라서 벽은 길 차단보다 시야 차단 구간을 만드는 데 사용합니다.
