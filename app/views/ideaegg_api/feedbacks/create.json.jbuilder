json.(@feedback, :id, :body, :stars, :images, :contact, :anonymous)
json.product do
  json.(@product, :id, :name)
end