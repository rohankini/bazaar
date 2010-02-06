class ItemsController < ApplicationController
  before_filter :load_city_tags
  
  def index
    @items = Item.all
  end
  
  def show
    @item = Item.find params[:id]
  end
  
  def filter
    filters = {}
    
    company = params[:company] && Company.find_by_name(params[:company])
    filters[:company_id] = company.id if company
    
    filters[:city] = params[:city] if params[:city]
    
    @items = Item.all(:conditions => filters)
    render :action => 'index'
  end
  
  def load_city_tags
    @tags = Item.all.collect(&:city)
  end
end
