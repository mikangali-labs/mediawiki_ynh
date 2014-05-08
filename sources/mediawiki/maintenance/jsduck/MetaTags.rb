# See also:
# - https://github.com/senchalabs/jsduck/wiki/Tags
# - https://github.com/senchalabs/jsduck/wiki/Custom-tags
require 'jsduck/meta_tag'

class SourceTag < JsDuck::MetaTag
  def initialize
    # This defines the name of the @tag
    @name = 'source'
  end

  # Generate HTML output for this tag.
  # One can make use of the #format method to easily support
  # Markdown and {@link} tags inside the contents of the tag.
  #
  # @param tags All matches of this tag on one class.
  def to_html(tags)
    '<h3 class="pa">Source</h3>' + tags.map {|tag| format(tag) }.join("\n")
  end
end

class ContextTag < JsDuck::MetaTag
  def initialize
    @name = 'context'
  end

  # @param tags All matches of this tag on one class.
  def to_html(tags)
    return '<h3 class="pa">Context</h3>' +  render_long_context(tags.last)
  end

  def render_long_context(tag)
    if tag =~ /\A([^\s]+)/m
      name = $1
      return format("`this` : {@link #{name}}")
    end
  end
end

class SeeTag < JsDuck::MetaTag
  def initialize
    @name = 'see'
    @multiline = true
  end

  # @param tags All matches of this tag on one class.
  def to_html(tags)
    doc = []
    doc << '<h3 class="pa">Related</h3>'
    doc << [
        '<ul>',
        tags.map {|tag| render_long_see(tag) },
        '</ul>',
      ]
    doc
  end

  def render_long_see(tag)
    if tag =~ /\A([^\s]+)( .*)?\Z/m
      name = $1
      doc = $2 ? ': ' + $2 : ''
      return [
        '<li>',
        format("{@link #{name}} #{doc}"),
        '</li>'
      ]
    end
  end
end
