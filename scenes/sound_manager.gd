extends Node

# Yksinkertaiset äänet
@onready var valikko_valinta: AudioStreamPlayer = $ValikkoValinta

# Audio poolit
@onready var sakarin_puhe_pool: Node = $SakarinPuhe

# Taustamusiikki
@onready var bgm_list = {
		"bgm_none" = null,
		"bgm_sakari" = $BgmSakari,
		"bgm_molkky" = $BgmMolkky
		}

var audio_pools = {}
var current_bgm = null

func _ready() -> void:
	var children = get_children()
	for child in children:
		var nimi = child.name
		audio_pools[nimi] = []
		var aanet = child.get_children()
		for grandchild in aanet:
			audio_pools[nimi].push_back(grandchild)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func play_random(pool) -> void :
	var pool_size = len(audio_pools[pool])
	var stream = randi_range(0, pool_size - 1)
	audio_pools[pool][stream].play()

func play_bgm(song) -> void :
	if current_bgm != song:
		stop_bgm()
		current_bgm = song
		bgm_list[song].play()

func stop_bgm() -> void :
	if current_bgm != null:
		bgm_list[current_bgm].stop()
		current_bgm = null
