json.array!(@admin_services) do |admin_service|
  json.extract! admin_service, :id, :name, :description, :price
  json.url admin_service_url(admin_service, format: :json)
end
