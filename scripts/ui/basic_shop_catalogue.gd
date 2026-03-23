extends Letter
class_name BasicShopCatalogue

@onready var item_template:PanelContainer = %ItemTemplate
@onready var item_container:GridContainer = %ItemContainer

var buttons:Array[Button]

func populate(items:Array[ItemData], prices:Array[int]):
	assert(items.size() == prices.size())
	for i in range(items.size()):
		var template = item_template.duplicate()
		template.show()
		item_container.add_child(template)
		template.item = items[i]
		template.cost = prices[i]
