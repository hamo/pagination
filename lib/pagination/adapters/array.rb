module Pagination
  class ArrayAdapter < Collection
    def initialize(dataset, options = {})
      super

      @dataset = dataset
      @total   = dataset.size
      @sort_by = options[:sort_by]
      @start   = (page - 1) * per_page
    end

    def results
      @dataset[@start, @per_page + @start - 1]
    end

  end
end
