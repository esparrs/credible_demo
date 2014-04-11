json.array!(@prices) do |price|
  json.extract! price, :id, :restaurant_id, :amount
  json.url price_url(price, format: :json)
end
