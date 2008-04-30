desc "Copy third-party gems into ./lib"
task :freeze_other_gems do
  libraries = %w(acts_as_taggable)
  require 'rubygems'
  require 'find'

  libraries.each do |library|
    library_gem = Gem.cache.search(library).sort_by { |g| g.version }.last
    puts "Freezing #{library} for #{library_gem.version}..."
    folder_for_library = "#{library_gem.name}-#{library_gem.version}"
    system "cd vendor; gem unpack -v '#{library_gem.version}' #{library_gem.name};"

    # Copy files recursively to ./lib
    folder_for_library_with_lib = "vendor/#{folder_for_library}/lib/"
		Find.find(folder_for_library_with_lib) do |original_file|
		  destination_file = "./lib/" + original_file.gsub(folder_for_library_with_lib, '')
		  if File.directory?(original_file)
		    if !File.exist?(destination_file)
		      Dir.mkdir destination_file
		    end
	    else
	      File.copy original_file, destination_file
		  end
		end
    rm_r "vendor/#{folder_for_library}"  
  end
end
