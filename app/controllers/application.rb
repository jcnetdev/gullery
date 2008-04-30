# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  
  helper_method :textilight, :textilize
  
  def textilight(text='')
    r = RedCloth.new text
    r.hard_breaks = false
    r.to_html.gsub(/^<p>/, '').gsub(/<\/p>$/, '')
  end

  def textilize(text='')
    r = RedCloth.new text
    r.hard_breaks = false
    r.to_html.gsub(/^\s+/, '')
  end
  
end