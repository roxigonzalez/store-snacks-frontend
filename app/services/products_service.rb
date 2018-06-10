class ProductsService
  include ::HTTParty
  base_uri "#{Rails.application.secrets[:url_api]}"

  def initialize
  end

  def get_collection page=1
    products = self.class.get('/api/v1/products', query: { page: page })
    return if products.blank?
    JSON.parse(products.body)
  end

  def search_product name_product='', page=1
    products = self.class.get('/api/v1/products/search', query: { :"q[name_cont]" => name_product, page: page } )
    return if products.blank?
    JSON.parse(products.body)
  end
end
