module Pagination
  class OhmAdapter < Collection
    def initialize(dataset, options = {})
      super

      @dataset = dataset
      @total   = dataset.size
      @sort_by = options[:sort_by]
      @order   = convert_order_param(options[:order])
      @start   = (page - 1) * per_page
    end

    def results
      if @dataset.kind_of?(Ohm::List)
        @dataset[@start, @per_page + @start - 1]
      elsif @sort_by
        @dataset.sort_by @sort_by, sort_options
      elsif @dataset.respond_to?(:sort) && !@dataset.method(:sort).arity.zero?
        @dataset.sort sort_options
      else
        @dataset.all sort_options
      end
    end

  protected
    def convert_order_param(order)
      case order
      when :asc  then "ASC ALPHA"
      when :desc then "DESC ALPHA"
      else
        order
      end
    end

    def sort_options
      { 
        :limit => @start ? [@start, @per_page] : [0, @per_page],
        :order => @order
      }
    end
  end
end
