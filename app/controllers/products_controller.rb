class ProductsController < ApplicationController

  helper_method :products, :next_page

  def search
    @products ||= ProductsService.new().search_product(params[:name], page_params)
  end

  private

  def products
    @products ||= ProductsService.new().get_collection(page_params)
  end

  def next_page(i=1)
    (i.to_i+1)
  end

  private

  def product_name_params
    puts "#{params[:name]}"
    params[:name].present? ? params[:name] : ''
  end

  def page_params
    params[:page].present? ? params[:page] : 1
  end

end
