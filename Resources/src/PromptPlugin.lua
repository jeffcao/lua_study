PromptPlugin = {}

function PromptPlugin.showPrompt(data)
	data.is_prompt = true
	PurchasePlugin.show_buy_notify(data)
end