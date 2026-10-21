#!/usr/bin/perl
# 기획서 슬라이드(claude.ai Slides 원본)를 사이트 페이지로 엮는다.
#
#   perl tools/build_decks.pl
#
# src/decks/<덱>/deck.json의 order 순서로 slides/<id>.html을 읽어 edgerunners/plan/<덱>.html 하나로 만든다.
# 슬라이드의 <aside>(발표자 노트)는 그 장 아래 설명으로 꺼내고, /_blob/<id> 그림은 tools/images.tsv에 적힌
# assets/img/<이름>.webp로 바꾼다. 짝이 없는 그림이 있으면 멈춘다.
use strict;
use warnings;
use utf8;
binmode STDOUT, ':encoding(UTF-8)';
binmode STDERR, ':encoding(UTF-8)';

# 덱 순서와 소개 — 기획 목록 페이지(edgerunners/plan/index.html)와 같은 순서
my @DECKS = (
  ['overview', '개요 기획서', '무슨 게임이고 무엇이 재미인지, 작업 전체를 한눈에'],
  ['combat',   '전투 규칙 기획서', '몸의 수치, 예고 문법, 피해 눈금, 대시로 못 넘기는 것'],
  ['system',   '시스템 기획서', '무기, 사이버웨어 8부위와 레벨, 프로토타입, 해킹, 성장과 경제'],
  ['level',    '레벨 기획서', '손그림에서 플레이까지, 맵 카탈로그, 첫 판 커리큘럼, 보스'],
  ['tutorial', '튜토리얼 기획서', '멈춰서 하나씩 가르치는 숲길 세 단계'],
  ['process',  '개발 과정', '두 달 여덟 구간, 되돌린 결정, 재서 확인하는 방식'],
);

my $root = $0; $root =~ s{[\\/]tools[\\/][^\\/]+$}{}; $root = '.' if $root eq $0;

sub slurp { my ($p) = @_; open my $f, '<:encoding(UTF-8)', $p or die "$p: $!"; local $/; my $t = <$f>; close $f; return $t; }
sub spit { my ($p, $t) = @_; open my $f, '>:encoding(UTF-8)', $p or die "$p: $!"; print $f $t; close $f; }
sub esc { my ($t) = @_; $t =~ s/&/&amp;/g; $t =~ s/</&lt;/g; $t =~ s/>/&gt;/g; return $t; }

my %img;
for my $line (split /\n/, slurp("$root/tools/images.tsv")) {
  next if $line =~ /^\s*(#|$)/;
  my ($id, $name) = split /\t/, $line;
  $img{$id} = $name;
}

my $missing = 0;
for my $i (0 .. $#DECKS) {
  my ($id, $title, $desc) = @{$DECKS[$i]};
  my $dir = "$root/src/decks/$id";
  my $json = slurp("$dir/deck.json");
  my ($order) = $json =~ /"order"\s*:\s*\[(.*?)\]/s or die "$id: order 없음";
  my @ids = $order =~ /"([^"]+)"/g;
  my @items;
  my $n = 0;
  for my $sid (@ids) {
    my $html = slurp("$dir/slides/$sid.html");
    my $note = '';
    if ($html =~ s{<aside>(.*?)</aside>}{}s) { $note = $1; }
    $html =~ s{/_blob/([0-9a-f]{32})}{
      if (exists $img{$1}) { "../../assets/img/$img{$1}.webp" }
      else { warn "$id/$sid: 그림 짝 없음 $1\n"; $missing++; "" }
    }ge;
    $html =~ s/^\s+|\s+$//g;
    $n++;
    my $note_html = $note ne '' ? qq(<p class="slide-note"><span class="num">$n</span>) . esc($note) . "</p>" : '';
    push @items, qq(<div class="slide-item" id="s$n">\n<div class="slide-frame">\n$html\n</div>\n$note_html\n</div>);
  }
  my $count = scalar @ids;
  my $prev = $i > 0 ? qq(<a href="$DECKS[$i-1][0].html">← $DECKS[$i-1][1]</a>) : qq(<a href="./">← 기획서 목록</a>);
  my $next = $i < $#DECKS ? qq(<a href="$DECKS[$i+1][0].html">$DECKS[$i+1][1] →</a>) : qq(<a href="./">기획서 목록 →</a>);
  my $body = join("\n", @items);
  my $page = <<"HTML";
<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>$title · Edgerunners</title>
<meta name="description" content="Edgerunners $title — $desc">
<link rel="stylesheet" href="../../assets/css/site.css">
<link rel="stylesheet" href="../../assets/css/deck.css">
<script src="../../assets/js/deck.js" defer></script>
</head>
<body>
<div class="scroll-root">
<header class="site-head"><div class="wrap">
<a class="brand" href="../../">[이름]</a>
<nav><a href="../../">홈</a><a class="on" href="../">Edgerunners</a></nav>
</div></header>
<main class="wrap">
<nav class="tabs"><a href="../">게임</a><a class="on" href="./">기획</a></nav>
<div class="deck-head">
<p class="eyebrow">Edgerunners 기획서</p>
<h1>$title</h1>
<p class="lead">$desc</p>
<div class="deck-tools">
<button class="btn" type="button" data-present="0">슬라이드로 넘겨 보기</button>
<span class="small">${count}장 · 장을 누르면 크게 보고, 화살표 키로 넘긴다</span>
</div>
</div>
<div class="slides">
$body
</div>
<nav class="deck-nav">$prev $next</nav>
</main>
<footer class="foot"><div class="wrap">글꼴: 페이퍼로지(Paperlogy, SIL OFL 1.1)</div></footer>
</div>
<div class="present" aria-modal="true" role="dialog">
<div class="stage"></div>
<div class="bar"><button class="prev" type="button">← 이전</button><span class="count"></span><button class="next" type="button">다음 →</button><button class="close" type="button">닫기 (Esc)</button></div>
</div>
</body>
</html>
HTML
  spit("$root/edgerunners/plan/$id.html", $page);
  print "$id: ${count}장\n";
}
die "짝이 없는 그림 ${missing}개 — tools/images.tsv에 넣을 것\n" if $missing;
