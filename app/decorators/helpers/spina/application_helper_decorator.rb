module Spina
  ApplicationHelper.module_eval do
    def sort_link(column, title = nil)
      title ||= column.titleize
      direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
      css_class = sort_direction == "asc" ? "sorting-up" : "sorting-down"
      css_class = column == sort_column ? css_class : ""
      link_to title, request.query_parameters.merge({ column: column, direction: direction }), class: css_class
    end
  end
end
