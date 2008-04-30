# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def show_page_title
    !@user.nil? && !@user.company.blank? ? @user.company : 'gullery photo gallery'
    
  end

  def show_page_nav
    user = User.find_first
    return 'gullery photo gallery' if user.nil?
    nav = link_to(user.company, :controller => '/')
    nav += ' ' + content_tag(:small, link_to((@project.name), projects_url(:action => 'show', :id => @project))) if @project
    nav
  end
  
  
end
