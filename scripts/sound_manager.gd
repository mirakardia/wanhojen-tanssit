extends Node

# Simple effects
# SoundManager.valikko_valinta.play() 
# jne.
@onready var sfx_valikko_valinta: AudioStreamPlayer = $SfxValikkoValinta
@onready var sfx_molkyn_puhe: AudioStreamPlayer = $SfxMolkynPuhe

# Background music
# SoundManager.play_bgm("bgm_name")
# SoundManager.strop_bgm()
var current_bgm = null

@onready var bgm_list = {
		"bgm_none" = null,
		"bgm_sakari" = $BgmSakari,
		"bgm_molkky" = $BgmMolkky
		}

#region Audio pools OBSOLETE
# SoundManager.play_random("AudioPool")


var audio_pools = {}

func _ready() -> void:
	var all_audio_pool_nodes = get_children()
	
	for pool in all_audio_pool_nodes:
		var nimi = pool.name
		audio_pools[nimi] = []
		var all_sound_variants = pool.get_children()
		
		for sound_variant in all_sound_variants:
			audio_pools[nimi].push_back(sound_variant)
#endregion

var gibberish_freq : int = 10
var gibberish_count : int = gibberish_freq

func speak_gibberish(profile = "default") -> void:
	gibberish_count -= 1
		
	if gibberish_count == 0:
		gibberish_count = gibberish_freq
		
		
		match profile:
			"molkky":
				sfx_molkyn_puhe.play()
			"default":
				sfx_molkyn_puhe.play()

func play_bgm(song) -> void :
	if current_bgm != song:
		stop_bgm()
		current_bgm = song
		bgm_list[song].play()

func stop_bgm() -> void :
	if current_bgm != null:
		bgm_list[current_bgm].stop()
		current_bgm = null
		
#region Obsolete
# Obsolete
# Randomisointi hoituu helpommin suoraan assetin kautta
func play_random(pool) -> void :
	var pool_size = len(audio_pools[pool])
	var stream = randi_range(0, pool_size - 1)
	audio_pools[pool][stream].play()
#endregion
