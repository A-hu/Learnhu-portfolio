module DefaultPageContent
  extend ActiveSupport::Concern

  included do
    before_action :set_page_defaults
  end

  def set_page_defaults
    @page_title = "Learnhu Portfolio Blog"
    @seo_keywords = "Louis Tseng portfolio | Learnhu blog"
  end
end
