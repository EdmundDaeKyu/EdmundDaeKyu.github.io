#!/usr/bin/perl
# 기획서 · 작업 내역 슬라이드(claude.ai Slides 원본)를 사이트 페이지로 엮는다.
#
#   perl tools/build_decks.pl
#
# src/decks/<덱>/deck.json의 order 순서로 slides/<id>.html을 읽어 페이지 하나로 만든다.
# 기획서 덱은 edgerunners/plan/<덱>.html, 작업 내역 덱은 edgerunners/log/index.html,
# 역기획서 덱은 analysis/<덱>.html로 나간다. 기획서 목록(edgerunners/plan/index.html)과
# 역기획서 목록(analysis/index.html)도 여기서 만든다(장 수가 덱과 어긋나지 않게).
#
# 장마다 아래에 붙는 설명은 src/decks/<덱>/notes/<id>.md에서 온다(형식: tools/NOTES_FORMAT.md).
# 그 파일이 없으면 슬라이드의 <aside>(발표자 노트)를 한 문단으로 쓴다.
# /_blob/<id> 그림은 tools/images.tsv에 적힌 assets/img/<이름>.webp로 바꾸고, 짝이 없으면 멈춘다.
use strict;
use warnings;
use utf8;
binmode STDOUT, ':encoding(UTF-8)';
binmode STDERR, ':encoding(UTF-8)';

# [id, 묶음, 제목, 목록 카드 이름, 소개, 목록 카드 그림]
my @DECKS = (
  ['overview', 'plan', '개요 기획서', '개요 기획서', '어떤 게임인지, 빌드 조합과 2077과 다르게 쓴 무기와 사이버웨어, 한 판의 구조를 정리했다.', 'portfolio_hero'],
  ['combat',   'plan', '전투 규칙 기획서', '전투 규칙', '기본 능력치, 공격 예고 규칙, 피해 기준, 대시로 피할 수 없는 위협.', 'portfolio_crowd'],
  ['system',   'plan', '시스템 기획서', '시스템', '무기, 사이버웨어 8부위와 레벨, 프로토타입, 해킹, 성장과 경제.', 'portfolio_netrunner'],
  ['level',    'plan', '레벨 기획서', '레벨', '맵 제작 과정, 맵 목록, 첫 판의 등장 순서, 보스.', 'combat_pinwheel_top'],
  ['tutorial', 'plan', '튜토리얼 기획서', '튜토리얼', '첫 판에만 진행하는 숲속 맵 세 개와, 시간을 멈추고 가르치는 코칭 컷.', 'trail_overview_1'],
  ['growth',   'plan', '성장 기획서', '성장', '경험치, 명상, 숙련도, 코인, 회차와, 죽었을 때 남는 것.', 'growth_meditation'],
  ['process',  'log',  '작업 내역', '작업 내역', '두 달 동안의 개발 과정과 되돌린 결정, 플레이하며 바꾼 것.', 'portfolio_boss'],
  # 역기획서 — 다른 게임의 레벨 · 시스템을 기획자 입장에서 다시 읽은 덱. 목록과 홈 카드에 이 순서로 나간다
  ['lol1',     'study', '소환사의 협곡 레벨디자인 역기획 (1편)', '소환사의 협곡 레벨디자인', '세 갈래 길과 정글, 오브젝트, 시야 배치가 대칭 속 공정성과 역할 분담, 국면 전환을 만드는 구조를 정리했다.', 'lol1_01', '리그 오브 레전드'],
  ['lol2',     'study', '소환사의 협곡 미니언·포탑 시스템 기획 (2편)', '미니언 · 포탑 시스템 기획', '미니언의 골드 · 경험치와 포탑 수치를 설계 목표에서부터 정하고, 라인전 경제와 14분 기준점, 격차 보완 기획까지 다뤘다.', 'lol2_02', '리그 오브 레전드'],
  ['limgrave', 'study', '엘든 링 림그레이브 레벨디자인 분석', '림그레이브 레벨디자인', '지도 · 밀도 · 시야 · 사정거리로 첫 보스 멀기트까지 플레이어를 학습시키는 구조를 분석하고, 초반 이탈을 줄이는 신호 설계를 제안했다.', 'limgrave_card', '엘든 링'],
  ['genshin',  'study', '원신 몬드 레벨디자인 역기획', '몬드 레벨디자인', '몬드성과 신상을 기준점으로 외곽 보스 · 보상 배치와 정비 · 탐험 순환이 탐험 범위를 넓혀 가는 구조를 정리하고 개선안을 제안했다.', 'genshin_01', '원신'],
  ['clash',    'study', '클래시로얄 레벨디자인 역기획', '아레나 레벨디자인', '고정된 전장의 대칭과 다리 · 강이 만드는 선택, 엘릭서 비용, 공격과 방어의 분화를 정리하고 전장 변경안을 제안했다.', 'clash_01', '클래시 로얄'],
);

my $root = $0; $root =~ s{[\\/]tools[\\/][^\\/]+$}{}; $root = '.' if $root eq $0;

sub slurp { my ($p) = @_; open my $f, '<:encoding(UTF-8)', $p or die "$p: $!"; local $/; my $t = <$f>; close $f; return $t; }
sub spit { my ($p, $t) = @_; open my $f, '>:encoding(UTF-8)', $p or die "$p: $!"; print $f $t; close $f; }
sub esc { my ($t) = @_; $t =~ s/&/&amp;/g; $t =~ s/</&lt;/g; $t =~ s/>/&gt;/g; return $t; }

# ── 설명(notes/<id>.md) → HTML ──

sub inline {
  my ($t) = @_;
  $t = esc($t);
  $t =~ s{`([^`]+)`}{<code>$1</code>}g;
  $t =~ s{\*\*([^*]+)\*\*}{<strong>$1</strong>}g;
  $t =~ s{\[([^\]]+)\]\(([^)\s]+)\)}{<a href="$2">$1</a>}g;
  return $t;
}

sub table_html {
  my @rows = @_;
  my $h = qq(<div class="n-table"><table>\n);
  for my $i (0 .. $#rows) {
    my $r = $rows[$i];
    $r =~ s/^\s*\|//; $r =~ s/\|\s*$//;
    my @c = map { my $x = $_; $x =~ s/^\s+|\s+$//g; $x =~ s/\\\|/|/g; inline($x) } split /(?<!\\)\|/, $r;
    my $tag = $i == 0 ? 'th' : 'td';
    $h .= '<tr>' . join('', map { "<$tag>$_</$tag>" } @c) . "</tr>\n";
  }
  return $h . "</table></div>\n";
}

sub item_parts {
  my ($t) = @_;
  my ($a, $b) = split /\s+\|\s+/, $t, 2;
  return (inline($a), defined $b ? inline($b) : '');
}

sub fence_html {
  my ($kind, $items, $raw, $where) = @_;
  if ($kind eq 'svg') {
    die "$where: ::: svg 안에 <svg>가 없다\n" unless $raw =~ /<svg\b/;
    return qq(<div class="n-svg">$raw</div>\n);
  }
  die "$where: ::: $kind 안에 항목이 없다\n" unless @$items;
  my %tag = (flow => ['ol', 'n-flow', 'li'], cards => ['div', 'n-cards', 'div'], stats => ['div', 'n-stats', 'div']);
  my $t = $tag{$kind} or die "$where: 모르는 블록 ::: $kind\n";
  my ($outer, $class, $inner) = @$t;
  my $h = qq(<$outer class="$class">);
  for my $it (@$items) {
    my ($a, $b) = item_parts($it);
    $h .= "<$inner><b>$a</b>" . ($b ne '' ? "<span>$b</span>" : '') . "</$inner>";
  }
  return $h . "</$outer>\n";
}

sub render_note {
  my ($md, $where) = @_;
  $md =~ s/\r//g;
  my $head = '';     # 첫 ## 앞(칸 밖, 전체 폭)
  my @boxes;         # [제목, 전체 폭?, html]
  my $html = '';
  my $list = '';
  my @rows;
  my ($fence, @items, $raw);
  my $flush = sub {
    if ($list ne '') { $html .= "</$list>\n"; $list = ''; }
    if (@rows) { $html .= table_html(@rows); @rows = (); }
  };
  my $close = sub {
    $flush->();
    if (@boxes) { $boxes[-1][2] = $html; } else { $head = $html; }
    $html = '';
  };
  for my $line (split /\n/, $md) {
    if (defined $fence) {
      if ($line =~ /^:::\s*$/) { $html .= fence_html($fence, \@items, $raw, $where); undef $fence; next; }
      if ($fence eq 'svg') { $raw .= "$line\n"; next; }
      next if $line =~ /^\s*$/;
      if ($line =~ /^-\s+(.*?)\s*$/) { push @items, $1; next; }
      die "$where: ::: $fence 안에는 '- ' 항목만 쓴다: $line\n";
    }
    if ($line =~ /^:::\s*(\w+)\s*$/) { $flush->(); $fence = $1; @items = (); $raw = ''; next; }
    if ($line =~ /^##\s+(.*?)\s*$/) {
      $close->();
      my $t = $1;
      my $wide = $t =~ s/\s*!wide$// ? 1 : 0;
      push @boxes, [inline($t), $wide, ''];
      next;
    }
    if ($line =~ /^###\s+(.*?)\s*$/) { $flush->(); $html .= '<h4>' . inline($1) . "</h4>\n"; next; }
    if ($line =~ /^>\s*(.*?)\s*$/) { $flush->(); $html .= '<p class="n-key">' . inline($1) . "</p>\n"; next; }
    if ($line =~ /^\s*\|/) {
      if ($list ne '') { $html .= "</$list>\n"; $list = ''; }
      push @rows, $line unless $line =~ /^\s*\|[\s:|-]+\|\s*$/;
      next;
    }
    if ($line =~ /^-\s+(.*?)\s*$/ || $line =~ /^\d+\.\s+(.*?)\s*$/) {
      my $text = $1;
      my $want = $line =~ /^-/ ? 'ul' : 'ol';
      if ($list ne $want) { $flush->(); $html .= "<$want>\n"; $list = $want; }
      $html .= '<li>' . inline($text) . "</li>\n";
      next;
    }
    if ($line =~ /^\s*$/) { $flush->(); next; }
    $flush->();
    $line =~ s/^\s+|\s+$//g;
    $html .= '<p>' . inline($line) . "</p>\n";
  }
  die "$where: ::: $fence 블록이 닫히지 않았다\n" if defined $fence;
  $close->();
  my $narrow = grep { !$_->[1] } @boxes;
  my $cols = $narrow <= 1 ? 1 : ($narrow == 2 || $narrow == 4) ? 2 : 3;
  my $grid = join('', map {
    qq(<div class="n-box) . ($_->[1] ? ' wide' : '') . qq("><h3>$_->[0]</h3>\n$_->[2]</div>\n)
  } @boxes);
  return ($head, @boxes ? qq(<div class="n-grid c$cols">\n$grid</div>\n) : '');
}

# ── 그림 짝 ──

my %img;
for my $line (split /\n/, slurp("$root/tools/images.tsv")) {
  next if $line =~ /^\s*(#|$)/;
  my ($id, $name) = split /\t/, $line;
  $img{$id} = $name;
}

sub page_path {
  my ($d) = @_;
  return 'edgerunners/log/index.html' if $d->[1] eq 'log';
  return "analysis/$d->[0].html" if $d->[1] eq 'study';
  return "edgerunners/plan/$d->[0].html";
}

# 사이트 뿌리까지의 상대 경로. edgerunners/<묶음>/는 두 단계, analysis/는 한 단계 아래다
sub up_of { my ($group) = @_; return $group eq 'study' ? '../' : '../../'; }

# 같은 묶음 안에서 앞뒤 덱 링크. Edgerunners 페이지는 edgerunners/<묶음>/, 역기획서는 analysis/ 아래에 있다.
sub link_to {
  my ($from, $to) = @_;
  my $file = $to->[1] eq 'log' ? '' : "$to->[0].html";
  return $from->[1] eq $to->[1] ? ($file eq '' ? './' : $file) : "../$to->[1]/$file";
}

sub tabs {
  my ($on) = @_;
  my @t = (['game', '../', '게임'], ['plan', '../plan/', '기획서'], ['log', '../log/', '작업 내역']);
  return '<nav class="tabs">' . join('', map { '<a' . ($_->[0] eq $on ? ' class="on"' : '') . qq( href="$_->[1]">$_->[2]</a>) } @t) . '</nav>';
}

# 머리 메뉴. $on은 'edgerunners' 또는 'analysis'
sub site_nav {
  my ($up, $on) = @_;
  my @m = (['home', '', '홈'], ['edgerunners', 'edgerunners/', 'Edgerunners'], ['analysis', 'analysis/', '역기획서']);
  return '<nav>' . join('', map { '<a' . ($_->[0] eq $on ? ' class="on"' : '') . qq( href="$up$_->[1]">$_->[2]</a>) } @m) . '</nav>';
}

sub shell {
  my (%a) = @_;
  $a{up} //= '../../';
  $a{nav} //= site_nav($a{up}, 'edgerunners');
  return <<"HTML";
<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>$a{title}</title>
<meta name="description" content="$a{desc}">
<link rel="stylesheet" href="$a{up}assets/css/site.css">
$a{head}</head>
<body>
<div class="scroll-root">
<header class="site-head"><div class="wrap">
<a class="brand" href="$a{up}">장대규</a>
$a{nav}
</div></header>
<main class="wrap">
$a{tabs}
$a{body}</main>
<footer class="foot"><div class="wrap">© 장대규 · 글꼴: 페이퍼로지(Paperlogy, SIL OFL 1.1)</div></footer>
</div>
$a{tail}</body>
</html>
HTML
}

my $missing = 0;
my %count;
my @plan = grep { $_->[1] eq 'plan' } @DECKS;
for my $d (@DECKS) {
  my ($id, $group, $title, $short, $desc) = @$d;
  my $up = up_of($group);
  my $dir = "$root/src/decks/$id";
  my $json = slurp("$dir/deck.json");
  my ($order) = $json =~ /"order"\s*:\s*\[(.*?)\]/s or die "$id: order 없음";
  my @ids = $order =~ /"([^"]+)"/g;
  my @items;
  my $n = 0;
  my $notes = 0;
  for my $sid (@ids) {
    my $html = slurp("$dir/slides/$sid.html");
    my $aside = '';
    if ($html =~ s{<aside>(.*?)</aside>}{}s) { $aside = $1; $aside =~ s/^\s+|\s+$//g; }
    $html =~ s{/_blob/([0-9a-f]{32})}{
      if (exists $img{$1}) { "${up}assets/img/$img{$1}.webp" }
      else { warn "$id/$sid: 그림 짝 없음 $1\n"; $missing++; "" }
    }ge;
    $html =~ s/^\s+|\s+$//g;
    $n++;
    my $num = sprintf '%02d', $n;
    my $note_html = '';
    my $md_path = "$dir/notes/$sid.md";
    if (-e $md_path) {
      my ($head, $grid) = render_note(slurp($md_path), "$id/notes/$sid.md");
      $note_html = qq(<div class="slide-note"><div class="n-head"><span class="num">$num</span><div class="n-lead">\n$head</div></div>\n$grid</div>);
      $notes++;
    } elsif ($aside ne '') {
      $note_html = qq(<div class="slide-note"><div class="n-head"><span class="num">$num</span><div class="n-lead"><p>) . esc($aside) . '</p></div></div></div>';
    }
    push @items, qq(<div class="slide-item" id="s$n">\n<div class="slide-frame">\n$html\n</div>\n$note_html\n</div>);
  }
  my $count = scalar @ids;
  $count{$id} = $count;

  my @same = grep { $_->[1] eq $group } @DECKS;
  my ($pos) = grep { $same[$_][0] eq $id } 0 .. $#same;
  my %first = (plan => '<a href="./">← 기획서 목록</a>', log => '<a href="../plan/">← 기획서</a>', study => '<a href="./">← 역기획서 목록</a>');
  my %last = (plan => '<a href="../log/">작업 내역 →</a>', log => '<a href="../">게임 →</a>', study => '<a href="./">역기획서 목록 →</a>');
  my $prev = $pos > 0 ? '<a href="' . link_to($d, $same[$pos - 1]) . "\">← $same[$pos - 1][2]</a>" : $first{$group};
  my $next = $pos < $#same ? '<a href="' . link_to($d, $same[$pos + 1]) . "\">$same[$pos + 1][2] →</a>" : $last{$group};
  my $eyebrow = $group eq 'plan' ? 'Edgerunners 기획서' : $group eq 'study' ? "역기획서 · $d->[6]" : 'Edgerunners';
  my $site = $group eq 'study' ? '장대규 역기획서' : 'Edgerunners';
  my $body = join("\n", @items);
  my $page = shell(
    title => "$title · $site",
    desc => "$site $title. $desc",
    up => $up,
    nav => site_nav($up, $group eq 'study' ? 'analysis' : 'edgerunners'),
    head => qq(<link rel="stylesheet" href="${up}assets/css/deck.css">\n<script src="${up}assets/js/deck.js" defer></script>\n),
    tabs => $group eq 'study' ? '' : tabs($group),
    body => <<"HTML",
<div class="deck-head">
<p class="eyebrow">$eyebrow</p>
<h1>$title</h1>
<p class="lead">$desc</p>
<div class="deck-tools">
<button class="btn" type="button" data-present="0">슬라이드로 넘겨 보기</button>
<span class="small">${count}장 · 슬라이드를 누르면 크게 보고, 화살표 키로 넘긴다</span>
</div>
</div>
<div class="slides">
$body
</div>
<nav class="deck-nav">$prev $next</nav>
HTML
    tail => <<"HTML",
<div class="present" aria-modal="true" role="dialog">
<div class="stage"></div>
<div class="bar"><button class="prev" type="button">← 이전</button><span class="count"></span><button class="next" type="button">다음 →</button><button class="close" type="button">닫기 (Esc)</button></div>
</div>
HTML
  );
  my $out = page_path($d);
  (my $dir_out = $out) =~ s{/[^/]+$}{};
  mkdir "$root/$dir_out" unless -d "$root/$dir_out";
  spit("$root/$out", $page);
  print "$id: ${count}장, 설명 파일 ${notes}개 → $out\n";
}

# ── 기획서 목록 ──
my ($main, @rest) = @plan;
my $cards = qq(<a class="card deck-card main" href="$main->[0].html">\n<img src="../../assets/img/$main->[5].webp" alt="">\n)
  . qq(<div class="body"><span class="num">개요</span><h3>$main->[3]</h3><p>$main->[4]</p><span class="count">$count{$main->[0]}장</span></div>\n</a>\n);
my $k = 0;
for my $d (@rest) {
  $k++;
  my $label = sprintf '세부 %02d', $k;
  $cards .= qq(<a class="card deck-card" href="$d->[0].html">\n<img src="../../assets/img/$d->[5].webp" alt="">\n)
    . qq(<div class="body"><span class="num">$label</span><h3>$d->[3]</h3><p>$d->[4]</p><span class="count">$count{$d->[0]}장</span></div>\n</a>\n);
}
my $n_detail = scalar @rest;
spit("$root/edgerunners/plan/index.html", shell(
  title => 'Edgerunners · 기획서',
  desc => 'Edgerunners 기획서. 개요 기획서와 전투 규칙, 시스템, 레벨, 튜토리얼, 성장 세부 기획서.',
  head => <<'HTML',
<style>
  .plan-head { padding: 40px 0 8px; }
  .plan-head h1 { font-size: 46px; margin: 8px 0 12px; }
  .decks { padding: 32px 0 72px; }
  .deck-card { display: flex; flex-direction: column; color: var(--ink); transition: border-color 0.15s, transform 0.15s; }
  .deck-card:hover { text-decoration: none; border-color: var(--ink-3); transform: translateY(-2px); }
  .deck-card img { width: 100%; aspect-ratio: 16 / 9; object-fit: cover; background: var(--dark); }
  .deck-card .body { display: flex; flex-direction: column; gap: 6px; }
  .deck-card .num { font-family: var(--semi); font-size: 13px; color: var(--accent); }
  .deck-card p { color: var(--ink-3); font-size: 15px; }
  .deck-card .count { font-size: 13px; color: var(--ink-4); margin-top: 4px; }
  .deck-card.main { grid-column: 1 / -1; display: grid; grid-template-columns: minmax(0, 1.3fr) minmax(0, 1fr); }
  .deck-card.main img { height: 100%; aspect-ratio: auto; min-height: 300px; }
  .deck-card.main .body { padding: 36px; justify-content: center; }
  .deck-card.main h3 { font-size: 32px; }
  /* 좁은 화면에서는 다른 카드와 같은 세로 짜임으로 둔다. grid 안의 그림에 height: 100%가 남으면 모바일 브라우저에 따라 그림 높이가 틀어져 아래 글씨를 덮었다 */
  @media (max-width: 900px) {
    .deck-card.main { display: flex; }
    .deck-card.main img { height: auto; min-height: 0; aspect-ratio: 16 / 9; }
    .deck-card.main .body { padding: 24px; }
    .deck-card.main h3 { font-size: 26px; }
  }
</style>
HTML
  tabs => tabs('plan'),
  body => <<"HTML",
<div class="plan-head">
<p class="eyebrow">Edgerunners 기획서</p>
<h1>기획서</h1>
<p class="lead">전체 구조를 정리한 개요 기획서 하나와 주제별 세부 기획서 ${n_detail}개로 나눴다.<br>슬라이드마다 아래에 항목별 설명을 붙였다. 개발 과정은 <a href="../log/">작업 내역</a>에 따로 정리했다.</p>
</div>
<div class="grid two decks">
$cards</div>
HTML
  tail => '',
));
print 'plan/index.html: 기획서 ' . scalar(@plan) . "개\n";

# ── 역기획서 목록 ──
my @study = grep { $_->[1] eq 'study' } @DECKS;
my $scards = '';
for my $d (@study) {
  $scards .= qq(<a class="card deck-card" href="$d->[0].html">\n<img src="../assets/img/$d->[5].webp" alt="">\n)
    . qq(<div class="body"><span class="num">$d->[6]</span><h3>$d->[3]</h3><p>$d->[4]</p><span class="count">$count{$d->[0]}장</span></div>\n</a>\n);
}
spit("$root/analysis/index.html", shell(
  title => '장대규 · 역기획서',
  desc => '게임 기획 역기획서. ' . join(', ', map { $_->[2] } @study) . '.',
  up => '../',
  nav => site_nav('../', 'analysis'),
  head => <<'HTML',
<style>
  .plan-head { padding: 40px 0 8px; }
  .plan-head h1 { font-size: 46px; margin: 8px 0 12px; }
  .decks { padding: 32px 0 72px; }
  .deck-card { display: flex; flex-direction: column; color: var(--ink); transition: border-color 0.15s, transform 0.15s; }
  .deck-card:hover { text-decoration: none; border-color: var(--ink-3); transform: translateY(-2px); }
  .deck-card img { width: 100%; aspect-ratio: 16 / 9; object-fit: cover; background: var(--dark); }
  .deck-card .body { display: flex; flex-direction: column; gap: 6px; }
  .deck-card .num { font-family: var(--semi); font-size: 13px; color: var(--accent); }
  .deck-card p { color: var(--ink-3); font-size: 15px; }
  .deck-card .count { font-size: 13px; color: var(--ink-4); margin-top: 4px; }
</style>
HTML
  tabs => '',
  body => <<"HTML",
<div class="plan-head">
<p class="eyebrow">역기획서</p>
<h1>역기획서</h1>
<p class="lead">출시된 게임의 레벨과 시스템을 기획자 입장에서 다시 설계해 본 문서다.<br>각 구조가 어떤 목표를 위해 그 수치와 배치로 정해졌는지 정리하고, 문제가 보이는 부분은 보완 기획을 붙였다.</p>
</div>
<div class="grid two decks">
$scards</div>
HTML
  tail => '',
));
print 'analysis/index.html: 역기획서 ' . scalar(@study) . "개\n";
die "짝이 없는 그림 ${missing}개 — tools/images.tsv에 넣을 것\n" if $missing;
