# This is a monkey patch to enable the use of scopes in sort links
# https://gist.github.com/laserlemon/e5ce4e0d8bac63f4aa6835605ce3ec21

require "ransack/visitor"
require "ransack/adapters/active_record/context"

module Ransack
  Visitor.class_eval do
    def visit_Ransack_Nodes_Sort(object)
      # The first half of this conditional is the original implementation in
      # Ransack, as of version 1.6.6.
      #
      # The second half of the conditional kicks in when the column name
      # provided isn't found/valid. In those cases, we look for a scope on the
      # model that will apply a custom sort. If found, we return the scope's
      # name.
      if object.valid?
        object.attr.send(object.dir)
      else
        scope_name = :"sort_by_#{object.name}_#{object.dir}"
        scope_name if object.context.object.respond_to?(scope_name)
      end
    end
  end

  module Adapters
    module ActiveRecord
      Context.class_eval do
        def evaluate(search, opts = {})
          # From the original implementation:
          viz = Visitor.new
          relation = @object.where(viz.accept(search.base))

          # If any sorts are provided, we nuke any inherited sorts to give
          # ourselves a clean slate. This is the same behavior as the original
          # implementation.
          if search.sorts.any?
            relation = relation.except(:order)

            # Rather than applying all of the search's sorts in one fell swoop,
            # as the original implementation does, we apply one at a time.
            #
            # If the sort (returned by the Visitor above) is a symbol, we know
            # that it represents a scope on the model and we can apply that
            # scope.
            #
            # Otherwise, we fall back to the applying the sort with the "order"
            # method as the original implementation did. Actually the original
            # implementation used "reorder," which was overkill since we already
            # have a clean slate after "relation.except(:order)" above.
            viz.accept(search.sorts).each do |scope_or_sort|
              if scope_or_sort.is_a?(Symbol)
                relation = relation.send(scope_or_sort)
              else
                relation = relation.order(scope_or_sort)
              end
            end
          end

          # From the original implementation:
          opts[:distinct] ? relation.distinct : relation
        end
      end
    end
  end
end