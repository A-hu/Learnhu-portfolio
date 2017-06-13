module ApplicationHelper
  def login_helper style = ''
    if current_user.is_a?(GuestUser)
      (link_to "Register", new_user_registration_path, class: style) +
        " ".html_safe +
        (link_to "Login", new_user_session_path, class: style)
    else
      (link_to "Edit Profile", edit_user_registration_path, class: style) +
        " ".html_safe +
        (link_to "Logout", destroy_user_session_path, method: :delete, class: style)
    end
  end

  def source_helper(styles)
    if session[:source]
      greeting = "Thanks for visiting me from #{session[:source]}, please feel free to #{ link_to 'Contact me', about_me_path } if you'd like to work together."
      content_tag(:div, greeting.html_safe, class: styles)
    end
  end

  def copyright name, msg
    "&copy: #{Time.now.year} | <b>#{name}</b> All rights reserved".html_safe
  end

  def nav_items
    [
      {
        url: about_me_path,
        title: "About"
      },
      {
        url: blogs_path,
        title: "Blog"
      },
      {
        url: portfolios_path,
        title: "Portfolio"
      },
      {
        url: tech_news_path,
        title: "News"
      }
    ]
  end

  def nav_helper style, tag_type
    nav_links = ''

    nav_items.each do |item|
      nav_links << "<#{tag_type}><a href='#{item[:url]}' class='#{style} #{active? item[:url]}'>#{item[:title]}</a></#{tag_type}>"
    end

    nav_links.html_safe
  end

  def active? path
    "active" if current_page? path
  end

  def alerts
    alert = (flash[:alert] || flash[:error] || flash[:notice])

    alert_generator alert if alert
  end

  def alert_generator msg
    js add_gritter(msg, title: "Learnhu Portfolio", sticky: false)
  end
end
