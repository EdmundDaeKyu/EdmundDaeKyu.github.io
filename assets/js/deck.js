// 기획서 슬라이드 보기.
// 슬라이드는 1920×1080 <section>이다(claude.ai Slides 형식). 칸 폭에 맞춰 줄이고,
// 형식의 특수 요소(x-connector · x-icon · data-crop)를 이 페이지에서 그린다.
(function () {
  "use strict";
  const W = 1920;
  const H = 1080;
  const SVG = "http://www.w3.org/2000/svg";

  function fit(frame) {
    const section = frame.querySelector(":scope > section");
    if (!section) return;
    const box = frame.getBoundingClientRect();
    const scale = Math.min(box.width / W, box.height / H);
    section.style.transform = "scale(" + scale + ")";
    section.style.left = (box.width - W * scale) / 2 + "px";
    section.style.top = (box.height - H * scale) / 2 + "px";
  }

  function fitAll() {
    document.querySelectorAll(".slide-frame").forEach(fit);
  }

  // 연결선 — 좌표는 가장 가까운 position:relative 상자(없으면 슬라이드) 기준이다.
  function drawConnector(el) {
    let host = el.parentElement;
    while (host && host.tagName !== "SECTION" && getComputedStyle(host).position === "static") {
      host = host.parentElement;
    }
    if (!host) return;
    const style = getComputedStyle(el);
    const color = style.color || "#17181C";
    const width = parseFloat(el.style.borderWidth) || 2;
    const dashed = /dashed/.test(el.style.borderStyle) ? "8 6" : (/dotted/.test(el.style.borderStyle) ? "2 5" : "");
    const x1 = parseFloat(el.getAttribute("x1"));
    const y1 = parseFloat(el.getAttribute("y1"));
    const x2 = parseFloat(el.getAttribute("x2"));
    const y2 = parseFloat(el.getAttribute("y2"));
    if ([x1, y1, x2, y2].some(Number.isNaN)) return;
    const head = el.getAttribute("head") || "end";
    const svg = document.createElementNS(SVG, "svg");
    const w = host.offsetWidth;
    const h = host.offsetHeight;
    svg.setAttribute("width", w);
    svg.setAttribute("height", h);
    svg.setAttribute("viewBox", "0 0 " + w + " " + h);
    svg.style.cssText = "position:absolute;left:0;top:0;pointer-events:none;overflow:visible;";
    const line = document.createElementNS(SVG, "line");
    line.setAttribute("x1", x1); line.setAttribute("y1", y1);
    line.setAttribute("x2", x2); line.setAttribute("y2", y2);
    line.setAttribute("stroke", color);
    line.setAttribute("stroke-width", width);
    line.setAttribute("stroke-linecap", "round");
    if (dashed) line.setAttribute("stroke-dasharray", dashed);
    svg.appendChild(line);
    const size = Math.max(10, width * 4);
    function arrow(fx, fy, tx, ty) {
      const a = Math.atan2(ty - fy, tx - fx);
      const p = (d, r) => [tx - size * Math.cos(a + d), ty - size * Math.sin(a + d)];
      const [lx, ly] = p(0.45);
      const [rx, ry] = p(-0.45);
      const tri = document.createElementNS(SVG, "polygon");
      tri.setAttribute("points", tx + "," + ty + " " + lx + "," + ly + " " + rx + "," + ry);
      tri.setAttribute("fill", color);
      svg.appendChild(tri);
    }
    if (head === "end" || head === "both") arrow(x1, y1, x2, y2);
    if (head === "both") arrow(x2, y2, x1, y1);
    if (getComputedStyle(host).position === "static") host.style.position = "relative";
    host.appendChild(svg);
    el.remove();
  }

  // 아이콘 — 슬라이드에서 쓰는 것만 그린다
  const ICONS = {
    Globe: '<circle cx="12" cy="12" r="9"/><path d="M3 12h18M12 3c3 3.2 3 14.8 0 18M12 3c-3 3.2-3 14.8 0 18"/>',
    Search: '<circle cx="10.5" cy="10.5" r="6.5"/><path d="M15.5 15.5 21 21"/>',
    Check: '<path d="M4 12.5 9.5 18 20 6"/>',
    Warning: '<path d="M12 3 2 20h20L12 3Z"/><path d="M12 10v4M12 17h.01"/>',
    Star: '<path d="m12 3 2.8 5.8 6.2.9-4.5 4.4 1.1 6.3L12 17.5l-5.6 2.9 1.1-6.3L3 9.7l6.2-.9L12 3Z"/>',
    Clock: '<circle cx="12" cy="12" r="9"/><path d="M12 7v5l3 2"/>',
    Lightbulb: '<path d="M9 18h6M10 21h4M12 3a6 6 0 0 0-3.5 10.9c.6.5 1 1.2 1 2.1h5c0-.9.4-1.6 1-2.1A6 6 0 0 0 12 3Z"/>',
  };
  function drawIcon(el) {
    const name = el.getAttribute("name");
    const path = ICONS[name];
    if (!path) return;
    const color = getComputedStyle(el).color || "#17181C";
    el.innerHTML = '<svg viewBox="0 0 24 24" width="100%" height="100%" fill="none" stroke="' + color +
      '" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">' + path + "</svg>";
  }

  // data-crop="배율 X% Y%" — 그림을 확대하고 그 자리를 가운데로
  function applyCrop(img) {
    const parts = (img.getAttribute("data-crop") || "").trim().split(/\s+/);
    const zoom = parseFloat(parts[0]) || 1;
    const x = parts[1] || "50%";
    const y = parts[2] || "50%";
    const box = document.createElement("span");
    box.className = "crop-box";
    box.style.cssText = "display:block;width:" + img.style.width + ";height:" + img.style.height +
      ";border-radius:" + (img.style.borderRadius || "0") + ";" + (img.style.position ? "position:" + img.style.position + ";left:" + img.style.left + ";top:" + img.style.top + ";" : "");
    img.parentNode.insertBefore(box, img);
    box.appendChild(img);
    img.style.position = "static";
    img.style.width = "100%";
    img.style.height = "100%";
    img.style.objectFit = "cover";
    img.style.objectPosition = x + " " + y;
    img.style.transformOrigin = x + " " + y;
    img.style.transform = "scale(" + zoom + ")";
  }

  function prepare(root) {
    root.querySelectorAll("img[data-crop]").forEach(applyCrop);
    root.querySelectorAll("x-icon").forEach(drawIcon);
    root.querySelectorAll("x-connector").forEach(drawConnector);
  }

  // ── 발표 모드 ──
  let current = 0;
  function openPresent(index) {
    const items = document.querySelectorAll(".slides .slide-item");
    const layer = document.querySelector(".present");
    if (!layer || items.length === 0) return;
    current = Math.max(0, Math.min(items.length - 1, index));
    const stage = layer.querySelector(".stage");
    stage.innerHTML = "";
    const frame = items[current].querySelector(".slide-frame").cloneNode(true);
    stage.appendChild(frame);
    layer.classList.add("on");
    layer.querySelector(".count").textContent = (current + 1) + " / " + items.length;
    sizeStage();
  }
  function sizeStage() {
    const layer = document.querySelector(".present.on");
    if (!layer) return;
    const frame = layer.querySelector(".slide-frame");
    const vw = window.innerWidth;
    const vh = window.innerHeight - 56;
    const w = Math.min(vw, vh * W / H);
    frame.style.width = w + "px";
    frame.style.height = (w * H / W) + "px";
    frame.style.aspectRatio = "auto";
    fit(frame);
  }
  function closePresent() {
    const layer = document.querySelector(".present");
    if (layer) layer.classList.remove("on");
  }

  document.addEventListener("DOMContentLoaded", function () {
    prepare(document);
    fitAll();
    window.addEventListener("resize", function () { fitAll(); sizeStage(); });
    if (document.fonts && document.fonts.ready) document.fonts.ready.then(fitAll);

    const layer = document.querySelector(".present");
    document.querySelectorAll("[data-present]").forEach(function (btn) {
      btn.addEventListener("click", function () { openPresent(parseInt(btn.getAttribute("data-present"), 10) || 0); });
    });
    document.querySelectorAll(".slides .slide-frame").forEach(function (frame, i) {
      frame.style.cursor = "zoom-in";
      frame.addEventListener("click", function () { openPresent(i); });
    });
    if (layer) {
      layer.querySelector(".prev").addEventListener("click", function () { openPresent(current - 1); });
      layer.querySelector(".next").addEventListener("click", function () { openPresent(current + 1); });
      layer.querySelector(".close").addEventListener("click", closePresent);
      layer.querySelector(".stage").addEventListener("click", function (e) {
        const half = window.innerWidth / 2;
        openPresent(e.clientX > half ? current + 1 : current - 1);
      });
    }
    document.addEventListener("keydown", function (e) {
      if (!layer || !layer.classList.contains("on")) return;
      if (e.key === "ArrowRight" || e.key === "PageDown" || e.key === " ") { openPresent(current + 1); e.preventDefault(); }
      else if (e.key === "ArrowLeft" || e.key === "PageUp") { openPresent(current - 1); e.preventDefault(); }
      else if (e.key === "Escape") closePresent();
    });
  });
})();
