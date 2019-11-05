module Twitter
  module Enumerable
    include ::Enumerable

    EMPTY_RESPONSE_LIMIT = 1

    # @return [Enumerator]
    def each(start = 0, without_new = 0)
      return to_enum(:each, start) unless block_given?
      empty_response = true
      Array(@collection[start..-1]).each do |element|
        empty_response = false
        yield(element)
      end
      unless finished?
        without_new += 1 if empty_response
        return self if without_new >= EMPTY_RESPONSE_LIMIT
        start = [@collection.size, start].max
        fetch_next_page
        each(start, without_new, &Proc.new)
      end
      self
    end

  private

    # @return [Boolean]
    def last?
      true
    end

    # @return [Boolean]
    def reached_limit?
      false
    end

    # @return [Boolean]
    def finished?
      last? || reached_limit?
    end
  end
end
