local nl = require("nattlua")
print("wqhat")
local cmd = ...
local analyzer_config = {
	working_directory = "",
	inline_require = true,
}

if cmd == "get-analyzer-config" then
	analyzer_config.entry_point = "main.nlua"
	return analyzer_config
elseif cmd == "check" then
	local compiler = assert(nl.Compiler([[return import("./main.nlua")]], "main.nlua", analyzer_config))

	if cmd == "check-language-server" then return compiler end

	assert(compiler:Analyze())
elseif cmd == "build" then
	local compiler = assert(nl.Compiler([[
			return import("./main.nlua")
		]], "main.nlua", analyzer_config))
	local code = compiler:Emit({
		blank_invalid_code = true,
		module_encapsulation_method = "loadstring",
	})
	local func = assert(loadstring(code, "main.nlua"))

	if func then func() --compiler:Analyze() -- analyze after
	end
elseif cmd == "run" then
	print(path, "?!?!")
	local path = select(2, ...)
	local compiler = assert(nl.Compiler([[
			return import("./]] .. path .. [[")
		]], path, analyzer_config))
	local code = compiler:Emit({
		blank_invalid_code = true,
		module_encapsulation_method = "loadstring",
	})
	local func = assert(loadstring(code, path))
	print(func, "?!")

	if func then
		print(compiler:Analyze())
		func()
	end
end