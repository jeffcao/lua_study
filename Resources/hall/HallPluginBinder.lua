require 'hall.ShouChongPlugin'
require 'hall.VipPlugin'
HallPluginBinder = {}

function HallPluginBinder.bind(theClass)
	ShouChongPlugin.bind(theClass)
	VipPlugin.bind(theClass)
end