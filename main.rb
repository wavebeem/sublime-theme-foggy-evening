#!/usr/bin/env ruby
require "nokogiri"

module Color
  extend self

  BG = "#2b303b"
  FG = "#d2d6e0"
  WHITE = "#fafafa"
  GRAY = "#9e9e9e"
  BLACK = "#424242"
  RED = "#ff5252"
  GREEN = "#4caf50"
  BLUE = "#03a9f4"
  YELLOW = "#8bc34a"
  ORANGE = "#ff6e40"
  PURPLE = "#ba68c8"
  PINK = "#f48fb1"
  CYAN = "#00bfa5"
  NO_ = "#ff00ff"

  THEME_NAME = "Foggy Evening"

  def dilute(color, percent)
    scaled = 255 * (percent / 100.0)
    alpha = format("%02x", scaled)
    "#{color}#{alpha}"
  end

  def plistify(xml, data)
    case [data.class]
    when [Hash]
      plistify_dict(xml, data)
    when [Array]
      plistify_array(xml, data)
    when [Fixnum], [String], [Symbol]
      plistify_string(xml, data)
    else
      fail
    end
  end

  def plistify_array(xml, list)
    xml.array {
      list.each {|x|
        plistify(xml, x)
      }
    }
  end

  def plistify_dict(xml, hash)
    xml.dict {
      hash.each {|k, v|
        xml.key(k)
        plistify(xml, v)
      }
    }
  end

  def plistify_string(xml, str)
    xml.string(str.to_s)
  end

  def config
    {
      author: "Brian Mock <brian@mockbrian.com>",
      name: "#{THEME_NAME}",
      colorSpaceName: "sRGB",
      comment: "https://github.com/wavebeem/sublime-theme-foggy-evening",
      uuid: "2346efb8-641f-43dc-a817-f5d61edc3dc7",
      settings: [{ settings: settings }, *scopes],
    }
  end

  def settings
    {
      background: BG,
      divider: WHITE,
      foreground: FG,
      invisibles: RED,
      caret: WHITE,
      lineHighlight: dilute(WHITE, 10),
      selection: dilute(WHITE, 80),
      selectionForeground: BLACK,
      shadow: dilute(BLACK, 75),
      shadowWidth: 8,
      # gutter: dilute(BLACK, 0),
      gutterForeground: dilute(WHITE, 30),
      guide: dilute(WHITE, 12),
      activeGuide: dilute(WHITE, 25),
    }
  end

  def scopes
    scopes = [
      # ["Call", [
      #   "meta.function-call",
      #   "support.function.less"
      # ]],
      ["Parameter", "variable.parameter.function"],
      ["Comments", [
        "comment",
        "punctuation.definition.comment"
      ]],
      ["Punctuation", [
        "punctuation.definition.string",
        "punctuation.definition.variable",
        "punctuation.definition.string",
        "punctuation.definition.parameters",
        "punctuation.definition.string",
        "punctuation.definition.array",
        "punctuation.terminator"
      ]],
      ["Delimiters", [
        "punctuation.separator",
        "punctuation.section",
        "meta.brace",
        "meta.delimiter"
      ]],
      ["Operators", "keyword.operator"],
      ["Keywords", "keyword"],
      ["Variables", [
        "variable.declaration",
        "variable.parameter",
        "variable.other"
      ]],
      ["Search", "entity.name.filename.find-in-files"],
      ["Search Line", "constant.numeric.line-number.match.find-in-files"],
      ["Functions", [
        "entity.name.function",
        "meta.require",
        "support.function.any-method"
      ]],
      ["Classes", [
        "support.class",
        "entity.name.class",
        "entity.name.type.class",
        "entity.name.type.module",
        "meta.class"
      ]],
      ["Methods", "keyword.other.special-method"],
      ["Storage", "storage"],
      ["Support", "support"],
      ["Strings", [
        "string",
        "entity.other.inherited-class",
        "punctuation.definition.string",
        "support.constant.property-value"
      ]],
      ["Integers", "constant.numeric"],
      ["Symbols", "constant.other.symbol"],
      ["Floats", "none"],
      ["Boolean", "constant.language.boolean"],
      ["Constants", [
        "constant",
        "support.constant",
        "variable.language"
      ]],
      ["Tags", [
        "entity.name.tag",
        "punctuation.definition.tag"
      ]],
      ["Attributes", "entity.other.attribute-name"],
      ["Attribute IDs", [
        "entity.other.attribute-name.id",
        "punctuation.definition.entity"
      ]],
      ["Selector", [
        "meta.selector",
        "meta.object-literal.key"
      ]],
      ["Headings", [
        "markup.heading punctuation.definition.heading",
        "entity.name.section"
      ]],
      ["Units", "keyword.other.unit"],
      ["Bold", [
        "markup.bold",
        "punctuation.definition.bold"
      ]],
      ["Italic", [
        "markup.italic",
        "punctuation.definition.italic"
      ]],
      ["Code", "markup.raw.inline"],
      ["Link Text", "string.other.link"],
      ["Link Url", "meta.link"],
      ["Lists", "markup.list"],
      ["Quotes", "markup.quote"],
      ["Separator", "meta.separator"],
      ["Inserted", "markup.inserted"],
      ["Deleted", "markup.deleted"],
      ["Changed", "markup.changed"],
      ["Colors", "constant.other.color"],
      ["Regular Expressions", "string.regexp"],
      ["Escape Characters", [
        "constant.character.escape",
      ]],
      ["Embedded", [
        "punctuation.section.embedded",
        "variable.interpolation"
      ]],
      ["SublimeLinter Warning", "sublimelinter.mark.warning"],
      ["SublimeLinter Gutter", "sublimelinter.gutter-mark"],
      ["SublimeLinter Error", "sublimelinter.mark.error"],
      ["Illegal", [
        "invalid",
        "invalid.illegal"
      ]],
      ["Broken", "invalid.broken"],
      ["Deprecated", "invalid.deprecated"],
      ["Unimplemented", "invalid.unimplemented"],
    ]
    scopes.map {|name, scope|
      scope = scope.join(", ") if scope.is_a?(Array)
      settings = named_scope_to_settings(name)
      if settings
        {
          name: name,
          scope: scope,
          settings: named_scope_to_settings(name)
        }
      else
        nil
      end
    }.compact
  end

  def style(color, *font_style)
    {
      foreground: color,
      background: dilute(color, 8),
      fontStyle: font_style.join(" "),
    }
  end

 @_settings = {
    "Call" => style(PURPLE),
    "Parameter" => style(WHITE, "bold"),
    "Comments" => style(GREEN),
    "Punctuation" => style(GRAY),
    "Delimiters" => style(GRAY),
    "Operators" => style(GRAY),
    "Search" => style(PURPLE, "bold"),
    "Search Line" => style(BLUE, "bold"),
    "Keywords" => style(BLUE, "bold"),
    "Variables" => style(CYAN),
    "Functions" => style(YELLOW, "bold"),
    "Classes" => style(PURPLE, "bold"),
    "Methods" => style(PURPLE, "bold"),
    "Storage" => style(BLUE, "bold"),
    "Strings" => style(RED),
    "Symbols" => style(ORANGE),
    "Integers" => style(ORANGE),
    "Floats" => style(ORANGE),
    "Boolean" => style(ORANGE),
    "Constants" => style(ORANGE),
    "Support" => style(PINK),
    "Tags" => style(BLUE),
    "Attributes" => style(CYAN),
    "Attribute IDs" => style(CYAN),
    "Selector" => style(PURPLE),
    "Headings" => style(BLUE, "bold"),
    "Units" => style(ORANGE),
    "Bold" => style(PURPLE, "bold"),
    "Italic" => style(PURPLE, "italic"),
    "Code" => style(RED),
    "Link Text" => style(WHITE, "bold"),
    "Link Url" => style(BLUE),
    "Lists" => style(ORANGE),
    "Quotes" => style(RED),
    "Separator" => style(GRAY),
    "Inserted" => style(GREEN),
    "Deleted" => style(RED),
    "Changed" => style(YELLOW),
    "Colors" => style(ORANGE),
    "Regular Expressions" => style(ORANGE),
    "Escape Characters" => style(CYAN),
    "Embedded" => style(CYAN),
    "Broken" => style(RED, "bold"),
    "Deprecated" => style(RED, "bold"),
    "Unimplemented" => style(RED, "bold"),
    "SublimeLinter Warning" => {
      foreground: YELLOW,
      background: BLACK,
    },
    "SublimeLinter Gutter" => {
      foreground: YELLOW,
      background: BLACK,
    },
    "SublimeLinter Error" => {
      foreground: RED,
      background: BLACK,
    },
    "Illegal" => {
      foreground: WHITE,
      background: dilute(RED, 80),
      fontStyle: "bold",
    },
  }

  def named_scope_to_settings(name)
    @_settings[name]
  end
end

doc = Nokogiri::XML::Builder.new(encoding: "UTF-8") do |xml|
  xml.doc.create_internal_subset(
    "plist",
    "-//Apple//DTD PLIST 1.0//EN",
    "http://www.apple.com/DTDs/PropertyList-1.0.dtd"
  )
  xml.plist { Color.plistify(xml, Color.config) }
end
xml = doc.to_xml

puts "Saving theme!"
path =
  File.join(
    Dir.home,
    "Library",
    "Application Support",
    "Sublime Text 3",
    "Packages",
    "User",
    "#{Color::THEME_NAME}.tmTheme"
  )
File.write(path, xml)
File.write("#{Color::THEME_NAME}.tmTheme", xml)
