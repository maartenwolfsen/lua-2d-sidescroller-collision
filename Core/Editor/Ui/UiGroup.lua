UiGroup = {}
UiGroup.__index = UiGroup
UiGroup.__name = "UiGroup"

function UiGroup:new(id, children)
	local uiGroup = {}

	setmetatable(uiGroup, UiGroup)

	uiGroup.id = id
	uiGroup.children = children

	table.insert(
		Ui,
		uiGroup
	)

	return uiGroup
end

function UiGroup:add(object)
	table.insert(
		uiGroup.children,
		object
	)
end
