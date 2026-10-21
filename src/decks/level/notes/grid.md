> 격자 한 칸과 대시 거리를 맞춰 두어서, 도면의 칸 수만으로 이동과 회피를 계산할 수 있습니다.

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
<text x="495" y="142" fill="#5B606B" text-anchor="middle">대시 3.5m 안에 들어간다</text>
</svg>
:::
- 엄폐물 앞 0.8m, 칸 2m, 착지 0.5m를 더하면 3.3m다.
- 두 칸이 붙어 있으면 대시로 넘을 수 없다.
- 더 멀리 가려면 다리 사이버웨어가 필요하다.

## 통로와 문
- 내비게이션 반지름이 0.75m라서, 한 칸(2m) 통로는 실제로 0.5m가 된다.
- 그래서 통로는 최소 두 칸(4m)으로 낸다.
- 문 앞 통로가 막히면 방을 나갈 수 없어서, 그 자리의 엄폐물은 제거된다.

## 그 밖의 칸
| 칸 | 규칙 |
|---|---|
| 벽 (`X`) | 대시로 넘을 수 있다. 높이 4m라 시야와 총알을 막는다 |
| 전기 함정 (`z`) | 항상 켜져 있다. 대시로 2칸까지 피해 없이 넘고, 걸으면 0.3초마다 7.8 피해 |
| 폭발물 | 방마다 3개. 배치하지 않으면 동선을 막지 않는 곳에 무작위로 놓는다 |
| 보상 자리 (`F`) | 가운데를 채우는 배치에서는 꼭 지정한다 |

## 벽의 용도
- 벽 뒤의 적은 플레이어를 보지도 쏘지도 못한다.
- 그래서 벽은 길을 막기보다 시야가 가려지는 구간을 만드는 데 쓴다.
