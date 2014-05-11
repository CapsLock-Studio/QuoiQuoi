json.array!(@materials) do |material|
    json.id material.id
    json.name material.material_translates.where(locale_id: session[:locale_id]).first.name
    json.medium_image material.image.url(:medium)
    json.large_image material.image.url(:large)
end