module Pagination
  # Loads lines from a file
  class FileAdapter < Collection
    def initialize(filename, options = {})
      p [:filename, filename]
      super

      @filename = filename
      @start = (page - 1) * per_page

      if options[:filter]
        # filter with grep
        filtered = File.open(@filename).lines.grep(options[:filter])
        @total = filtered.size
        @dataset = filtered[@start, per_page]

      else
        # very fast if you want everything
        @total = %x[ wc -l #{filename} ].strip.split(/ /).first.to_i

        file = File.open(@filename)
        lines = file.lines
        (@start - 1).times { lines.next } # skip until @start
        @dataset = lines.take(per_page)
      end
    end

    def results
      @dataset
    end

  end
end
