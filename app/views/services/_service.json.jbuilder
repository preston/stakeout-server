json.extract! service, :id, :dashboard_id, :host, :name, :ping, :ping_threshold, :ping_last, :http, :https,
              :http_path, :http_path_last, :https_path_last, :http_xquery, :http_xquery_last, :http_preview, :checked_at, :created_at, :updated_at

json.http_screenshot service.http_screenshot ? Base64.encode64(service.http_screenshot) : nil

# json.asset_available service.asset.attached?

json.path dashboard_service_path(service.dashboard, service)
json.url dashboard_service_url(service.dashboard, service)
