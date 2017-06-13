module BlogsHelper
  def gravatar_helper user, width, type = ''
    image_tag "https://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(user.email)}", width: width, class: type
  end

  class CodeRayify < Redcarpet::Render::HTML
    def block_code(code, language)
      CodeRay.scan(code, language).div
    end
  end

  def markdown text
    coderayified = CodeRayify.new(filter_html: true, hard_wrap: true)

    options = {
      fenced_code_blocks: true,
      no_intra_emphasis: true,
      autolink: true,
      lax_html_blocks: true,
      highlight: true,
    }

    markdown_to_html = Redcarpet::Markdown.new(coderayified, options)
    markdown_to_html.render(text).html_safe
  end

  def blog_status_color blog
    if blog.draft?
      'color: red;'
    elsif blog.sticky?
      'color: gold;'
    end
  end

  def sticky_helper blog
    "<span style='color: gold'>&#9733;</span>  ".html_safe if blog.sticky?
  end
end
