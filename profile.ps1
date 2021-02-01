# Sometimes powershell spazzes and fucks the prompt colors.
# This unfucks it. And this is easier for me to remember.
function rcolors {
	[Console]::ResetColor()
}

# Again I find this hard to remember.
# My dumbass will remember this better.
function remove-alias {
	param(
		$alias
	)

	remove-item alias:\$alias
}

#$env:path += ";C:\tools\cmder;C:\tools\neovim\Neovim\bin;$home\AppData\Roaming\npm"

function nvim {
	param(
		$file
	)
	C:\tools\neovim\Neovim\bin\nvim.exe $file
}

function subl {
	& "${Env:ProgramFiles}\Sublime Text 3\sublime_text.exe" $args
}

$env:VIRTUAL_ENV_DISABLE_PROMPT=1
