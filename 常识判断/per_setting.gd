extends Control
@onready var confirm_button = $ConfirmButton
@onready var category_edit: OptionButton = $SettingListContainer/CategorySetting/CategoryType
@onready var file = FileAccess.open("res://wordbank.json", FileAccess.READ)
var category_list :Array = []
var category: String

# Called when the node enters the scene tree for the first time.
func _ready():
	_restore_global_setting()
	_add_category_item()
	confirm_button.pressed.connect(_setting)
	confirm_button.pressed.connect(load_data_lib)
	confirm_button.pressed.connect(change_scene)
	
	
func _process(_delta: float) -> void:
	pass
func _add_category_item():
	var data_all :Dictionary
	if file:
		var content = file.get_as_text()
		data_all = JSON.parse_string(content)
		category_list = data_all.keys()
	for i in range(len(category_list)):
		category_edit.add_item(category_list[i])
		
func load_data_lib():
	# 读取 JSON 文件
	#var file = FileAccess.open("res://wordbank.json", FileAccess.READ)
	var data_all :Dictionary
	if file:
		var content = file.get_as_text()
		data_all = JSON.parse_string(content)
		Global.data = data_all
		if category != '全部':#获取单个键1，键1→键2
			Global.Read_All = false
			Global.keys_layer1_list.append(category)
		else:#建立1层键列表，键1→键2
			Global.Read_All = true
			Global.keys_layer1_list = data_all.keys()#1层键列表
		file.close()
	else:
		print("无法加载词库文件")

func change_scene()->void:
	#print(type_string(typeof(Global.data)))
	#print(type_string(typeof(Global.keys_layer1_list[0])))
	get_tree().change_scene_to_file("res://Main.tscn")

func _setting()->void:
	category = category_edit.text
	Global.category = category
	if $SettingListContainer/WorkModeContainer/OptionButton.text=="顺序":
		Global.mode = "sequence"
	elif $SettingListContainer/WorkModeContainer/OptionButton.text=="随机":
		Global.mode = "random"
func _restore_global_setting():
	Global.keys_layer1_list = []
	Global.keys_layer2_list = []
	Global.Read_All = true
	Global.mode = "random"
	
