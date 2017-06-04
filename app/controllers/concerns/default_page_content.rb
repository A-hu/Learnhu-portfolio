module DefaultPageContent
  extend ActiveSupport::Concern

  included do
    before_action :set_page_defaults
  end

  def set_page_defaults
    @page_title = "Learnhu Portfolio | Devcamp"
    @seo_keywords = "Louis Tseng portfolio"
  end
end
