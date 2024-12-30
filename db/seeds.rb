module Seeds
  class << self
    def log(message)
      puts message unless Rails.env.test?
    end
  end
end

Seeds.log "Loading seeds..."

# Load all seed files in order
Dir[Rails.root.join('db/seeds/*.rb')].sort.each do |file|
  Seeds.log "\nLoading #{File.basename(file)}..."
  load file
end

Seeds.log "\nSeeding completed!"
