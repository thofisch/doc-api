require 'asciidoctor'
require 'asciidoctor/extensions'
require 'open-uri'

class FrontMatterPreprocessor < Asciidoctor::Extensions::Preprocessor
  def process document, reader

    print "1"

    lines = reader.lines # get raw lines
    return reader if lines.empty?
    
    front_matter = []
    
    if lines.first.chomp == '---'
      original_lines = lines.dup
      lines.shift
      while !lines.empty? && lines.first.chomp != '---'
        front_matter << lines.shift
      end

      if (first = lines.first).nil? || first.chomp != '---'
        lines = original_lines
      else
        lines.shift
        document.attributes['front-matter'] = front_matter.join.chomp
        # advance the reader by the number of lines taken
        (front_matter.length + 2).times { reader.advance }
      end
    end
    reader
  end
end

class ShellSessionTreeprocessor < Asciidoctor::Extensions::Treeprocessor
  def process document
    return unless document.blocks?
    process_blocks document
    nil
  end

  def process_blocks node
    if node.context == :literal

        node.blocks.each_with_index do |block, i|
        if (((first_line = block.lines.first).start_with? '$ ') ||
                (first_line.start_with? '> '))
            node.blocks[i] = convert_to_terminal_listing block
        else
            process_blocks block if block.blocks?
        end
        end
    end
  end

  def convert_to_terminal_listing block
    attrs = block.attributes
    attrs['role'] = 'terminal'
    prompt_attr = (attrs.has_key? 'prompt') ?
        %( data-prompt="#{block.sub_specialchars attrs['prompt']}") : nil
    lines = block.lines.map do |line|
      line = block.sub_specialchars line.chomp
      if line.start_with? '$ '
        %(<span class="command"#{prompt_attr}>#{line[2..-1]}</span>)
      elsif line.start_with? '&gt; '
        %(<span class="output">#{line[5..-1]}</span>)
      else
        line
      end
    end
    create_listing_block block.document, lines * EOL, attrs, subs: nil
  end
end

class CopyrightFooterPostprocessor < Asciidoctor::Extensions::Postprocessor
  def process document, output
    content = (document.attr 'copyright') || 'Copyright Acme, Inc.'
    if document.basebackend? 'html'
      replacement = %(<div id="footer-text">\\1<br>\n#{content}\n</div>)
      output = output.sub(/<div id="footer-text">(.*?)<\/div>/m, replacement)
    elsif document.basebackend? 'docbook'
      replacement = %(<simpara>#{content}</simpara>\n\\1)
      output = output.sub(/(<\/(?:article|book)>)/, replacement)
    end
    output
  end
end

class ShoutBlock < Asciidoctor::Extensions::BlockProcessor
  PeriodRx = /\.(?= |$)/

  use_dsl

  named :shout
  on_context :paragraph
  name_positional_attributes 'vol'
  parse_content_as :simple

  def process parent, reader, attrs
    volume = ((attrs.delete 'vol') || 1).to_i
    create_paragraph parent, (reader.lines.map {|l| l.upcase.gsub PeriodRx, '!' * volume }), attrs
  end
end

class GistBlockMacro < Asciidoctor::Extensions::BlockMacroProcessor
  use_dsl

  named :gist

  def process parent, target, attrs
    title_html = (attrs.has_key? 'title') ? %(<div class="title">#{attrs['title']}</div>\n) : nil

    html = %(<div class="openblock gist">
#{title_html}<a class="content" href="https://gist.github.com/#{target}.js"></a>
</div>)

    print html

    create_pass_block parent, html, attrs, subs: nil
  end
end

class ManInlineMacro < Asciidoctor::Extensions::InlineMacroProcessor
  use_dsl

  named :man
  name_positional_attributes 'volnum'

  def process parent, target, attrs
    text = manname = target
    suffix = ''
    target = %(#{manname}.html)
    suffix = if (volnum = attrs['volnum'])
      "(#{volnum})"
    else
      nil
    end
    parent.document.register :links, target
    %(#{(create_anchor parent, text, type: :link, target: target).convert}#{suffix})
  end
end

class UriIncludeProcessor < Asciidoctor::Extensions::IncludeProcessor
  def handles? target
    (target.start_with? 'http://') or (target.start_with? 'https://')
  end

  def process doc, reader, target, attributes
    content = (open target).readlines
    reader.push_include content, target, target, 1, attributes
    reader
  end
end

Asciidoctor::Extensions.register do
  preprocessor FrontMatterPreprocessor
  postprocessor CopyrightFooterPostprocessor
  treeprocessor ShellSessionTreeprocessor
  block ShoutBlock
  block_macro GistBlockMacro if document.basebackend? 'html'
  inline_macro ManInlineMacro
  include_processor UriIncludeProcessor
end

Asciidoctor.convert_file './api_guidelines.adoc', :safe => :safe