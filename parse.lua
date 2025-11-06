local handle = io.popen("cat /nauos/config.nau")
local code = handle:read("*a")
handle:close()

local variables = {}
local var_value_now = ""

local packages = ""

function trim(text)
    string.sub(text, 2, -2)
	string.sub(text, 2)
end

function execute(token_table)
	local two = token_table[2]
	local parsed_two = parse_var(two)
	if token_table[1] == "print" then
		if parsed_two ~= nil then
			print(parsed_two)
		else 
			print(two)
		end
	elseif token_table[1] == "pkgs" then
		if parsed_two ~= nil then
			print("Putting {" .. parsed_two .. "} in pkgs list...")
			packages = packages .. parsed_two .. " "
		else
			print("Putting {" .. two .. "} in pkgs list...")
			packages = packages .. two .. " "
		end
		trim(packages)
	elseif token_table[1] == "bash" then
		if parsed_two ~= nil then
			os.execute(parsed_two)
		else 
			os.execute(two)
		end
	elseif token_table[1] == "var" then -- var{name:string}; print{$name};
		var_value_now = token_table[3]
		table.insert(variables, two)
		table.insert(variables, var_value_now)
	elseif token_table[1] == "listpkgs" then
		os.execute("apt-mark showmanual")
	elseif token_table[1] == "timezone" then
		os.execute("timedatectl set_timezone " .. two)
	end
end

function parse_var(text) 
	local token = ""
	for i=2, #text do
		local char = text:sub(i, i)
		if text:sub(1, 1) == "$" then
			if char ~= " " then
				token = token .. char
			else
				break
			end
		end
	end
	for i=1, #variables do
		if variables[i] == token then
			return variables[i+1]
		end
	end
	return nil
end

function parse(text)
	local token = {"", "", ""}
	local token_position = 1
	for i=1, #text do
		local char = text:sub(i, i)
		if char == "{" or char == "}" or char == ":" then
			token_position = token_position + 1
		elseif char == "," then
			token[token_position] = token[token_position] .. " "
		elseif char == "@" then
			execute(token)
			token_position = 1
			token = {"", "", ""}
		elseif char ~= "{" and char ~= "}" and char ~= "@" then
			token[token_position] = token[token_position] .. char
		end
	end
	os.execute("sudo apt install" .. " " .. packages .. "")
end

parse("@" .. code:gsub(";", "@@"):gsub("\n", ""):gsub("\t", ""))
