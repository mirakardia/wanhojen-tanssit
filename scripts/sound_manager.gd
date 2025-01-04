extends Node

# Simple effects
# SoundManager.valikko_valinta.play() 
# jne.
@onready var sfx_puhe_molkky: AudioStreamPlayer = $SfxPuheMolkky
@onready var sfx_puhe_afrikka: AudioStreamPlayer = $SfxPuheAfrikka
@onready var sfx_puhe_birb: AudioStreamPlayer = $SfxPuheBirb
@onready var sfx_puhe_pallomato: AudioStreamPlayer = $SfxPuhePallomato
@onready var sfx_puhe_villa: AudioStreamPlayer = $SfxPuheVilla
@onready var sfx_puhe_generic: AudioStreamPlayer = $SfxPuheGeneric
@onready var sfx_valinta_valikko: AudioStreamPlayer = $SfxValintaValikko

# Background music
# SoundManager.play_bgm("bgm_name")
# SoundManager.strop_bgm()
var current_bgm = null

@onready var bgm_list = {
		"bgm_none" = null,
		"bgm_sakari" = $BgmSakari,
		"bgm_molkky" = $BgmMolkky,
		"bgm_afrikka" = $BgmAfrikka,
		"bgm_pallomato" = $BgmPallomato,
		"bgm_title" = $BgmTitle,
		"bgm_overworld" = $BgmOverworld,
		"bgm_overworld2" = $BgmOverworld2,
		"bgm_overworld3" = $BgmOverworld3,
		"bgm_overworld4" = $BgmOverworld4,
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
		profile = profile.to_lower()
		
		match profile:
			"molkky", "mölkky", "mölkkypölkky", "mölkky-pölkky":
				sfx_puhe_molkky.play()
			"afrikka", "afrikantähti", "afrikan tähti", "afrikan":
				sfx_puhe_afrikka.play()
			"birb", "bird", "angsty", "angsty birb", "angry bird":
				sfx_puhe_birb.play()
			"pallomato", "mato ja pallo", "pallo ja mato", "pallo", "mato":
				sfx_puhe_pallomato.play()
			"villapaita", "villa", "sakari", "sakarin villapaita": 
				sfx_puhe_villa.play()
			"default":
				sfx_puhe_generic.play()

func play_bgm(song: String) -> void :
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
