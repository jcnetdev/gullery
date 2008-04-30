begin
  # Rails context
  require File.dirname(__FILE__) + '/../../../../test/test_helper'
rescue LoadError => e
  # Normal Ruby context
  $:.unshift(File.dirname(__FILE__) + "/../lib/")
  require 'test/unit'
  require 'mini_magick'
end

#uri = "http://www.usemycomputer.com/indeximages/2005/November/angelina_jolie_nov_2005_with_brad_512.jpg"
#uri = "http://www.imagemagick.org/script/command-line-options.php#size"

#uri = "http://images.blogads.com/qjudibusfouzbippdpn/pinkpremium/3278222/thumb?rev=rev_1"
#uri = "http://beta.sidewayspony.com/images/trough/development/2005/nov/20/21_orig_thumb_rev_rev_0.xxx"

class ImageTest < Test::Unit::TestCase
  include MiniMagick
  
  CURRENT_DIR = File.dirname(File.expand_path(__FILE__)) + "/"

  SIMPLE_IMAGE_PATH = CURRENT_DIR + "simple.gif"
  NOT_AN_IMAGE_PATH = CURRENT_DIR + "not_an_image.php"
  
  def test_image_from_blob
    File.open(SIMPLE_IMAGE_PATH, "r") do |f|
      image = Image.from_blob(f.read)
    end
  end
  
  def test_image_from_file
    image = Image.from_file(SIMPLE_IMAGE_PATH)
  end
  
  def test_image_new
    image = Image.new(SIMPLE_IMAGE_PATH)
  end
  
  def test_image_write
    output_path = "output.gif"
    begin
      image = Image.new(SIMPLE_IMAGE_PATH)
      image.write output_path
      
      assert File.exists?(output_path)
    ensure
      File.delete output_path
    end
  end
  
  def test_not_an_image
    assert_raise(MiniMagickError) do
      image = Image.new(NOT_AN_IMAGE_PATH)
    end
  end
  
  def test_image_info
    image = Image.new(SIMPLE_IMAGE_PATH)
    assert_equal 150, image.width
    assert_equal 55, image.height
    assert_match(/^gif$/i, image.format)
  end
  
  def test_image_resize
    image = Image.from_file(SIMPLE_IMAGE_PATH)
    image.resize "20x30!"

    assert_equal 20, image.width
    assert_equal 30, image.height
    assert_match(/^gif$/i, image.format)
  end 
  
  def test_image_combine_options_resize_blur
    image = Image.from_file(SIMPLE_IMAGE_PATH)
    image.combine_options do |c|
      c.resize "20x30!"
      c.blur 50
    end

    assert_equal 20, image.width
    assert_equal 30, image.height
    assert_match(/^gif$/i, image.format)
  end 
end 

class CommandBuilderTest < Test::Unit::TestCase
  include MiniMagick
  
  def test_basic
    c = CommandBuilder.new
    c.resize "30x40"
    assert_equal "-resize 30x40", c.args.join(" ")
  end
  
  def test_complicated
    c = CommandBuilder.new
    c.resize "30x40"
    c.input 1, 3, 4
    c.lingo "mome fingo"
    assert_equal "-resize 30x40 -input 1 3 4 -lingo mome fingo", c.args.join(" ")
  end
end
