class AssetsController < ApplicationController

  before_filter :login_required

  def create
    @asset = Asset.new @params[:asset]
    @asset.position = Asset.count
    if @asset.save
      redirect_to projects_url(:action => 'show', :id => @asset.project_id)
    else
      render :inline => "<%= error_messages_for :asset %>"
    end
  end

  def destroy
    @asset = Asset.find @params[:id]
    @asset.destroy
  end

  def update_caption
    @asset = Asset.find @params[:id]
    @asset.caption = @params[:value]
    if @asset.save
      render :text => textilight(@asset.caption)
    end
  end
  
  def sort
    asset_ids = @params[:asset_list]
    asset_ids.each_with_index do |asset_id, index|
      asset = Asset.find asset_id
      asset.update_attribute(:position, index)
    end
    render :nothing => true
  end

  def rotate
    @asset = Asset.find @params[:id]
    @asset.rotate(@params[:direction])
    redirect_to projects_url(:action => 'show', :id => @asset.project_id)
  end

end
