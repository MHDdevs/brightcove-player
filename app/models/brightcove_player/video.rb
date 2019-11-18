module BrightcovePlayer
  class Video < ActiveRecord::Base
    self.primary_key = :brightcove_id
    @@_parents = []

    validates :brightcove_id, uniqueness: true, presence: true

    def parents
      r = []
      @@_parents.each do |parent|
        klass = Object.const_get parent[:name]
        a = klass.where("#{ActiveRecord::Base.connection.quote_column_name parent[:column]} = ?", brightcove_id).to_a
        a = a.map(&:globalized_model) if parent[:name].include? 'Translation'
        r << a if a.present?
      end
      r.flatten
    end

    def self.add_with_videos(hash)
      @@_parents << hash unless hash.in? @@_parents
    end
  end
end
