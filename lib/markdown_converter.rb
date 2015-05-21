require 'redcarpet'
require 'singleton'

class MarkdownConverter
  include Singleton

  def initialize
    @converter = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new, {
        autolink: true,
        fenced_code_blocks: true,
        strikethrough: true,
        tables: true,
        space_after_headers: true,
        disable_indented_code_blocks: true,
        no_intra_emphasis: true
      })
  end

  def self.convert(text)
    self.instance.convert(text)
  end

  def convert(text)
    @converter.render(text)
  end
end