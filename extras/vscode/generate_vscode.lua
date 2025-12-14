#!/usr/bin/env lua
-- extras/vscode/generate_vscode.lua
-- Generates VSCode Editor themes from Oasis color palettes

-- Load shared utilities
package.path = package.path .. ";./lua/?.lua;./lua/?/init.lua"
local Utils = require("oasis.utils")
local File = require("oasis.lib.file")
local ColorUtils = require("oasis.tools.color_utils")

local function generate_vscode_theme(name, palette)
	local display_name = Utils.format_display_name(name)
	local is_light = palette.light_mode or false

	-- Calculate adjusted colors for UI states
	local hover_bg = is_light and ColorUtils.adjust_brightness(palette.bg.mantle, 0.95)
		or ColorUtils.adjust_brightness(palette.bg.surface, 1.1)

	local theme = {
		name = display_name,
		type = is_light and "light" or "dark",
		colors = {
			["focusBorder"] = palette.syntax.comment,
			["foreground"] = palette.fg.core,
			["selection.background"] = palette.bg.surface,
			-- ACTIVITY BAR
			["activityBar.background"] = palette.bg.core,
			["activityBar.foreground"] = palette.fg.core,
			["activityBar.border"] = ColorUtils.with_alpha(palette.bg.surface, '14'),
			["activityBar.inactiveForeground"] = palette.fg.dim,
			["activityBarBadge.background"] = is_light and ColorUtils.adjust_brightness(palette.theme.primary, 2) or
			ColorUtils.adjust_brightness(palette.theme.primary, 0.8),
			["activityBarBadge.foreground"] = palette.fg.core,
			-- Badge
			["badge.background"] = is_light and ColorUtils.adjust_brightness(palette.theme.primary, 2) or
			ColorUtils.adjust_brightness(palette.theme.primary, 0.8),
			["badge.foreground"] = palette.fg.core,
			-- Breadcrumb
			["breadcrumb.activeSelectionForeground"] = palette.theme.primary,
			["breadcrumb.background"] = ColorUtils.with_alpha(palette.bg.core, '4A'),
			["breadcrumb.focusForeground"] = palette.theme.primary,
			["breadcrumb.foreground"] = ColorUtils.with_alpha(palette.fg.core, "40"),
			["breadcrumbPicker.background"] = palette.bg.shadow,
			-- Button
			["button.background"] = is_light and ColorUtils.adjust_brightness(palette.theme.primary, 2) or
			ColorUtils.adjust_brightness(palette.theme.primary, 0.8),
			["button.foreground"] = palette.fg.core,
			["button.hoverBackground"] = hover_bg,
			["button.secondaryBackground"] = palette.bg.mantle,
			["button.secondaryForeground"] = palette.fg.core,
			["button.secondaryHoverBackground"] = hover_bg,
			-- Checkbox
			["checkbox.background"] = palette.bg.surface,
			["checkbox.border"] = palette.bg.surface,
			["checkbox.foreground"] = palette.fg.core,
			-- DROPDOWN / QUICK PICKER
			["dropdown.background"] = palette.bg.surface,
			["dropdown.listBackground"] = palette.bg.mantle,
			["dropdown.border"] = palette.bg.shadow,
			["dropdown.foreground"] = palette.fg.core,
			-- INPUT
			["input.background"] = palette.bg.surface,
			["input.border"] = palette.bg.shadow,
			["input.foreground"] = palette.fg.core,
			["input.placeholderForeground"] = palette.fg.dim,
			-- Editor
			["editor.background"] = palette.bg.core,
			["editor.foreground"] = palette.fg.core,
			["editor.selectionBackground"] = ColorUtils.with_alpha(palette.theme.primary, "40"),
			["editor.inactiveSelectionBackground"] = "",
			["editor.selectionHighlightBackground"] = ColorUtils.with_alpha(palette.theme.accent, "30"),
			["editor.findMatchBackground"] = ColorUtils.with_alpha(palette.ui.search.bg, "AA"),
			["editor.findMatchHighlightBackground"] = ColorUtils.with_alpha(palette.ui.search.bg, "55"),
			["editor.hoverHighlightBackground"] = ColorUtils.with_alpha(palette.theme.primary, "22"),
			["editor.wordHighlightBackground"] = ColorUtils.with_alpha(palette.theme.primary, "15"),
			["editor.wordHighlightStrongBackground"] = ColorUtils.with_alpha(palette.theme.secondary, "20"),
			["editor.lineHighlightBackground"] = ColorUtils.with_alpha(palette.ui.cursorLine, "99"),
			["editor.lineHighlightBorder"] = ColorUtils.with_alpha(palette.ui.cursorLine, "33"),
			["editorLineNumber.foreground"] = palette.fg.muted,
			["editorLineNumber.activeForeground"] = palette.ui.lineNumber,
			["editorGroupHeader.tabsBackground"] = palette.bg.mantle,
			["editorCursor.foreground"] = palette.theme.primary,
			["editorCursor.background"] = palette.bg.core,
			["editorWhitespace.foreground"] = ColorUtils.with_alpha(palette.fg.dim, "33"),
			["editorIndentGuide.background"] = ColorUtils.with_alpha(palette.fg.dim, "1A"),
			["editorIndentGuide.activeBackground"] = ColorUtils.with_alpha(palette.fg.dim, "33"),
			["editorRuler.foreground"] = ColorUtils.with_alpha(palette.fg.dim, "45"),
			["editorBracketMatch.background"] = ColorUtils.with_alpha(palette.syntax.bracket, "60"),
			["editorBracketMatch.border"] = ColorUtils.with_alpha(palette.syntax.bracket, "FF"),
			-- GIT
			["gitDecoration.addedResourceForeground"] = palette.terminal.green,
			["gitDecoration.conflictingResourceForeground"] = palette.terminal.magenta,
			["gitDecoration.deletedResourceForeground"] = palette.terminal.red,
			["gitDecoration.ignoredResourceForeground"] = palette.bg.core,
			["gitDecoration.modifiedResourceForeground"] = palette.terminal.yellow,
			["gitDecoration.stageDeletedResourceForeground"] = palette.terminal.red,
			["gitDecoration.stageModifiedResourceForeground"] = palette.terminal.yellow,
			["gitDecoration.submoduleResourceForeground"] = palette.terminal.blue,
			["gitDecoration.untrackedResourceForeground"] = palette.terminal.green,
			-- GUTTER
			["editorGutter.background"] = palette.bg.core,
			["editorGutter.addedBackground"] = palette.terminal.green,
			["editorGutter.modifiedBackground"] = palette.terminal.yellow,
			["editorGutter.deletedBackground"] = palette.terminal.red,
			-- LIST
			["list.activeSelectionBackground"] = ColorUtils.with_alpha(palette.theme.primary, "22"),
			["list.activeSelectionForeground"] = palette.fg.core,
			["list.inactiveSelectionBackground"] = ColorUtils.with_alpha(palette.theme.primary, "11"),
			["list.hoverBackground"] = ColorUtils.with_alpha(palette.theme.primary, "11"),
			["list.focusBackground"] = ColorUtils.with_alpha(palette.theme.primary, "22"),
			-- MENU
			["menu.background"] = palette.bg.surface,
			["menu.foreground"] = palette.fg.core,
			["menu.selectionBackground"] = ColorUtils.with_alpha(palette.theme.primary, "33"),
			["menu.separatorBackground"] = palette.bg.shadow,
			-- MERGE CONFLICTS
			["merge.currentHeaderBackground"] = ColorUtils.with_alpha(palette.terminal.green, "33"),
			["merge.currentContentBackground"] = ColorUtils.with_alpha(palette.terminal.green, "11"),
			["merge.incomingHeaderBackground"] = ColorUtils.with_alpha(palette.terminal.blue, "33"),
			["merge.incomingContentBackground"] = ColorUtils.with_alpha(palette.terminal.blue, "11"),
			-- MINIMAP
			["minimap.background"] = ColorUtils.with_alpha(palette.bg.core, "99"),
			["minimap.selectionHighlight"] = ColorUtils.with_alpha(palette.theme.primary, "66"),
			["minimap.errorHighlight"] = palette.ui.diag.error.fg,
			["minimap.warningHighlight"] = palette.ui.diag.warn.fg,
			-- MINIMAP GUTTER
			["minimapGutter.addedBackground"] = palette.terminal.green,
			["minimapGutter.modifiedBackground"] = palette.terminal.yellow,
			["minimapGutter.deletedBackground"] = palette.terminal.red,
			-- NOTIFICATIONS
			["notifications.background"] = palette.bg.surface,
			["notifications.foreground"] = palette.fg.core,
			["notifications.border"] = palette.bg.shadow,
			["notificationsErrorIcon.foreground"] = palette.ui.diag.error.fg,
			["notificationsWarningIcon.foreground"] = palette.ui.diag.warn.fg,
			["notificationsInfoIcon.foreground"] = palette.ui.diag.info.fg,
			-- OUTLINE VIEW
			["outline.foreground"] = palette.fg.core,
			["outline.iconForeground"] = palette.theme.primary,
			-- PANELS
			["panel.background"] = palette.bg.mantle,
			["panel.border"] = palette.bg.shadow,
			["panelTitle.activeForeground"] = palette.fg.core,
			["panelTitle.inactiveForeground"] = palette.fg.dim,
			["panelTitle.activeBorder"] = palette.theme.primary,
			-- PANEL SECTION
			["panelSection.background"] = palette.bg.mantle,
			["panelSection.border"] = palette.bg.shadow,
			["panelSectionHeader.background"] = palette.bg.surface,
			["panelSectionHeader.foreground"] = palette.fg.core,
			["panelSectionHeader.border"] = palette.bg.shadow,
			-- QUICK INPUT
			["quickInput.background"] = palette.bg.surface,
			["quickInput.foreground"] = palette.fg.core,
			-- QUICK PANEL
			["quickPicker.background"] = palette.bg.surface,
			["quickPicker.foreground"] = palette.fg.core,
			["quickPickerList.background"] = palette.bg.mantle,
			["quickPickerList.focusBackground"] = ColorUtils.with_alpha(palette.theme.primary, "22"),
			["quickPickerList.focusForeground"] = palette.fg.core,
			["quickPickerList.focusIconForeground"] = palette.theme.primary,
			-- PROGRESS BAR
			["progressBar.background"] = palette.theme.primary,
			-- SCROLLBARS
			["scrollbarSlider.background"] = ColorUtils.with_alpha(palette.fg.dim, "44"),
			["scrollbarSlider.hoverBackground"] = ColorUtils.with_alpha(palette.fg.dim, "66"),
			["scrollbarSlider.activeBackground"] = ColorUtils.with_alpha(palette.fg.dim, "88"),
			-- SIDE BAR
			["sideBar.background"] = palette.bg.mantle,
			["sideBar.foreground"] = palette.fg.core,
			["sideBar.border"] = palette.bg.shadow,
			-- STATUS BAR
			["statusBar.background"] = palette.bg.surface,
			["statusBar.foreground"] = palette.fg.core,
			["statusBar.noFolderBackground"] = palette.bg.mantle,
			["statusBar.debuggingBackground"] = palette.theme.accent,
			-- TABS / TAB BAR
			["tab.activeBackground"] = palette.bg.core,
			["tab.activeForeground"] = palette.fg.core,
			["tab.inactiveBackground"] = palette.bg.mantle,
			["tab.inactiveForeground"] = palette.fg.core,
			["tab.hoverBackground"] = hover_bg,
			["tab.hoverForeground"] = palette.fg.core,
			["tab.border"] = palette.bg.shadow,
			["tab.activeBorderTop"] = palette.theme.primary,
			-- Terminal
			["terminal.background"] = palette.bg.core,
			["terminal.foreground"] = palette.fg.core,
			["terminalCursor.background"] = palette.bg.core,
			["terminalCursor.foreground"] = palette.theme.primary,
			["terminal.selectionBackground"] = ColorUtils.with_alpha(palette.theme.primary, "33"),
			["terminal.ansiBlack"] = palette.terminal.black,
			["terminal.ansiRed"] = palette.terminal.red,
			["terminal.ansiGreen"] = palette.terminal.green,
			["terminal.ansiYellow"] = palette.terminal.yellow,
			["terminal.ansiBlue"] = palette.terminal.blue,
			["terminal.ansiMagenta"] = palette.terminal.magenta,
			["terminal.ansiCyan"] = palette.terminal.cyan,
			["terminal.ansiWhite"] = palette.terminal.white,
			["terminal.ansiBrightBlack"] = palette.terminal.bright_black,
			["terminal.ansiBrightRed"] = palette.terminal.bright_red,
			["terminal.ansiBrightGreen"] = palette.terminal.bright_green,
			["terminal.ansiBrightYellow"] = palette.terminal.bright_yellow,
			["terminal.ansiBrightBlue"] = palette.terminal.bright_blue,
			["terminal.ansiBrightMagenta"] = palette.terminal.bright_magenta,
			["terminal.ansiBrightCyan"] = palette.terminal.bright_cyan,
			["terminal.ansiBrightWhite"] = palette.terminal.bright_white,
			-- TIMELINE VIEW
			["timeline.background"] = palette.bg.mantle,
			["timeline.foreground"] = palette.fg.core,
			-- TITLE BAR
			["titleBar.activeBackground"] = palette.bg.mantle,
			["titleBar.activeForeground"] = palette.fg.core,
			["titleBar.inactiveBackground"] = palette.bg.shadow,
			["titleBar.inactiveForeground"] = palette.fg.dim,
			-- VIEW SPECIFIC COLORS
			["sideBar.dropBackground"] = ColorUtils.with_alpha(palette.theme.primary, "33"),
			["list.highlightForeground"] = palette.theme.primary,
			-- WELCOME PAGE
			["welcomePage.buttonBackground"] = palette.bg.mantle,
			["welcomePage.buttonHoverBackground"] = ColorUtils.with_alpha(palette.theme.primary, "22"),
		},
		semanticHighlighting = true,
		semanticTokenColors = {
			["variable"] = { foreground = palette.fg.core },
			["variable.readonly"] = { foreground = palette.syntax.constant },
			["variable.readonly.local"] = { foreground = palette.fg.core },
			["variable.defaultLibrary"] = { foreground = palette.syntax.builtinVar },
			["property"] = { foreground = palette.syntax.identifier },
			["property.declaration"] = { foreground = palette.fg.core },
			["parameter"] = { foreground = palette.fg.core },
			["enumMember"] = { foreground = palette.syntax.constant },
			["function"] = { foreground = palette.syntax.func },
			["method"] = { foreground = palette.syntax.func },
			["class"] = { foreground = palette.syntax.type },
			["type"] = { foreground = palette.syntax.type },
			["type.declaration"] = { foreground = palette.syntax.type },
			["struct"] = { foreground = palette.syntax.type },
			["keyword"] = { foreground = palette.syntax.statement },
			["operator"] = { foreground = palette.syntax.operator },
			["string"] = { foreground = palette.syntax.string },
			["string.regexp"] = { foreground = palette.syntax.regex },
			["string.escape"] = { foreground = palette.syntax.regex, fontStyle = "bold" },
			["comment"] = { foreground = palette.syntax.comment, fontStyle = "italic" },
			["documentation"] = { foreground = palette.syntax.comment, fontStyle = "italic" },
			["boolean"] = { foreground = palette.syntax.constant, fontStyle = "bold" },
			["number"] = { foreground = palette.syntax.constant },
			["macro"] = { foreground = palette.syntax.preproc },
			["label"] = { foreground = palette.syntax.statement },
			["namespace"] = { foreground = palette.syntax.type },
			["decorator"] = { foreground = palette.syntax.special },
			["inlayHint"] = { foreground = palette.fg.dim, fontStyle = "italic" },
			["function.declaration"] = { foreground = palette.syntax.func, fontStyle = "bold" },
			["method.declaration"] = { foreground = palette.syntax.func, fontStyle = "bold" },
			["interface"] = { foreground = palette.syntax.type, fontStyle = "italic" },
			["enum"] = { foreground = palette.syntax.type },
			["typeParameter"] = { foreground = palette.syntax.type, fontStyle = "italic" },
			["selfKeyword"] = { foreground = palette.syntax.statement, fontStyle = "italic" },
		},
		tokenColors = {
			-- COMMENTS
			{
				scope = {
					"comment",
					"punctuation.definition.comment",
					"string.comment"
				},
				settings = {
					foreground = palette.syntax.comment,
					fontStyle = "italic"
				}
			},
			-- KEYWORDS
			{
				scope = {
					"keyword",
					"keyword.control",
					"keyword.operator",
					"storage.type",
					"storage.modifier",
				},
				settings = {
					foreground = palette.syntax.statement
				}
			},
			-- STRINGS
			{
				scope = { "string" },
				settings = {
					foreground = palette.syntax.string
				}
			},
			{
				scope = { "string.regexp" },
				settings = {
					foreground = palette.syntax.regex
				}
			},
			{
				scope = { "constant.character.escape" },
				settings = {
					foreground = palette.syntax.regex,
					fontStyle = "bold"
				}
			},
			-- FUNCTIONS
			{
				scope = {
					"entity.name.function",
					"meta.function-call",
					"support.function"
				},
				settings = {
					foreground = palette.syntax.func
				}
			},
			-- TYPES
			{
				scope = {
					"entity.name.type",
					"support.class",
					"support.type",
				},
				settings = {
					foreground = palette.syntax.type
				}
			},
			-- CONSTANTS (numbers, bool, enums)
			{
				scope = {
					"constant.numeric",
					"constant.language.boolean"
				},
				settings = {
					foreground = palette.syntax.constant,
					fontStyle = "bold"
				}
			},
			-- VARIABLES
			{
				scope = {
					"variable",
					"identifier"
				},
				settings = {
					foreground = palette.fg.core
				}
			},
			{
				scope = "variable.language",
				settings = {
					foreground = palette.syntax.builtinVar
				}
			},
			-- TAGS (HTML/XML)
			{
				scope = {
					"entity.name.tag",
				},
				settings = {
					foreground = palette.syntax.type
				}
			},
			-- ATTRIBUTES
			{
				scope = {
					"entity.other.attribute-name"
				},
				settings = {
					foreground = palette.syntax.special
				}
			},
			-- MARKUP
			{
				scope = { "markup.heading" },
				settings = {
					foreground = palette.syntax.func,
					fontStyle = "bold"
				}
			},
			{
				scope = { "markup.italic" },
				settings = {
					foreground = palette.theme.primary,
					fontStyle = "italic"
				}
			},
			{
				scope = { "markup.bold" },
				settings = {
					foreground = palette.syntax.conditional,
					fontStyle = "bold"
				}
			},
			{
				name = "Parentheses, Brackets, Braces",
				scope = "punctuation",
				settings = {
					foreground = palette.syntax.punctuation,
				}
			},
			{
				name = "Parentheses, Brackets, Braces",
				scope = {
					"punctuation.accessor",
					"punctuation.definition.generic",
					"meta.function.closure punctuation.section.parameters",
					"punctuation.definition.tag",
					"punctuation.separator.key-value" },
				settings = {
					foreground = palette.fg.dim,
				}
			},
			{
				scope = {
					"support.type.property-name",
					"meta.object-literal.key"
				},
				settings = {
					foreground = palette.syntax.identifier
				}
			},
			{
				scope = {
					"punctuation.definition.template-expression",
					"punctuation.section.embedded"
				},
				settings = {
					foreground = palette.syntax.statement
				}
			},
			{
				scope = {
					"text.html constant.character.entity",
					"text.html constant.character.entity punctuation",
					"constant.character.entity.xml",
					"constant.character.entity.xml punctuation",
					"constant.character.entity.js.jsx",
					"constant.charactger.entity.js.jsx punctuation",
					"constant.character.entity.tsx",
					"constant.character.entity.tsx punctuation"
				},
				settings = {
					foreground = palette.fg.dim
				}
			},
			{
				scope = "support.constant",
				settings = {
					foreground = palette.syntax.constant
				}
			},
			{
				scope = {
					"support.class.component.jsx",
					"entity.name.tag.component.jsx"
				},
				settings = {
					foreground = palette.syntax.type
				}
			}
		}
	}

	return theme
end

local function main()
	print("\n=== Oasis VSCode Theme Generator ===\n")

	local palette_names = Utils.get_palette_names()

	if #palette_names == 0 then
		print("Error: No palette files found in lua/oasis/color_palettes/")
		return
	end

	print(string.format("Found %d palette(s)\n", #palette_names))

	local success_count, error_count = Utils.for_each_palette_variant(function(name, palette, mode, intensity)
		-- Build output path using shared utility
		local output_path, variant_name = Utils.build_variant_path("extras/vscode", "json", name, mode, intensity)

		-- Generate and write theme
		local theme = generate_vscode_theme(variant_name, palette)
		local json = ColorUtils.encode_json(theme, 0)
		File.write(output_path, json)
		print(string.format("✓ Generated: %s", output_path))
	end)

	print(string.format("\n=== Summary ==="))
	print(string.format("Success: %d", success_count))
	print(string.format("Errors: %d\n", error_count))
end

-- Run the generator
main()
