require "open-uri"
require "tempfile"
require "stringio"

module MiniMagick
  
  VERSION = '0.5'
  
  class MiniMagickError < Exception
  end
    
  class Image
    attr :path

    # Attributes
    # ----------    
    def width
      info[:width]
    end

    def height
      info[:height]
    end

    def format
      info[:format]
    end

    # Class Methods
    # -------------
    class <<self
      def from_blob(blob)      
        begin
          tmp = Tempfile.new("minimagic")
          tmp.write(blob)         
        ensure
          tmp.close
        end      
        
        return self.new(tmp.path)
      end
      
      # Use this if you don't want to overwrite the image file
      def from_file(image_path)      
        File.open(image_path, "r") do |f|
          self.from_blob(f.read)
        end
      end
    end
    
    # Instance Methods
    # ----------------    
    def initialize(input_path)
      
      @path = input_path
      
      # Ensure that the file is an image
      run_command("identify #{@path}")      
    end
        
    def write(output_path)      
      open(output_path, "w") do |output_file|
        open(@path) do |image_file|
          output_file.write(image_file.read)
        end
      end      
    end
      
    # Any message that sent that is unknown is sent through mogrify 
    #
    # Look here to find all the commands (http://www.imagemagick.org/script/mogrify.php)
    def method_missing(symbol, *args)
      args.push(@path) # push the path onto the end
      run_command("mogrify", "-#{symbol}", *args)
    end
    
    # You can use multiple commands together using this method
    def combine_options(&block)      
      c = CommandBuilder.new
      block.call c
      run_command("mogrify", *c.args << @path)
    end
          
    # Private (Don't look in here!)
    # -----------------------------
    private
    
    def info
      info_array = run_command("identify", @path).split
      info = {
        :format => info_array[1],
        :width => info_array[2].match(/^\d+/)[0].to_i,
        :height => info_array[2].match(/\d+$/)[0].to_i 
      }
    end
    
    def run_command(command, *args)
      args = args.collect {|a| a.to_s}
      output = `#{command} #{args.join(' ')}`
      if $? != 0
        raise MiniMagickError, "ImageMagick command (#{command} #{args.join(' ')}) failed: Error Given #{$?}"
      else
        return output
      end  
    end
  end

  class CommandBuilder
    attr :args
    
    def initialize
      @args = []
    end
    
    def method_missing(symbol, *args)
      @args += ["-#{symbol}"] + args
    end    
  end
end
