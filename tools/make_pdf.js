// Edgerunners 기획 요약 PDF를 만든다.
//
//   perl tools/build_decks.pl      (edgerunners/summary.html을 먼저 만든다)
//   node tools/make_pdf.js         (Playwright 필요: npm i -g playwright)
//
// summary.html을 1920×1080 쪽으로 인쇄해 assets/pdf/edgerunners_summary.pdf로 저장한다.
// 넣을 장은 tools/build_decks.pl의 @SUMMARY에서 고른다. 끝으로 tools/shrink_pdf.py가 그림 용량을 줄인다.
const { chromium } = require("playwright");
const http = require("http");
const fs = require("fs");
const path = require("path");
const { execFileSync } = require("child_process");

const root = path.resolve(__dirname, "..");
const types = { ".html": "text/html", ".css": "text/css", ".js": "text/javascript", ".webp": "image/webp", ".ttf": "font/ttf", ".woff2": "font/woff2", ".png": "image/png" };
const server = http.createServer((req, res) => {
  const file = path.join(root, decodeURIComponent(req.url.split("?")[0]));
  if (!file.startsWith(root) || !fs.existsSync(file)) { res.writeHead(404); return res.end(); }
  res.writeHead(200, { "Content-Type": types[path.extname(file)] || "application/octet-stream" });
  fs.createReadStream(file).pipe(res);
});

server.listen(0, async () => {
  const port = server.address().port;
  const browser = await chromium.launch();
  const page = await browser.newPage({ viewport: { width: 1920, height: 1080 } });
  await page.goto(`http://localhost:${port}/edgerunners/summary.html`, { waitUntil: "networkidle" });
  await page.evaluate(() => document.fonts.ready);
  await page.waitForTimeout(500);
  const out = path.join(root, "assets/pdf/edgerunners_summary.pdf");
  await page.pdf({ path: out, width: "1920px", height: "1080px", printBackground: true, margin: { top: 0, right: 0, bottom: 0, left: 0 } });
  await browser.close();
  server.close();
  console.log(out, Math.round(fs.statSync(out).size / 1024) + "KB");
  // 그림 용량 줄이기(PyMuPDF가 없으면 건너뛴다)
  try { console.log(execFileSync("python3", [path.join(__dirname, "shrink_pdf.py"), out]).toString().trim()); }
  catch (e) { console.warn("shrink_pdf.py 실패 — 줄이지 않은 PDF를 둔다:", e.message.split("\n")[0]); }
});
