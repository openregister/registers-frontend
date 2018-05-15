module DownloadHelpers
  include ActionView::Helpers::UrlHelper
  def link_to_format(format)
    link_to(format.upcase, "#{@register.url}/records.#{format}?page-size=5000")
  end
end
