module DeviseHelper
  def devise_error_messages!
    if resource.errors.full_messages.any?
        flash.now[:error] = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    end
    return ''
  end
end
