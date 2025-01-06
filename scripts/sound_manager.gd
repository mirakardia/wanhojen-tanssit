extends Node

# Simple effects
# SoundManager.valikko_valinta.play() 
# jne.
@onready var sfx_puhe_molkky: AudioStreamPlayer = $SfxPuheMolkky
@onready var sfx_puhe_afrikka: AudioStreamPlayer = $SfxPuheAfrikka
@onready var sfx_puhe_birb: AudioStreamPlayer = $SfxPuheBirb
@onready var sfx_puhe_pallomato: AudioStreamPlayer = $SfxPuhePallomato
@onready var sfx_puhe_pallo: AudioStreamPlayer = $SfxPuhePallo
@onready var sfx_puhe_mato: AudioStreamPlayer = $SfxPuheMato
@onready var sfx_puhe_villa: AudioStreamPlayer = $SfxPuheVilla
@onready var sfx_puhe_generic: AudioStreamPlayer = $SfxPuheGeneric
@onready var sfx_valinta_valikko: AudioStreamPlayer = $SfxValintaValikko
@onready var sfx_valinta_keskustelu: AudioStreamPlayer = $SfxValintaKeskustelu
@onready var sfx_map_ovi: AudioStreamPlayer = $SfxMapOvi
@onready var sfx_keskustelu_ilahtuu: AudioStreamPlayer = $SfxKeskusteluIlahtuu
@onready var sfx_rollover: AudioStreamPlayer = $SfxRollover

# Background music
# SoundManager.play_bgm("bgm_name")
# SoundManager.strop_bgm()
var current_bgm = null

@onready var bgm_list = {
		"bgm_none" = null,
		"bgm_sakari" = $BgmSakari,
		"bgm_molkky" = $BgmMolkky,
		"bgm_afrikka" = $BgmAfrikka,
		"bgm_birb" = $BgmBirb,
		"bgm_pallomato" = $BgmPallomato,
		"bgm_title" = $BgmTitle,
		"bgm_overworld" = $BgmOverworld,
		"bgm_overworld2" = $BgmOverworld2,
		"bgm_overworld3" = $BgmOverworld3,
		"bgm_overworld4" = $BgmOverworld4,
		}

var gibberish_freq : int = 10
var gibberish_count : int = gibberish_freq
var gibberish_profile : String = "default"

# Volume control
@onready var bus_master : int = AudioServer.get_bus_index("Master")
@onready var bus_bgm : int = AudioServer.get_bus_index("Bgm")
@onready var bus_sfx : int = AudioServer.get_bus_index("Sfx")
@onready var bus_speech : int = AudioServer.get_bus_index("Speech")

@onready var bus_list = {
		"master" : bus_master,
		"bgm" : bus_bgm,
		"sfx" : bus_sfx,
		"speech" : bus_speech
		}

func _ready() -> void:
	play_bgm("bgm_overworld")

func test_sfx() -> void:
	sfx_rollover.play()

func set_volume(vol : float, bus : String = "master") -> void:
	AudioServer.set_bus_volume_db(
			SoundManager.bus_list[bus],
			linear_to_db(vol)
	)
	
func get_volume(bus : String = "master") -> float:
	var bus_id = bus_list[bus]
	var return_value = db_to_linear(
		AudioServer.get_bus_volume_db(bus_id)
	)
	return return_value
	
func set_mute(mute_or_unmute : bool = true, bus : String = "master") -> void:
	AudioServer.set_bus_mute(
			SoundManager.bus_list[bus],
			mute_or_unmute
	)

func set_gibberish_profile(profile : String = "default") -> void:
	SoundManager.gibberish_profile = profile.to_lower()
	
func get_gibberish_profile() -> String:
	return SoundManager.gibberish_profile

func speak_gibberish() -> void:
	gibberish_count -= 1
		
	if gibberish_count == 0:
		gibberish_count = gibberish_freq
				
		match gibberish_profile:
			"molkky", "mölkky", "mölkkypölkky", "mölkky-pölkky":
				sfx_puhe_molkky.play()
			"kimble":
				sfx_puhe_mato.play()
			"tähti", "tahti", "afrikka", "afrikantähti", "afrikan tähti", "afrikan":
				sfx_puhe_afrikka.play()
			"angsty_birb", "birb", "bird", "angsty", "angsty_birb", "angry bird":
				sfx_puhe_villa.play()
			"pallomato", "mato ja pallo", "pallo ja mato", "bounce ja mato", "mato ja bounce":
				sfx_puhe_pallomato.play()
			"pallo", "bounce", "kimble":
				sfx_puhe_pallo.play()
			"mato":
				sfx_puhe_mato.play()
			"villapaita", "villa", "sakari", "sakarin villapaita": 
				sfx_puhe_villa.play()
			"default", _:
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
		
