module BlogsHelper
  def avatar_helper user, width, type
    fb_regex = %r{(?:https?:\/\/)?(?:www\.)?facebook\.com\/(?:(?:\w\.)*#!\/)?(?:pages\/)?(?:[\w\-\.]*\/)*([\w\-\.]*)}

    if user.image.present? && user.image.match(fb_regex)
        image_tag user.image, size: width, class: type
    else
      gravatar_helper user, width, type
    end
  end

  def gravatar_helper user, width, type = ''
    image_tag "https://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(user.email)}", width: width, class: type
  end

  def subscribed_helper user, target
    if user.class == User
      if user.like_topics.include?(target)
        link_to fa_icon('rss', text: "#{target.title}", style: 'opacity: 1'), target
      else
        link_to fa_icon('rss', text: "#{target.title}", style: 'opacity: 0.3'), target
      end
    end
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
    fa_icon "bookmark" if blog.sticky?
  end
end
