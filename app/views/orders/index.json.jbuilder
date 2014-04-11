json.array!(@orders) do |order|
  json.extract! order, :id, :name, :price
  json.url order_url(order, format: :json)
end
