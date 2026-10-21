extends SceneTree

# PNG · JPG를 사이트용 WebP로 줄인다. 이 PC에 이미지 도구가 없어서 Godot로 한다.
#
#   godot --headless --script tools/to_webp.gd -- <원본 폴더> <출력 폴더> <가로 최대> <이름> <이름> …
#
# 이름마다 <원본 폴더>/<이름>.png(없으면 .jpg)를 읽어 <출력 폴더>/<이름>.webp로 쓴다.
# 가로가 <가로 최대>를 넘으면 비율을 지켜 줄인다. 이미 있는 출력은 원본이 더 새로울 때만 다시 만든다.

const QUALITY := 0.85


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() < 4:
		printerr("인자: <원본 폴더> <출력 폴더> <가로 최대> <이름> …")
		quit(1)
		return
	var src_dir := args[0]
	var out_dir := args[1]
	var max_w := int(args[2])
	DirAccess.make_dir_recursive_absolute(out_dir)
	var made := 0
	for i in range(3, args.size()):
		var name := args[i]
		var src := "%s/%s.png" % [src_dir, name]
		if not FileAccess.file_exists(src):
			src = "%s/%s.jpg" % [src_dir, name]
		if not FileAccess.file_exists(src):
			printerr("없음: ", name)
			continue
		var dst := "%s/%s.webp" % [out_dir, name]
		if FileAccess.file_exists(dst) and FileAccess.get_modified_time(dst) >= FileAccess.get_modified_time(src):
			continue
		var image := Image.load_from_file(src)
		if image == null or image.is_empty():
			printerr("못 읽음: ", src)
			continue
		if image.get_width() > max_w:
			var h := int(round(float(image.get_height()) * max_w / image.get_width()))
			image.resize(max_w, h, Image.INTERPOLATE_LANCZOS)
		var err := image.save_webp(dst, true, QUALITY)
		if err != OK:
			printerr("못 씀: ", dst, " ", err)
			continue
		made += 1
	print("WebP %d장 만듦" % made)
	quit(0)
