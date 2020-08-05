module ADLicenseLint
  class Report
    attr_reader :entries

    def initialize(entries)
      @entries = entries
    end

    def to_hash
      { entries: @entries.map(&:to_hash) }
    end

    def empty?
      @entries.empty?
    end
  end
end