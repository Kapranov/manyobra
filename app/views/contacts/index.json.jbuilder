json.array!(@contacts) do |contact|
  json.extract! contact, :id, :name, :email, :phone, :subject
  json.url contact_url(contact, format: :json)
end
