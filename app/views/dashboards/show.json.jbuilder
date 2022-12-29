json.extract! @dashboard, :id, :name, :created_at, :updated_at

json.path dashboard_path(@dashboard)
json.url dashboard_url(@dashboard)

json.services do
    json.partial! 'services/service', collection: @dashboard.services, as: :service

#   json.array! @dashboard.services do |s|
#     json.extract! s, :id, :name, :created_at, :updated_at
#     # json.path dashboard_path(d)
#     # json.url dashboard_url(d)
#   end
end
