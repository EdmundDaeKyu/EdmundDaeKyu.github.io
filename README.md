# 포트폴리오 사이트

게임 기획 포트폴리오. GitHub Pages로 `https://edmunddaekyu.github.io/`에 올라간다.

## 구성

| 경로 | 내용 |
|---|---|
| `index.html` | 홈 — 소개, 프로젝트 목록 |
| `edgerunners/index.html` | Edgerunners 게임 — 소개, 플레이 링크, 장면, 한 판의 흐름, 조작 |
| `edgerunners/plan/index.html` | 기획서 탭 첫 화면 = 개요 기획서. 왼쪽에 모든 기획서 · 작업 내역의 장 목차. `tools/build_decks.pl`이 만든다 (`plan/overview.html`은 이 페이지로 보내는 옛 주소) |
| `edgerunners/summary.html` · `assets/pdf/edgerunners_summary.pdf` | 기획 요약 PDF(14쪽)와 그 인쇄용 페이지. 장 목록은 `build_decks.pl`의 `@SUMMARY` |
| `edgerunners/plan/<덱>.html` | 기획서 한 벌. `tools/build_decks.pl`이 만든다(손으로 고치지 않는다) |
| `edgerunners/log/index.html` | Edgerunners 작업 내역 — 개발 과정 덱. 역시 `tools/build_decks.pl`이 만든다 |
| `analysis/index.html` | 역기획서 목록 — 리그 오브 레전드 1 · 2편, 엘든 링 림그레이브, 원신 몬드, 클래시로얄. `tools/build_decks.pl`이 만든다 |
| `analysis/<덱>.html` | 역기획서 한 벌. `tools/build_decks.pl`이 만든다(손으로 고치지 않는다) |
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

## 요약 PDF를 다시 만들 때

```bash
perl tools/build_decks.pl
node tools/make_pdf.js     # Playwright 필요. 끝에 tools/shrink_pdf.py(PyMuPDF)로 그림 용량을 줄인다
```

## 역기획서를 더하거나 고친 뒤

1. claude.ai 덱의 `deck.json`과 `slides/*.html`을 `src/decks/<덱>/`에 넣고, `tools/build_decks.pl`의 `@DECKS`에 `'study'` 묶음으로 한 줄을 더한다(마지막 칸은 카드에 붙는 게임 이름).
2. 그림은 위와 같이 `tools/images.tsv`에 짝을 적고 WebP로 만든다. 이름은 `<덱>_<번호>`로 맞췄다.
3. 림그레이브는 Keynote PDF라 장마다 1920×1080 그림 한 장(`limgrave_<번호>.webp`)으로 옮겼다. 원본을 고치면 PDF에서 다시 뽑는다.
4. 홈(`index.html`)의 역기획서 카드는 손으로 쓴 것이라 덱을 더하면 함께 고친다.
5. `perl tools/build_decks.pl`

## 미리 보기

글꼴을 상대 경로로 불러서, 파일을 그냥 열면 브라우저가 글꼴을 막을 수 있다.
로컬 서버로 열거나 Chrome에 `--allow-file-access-from-files`를 주고 연다.

## 채울 칸

이름 · 한 줄 소개 · 연락처는 홈(`index.html`)에, 이름은 각 페이지의 머리 · 바닥에도 들어 있다.
덱 페이지와 기획서 목록의 머리 · 바닥은 `tools/build_decks.pl` 안에 있으니 거기서 고친다.

## 글꼴

페이퍼로지(Paperlogy) — SIL Open Font License 1.1.
