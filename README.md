# 포트폴리오 사이트

게임 기획 포트폴리오. GitHub Pages로 `https://edmunddaekyu.github.io/`에 올라간다.

## 구성

| 경로 | 내용 |
|---|---|
| `index.html` | 홈 — 소개, 프로젝트 목록 |
| `edgerunners/index.html` | Edgerunners 게임 — 소개, 플레이 링크, 장면, 한 판의 흐름, 조작 |
| `edgerunners/plan/index.html` | Edgerunners 기획서 목록 — 개요 하나와 세부 기획서 다섯. `tools/build_decks.pl`이 만든다 |
| `edgerunners/plan/<덱>.html` | 기획서 한 벌. `tools/build_decks.pl`이 만든다(손으로 고치지 않는다) |
| `edgerunners/log/index.html` | Edgerunners 작업 내역 — 개발 과정 덱. 역시 `tools/build_decks.pl`이 만든다 |
| `assets/` | 글꼴(페이퍼로지), 스타일, 슬라이드 보기 스크립트, 그림(WebP) |
| `src/decks/<덱>/` | 덱 원본. claude.ai Slides 덱의 `deck.json`과 `slides/*.html`, 장마다 붙는 설명 `notes/<장 id>.md` |
| `tools/NOTES_FORMAT.md` | 장별 설명을 쓰는 형식(칸 · 소제목 · 도식) |

게임 웹 빌드는 이 저장소에 넣지 않는다.
따로 `edgerunners-play` 저장소에 올려 `https://edmunddaekyu.github.io/edgerunners-play/`에서 돌린다.
빌드가 수십 MB라 여기에 커밋하면 저장소가 금방 커진다.

## 기획서를 고친 뒤

1. claude.ai 덱에서 고쳤다면 그 덱의 `deck.json`과 `slides/*.html`을 `src/decks/<덱>/`에 덮어쓴다.
2. 새 그림이 생겼으면 `tools/images.tsv`에 `blob id → 그림 이름`을 적고, 그림을 WebP로 만든다.

   ```bash
   G="<Godot 4.7 실행 파일>"
   "$G" --headless --script tools/to_webp.gd -- <원본 폴더> assets/img 1920 <그림 이름> …
   ```

3. 장마다 설명을 `src/decks/<덱>/notes/<장 id>.md`에 쓴다. 형식은 `tools/NOTES_FORMAT.md`에 있다.
   설명 파일이 없는 장은 슬라이드의 발표자 노트를 한 문단으로 보여 준다.
4. 페이지를 다시 만든다.

   ```bash
   perl tools/build_decks.pl
   ```

## 미리 보기

글꼴을 상대 경로로 불러서, 파일을 그냥 열면 브라우저가 글꼴을 막을 수 있다.
로컬 서버로 열거나 Chrome에 `--allow-file-access-from-files`를 주고 연다.

## 채울 칸

`[한 줄 소개]`(홈)는 아직 빈칸이다. 이름 · 연락처는 홈과 각 페이지의 머리 · 바닥에 들어 있다.
덱 페이지와 기획서 목록의 머리 · 바닥은 `tools/build_decks.pl` 안에 있으니 거기서 고친다.

## 글꼴

페이퍼로지(Paperlogy) — SIL Open Font License 1.1.
