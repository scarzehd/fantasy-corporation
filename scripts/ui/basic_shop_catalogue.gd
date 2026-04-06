extends Letter
class_name BasicShopCatalogue

@onready var item_template:PanelContainer = %ItemTemplate
@onready var item_container:GridContainer = %ItemContainer

var buttons:Array[Button]

func populate(items:Array[ItemData]):
	for item in items:
		var template = item_template.duplicate()
		template.show()
		item_container.add_child(template)
		template.item = item
		template.cost = item.purchase_price
