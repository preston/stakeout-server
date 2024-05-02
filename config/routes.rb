Stakeout::Application.routes.draw do

	resources :dashboards do
		resources :services
	end
	
	# get "welcome/index",	as: 'home'
	get 'status' => 'welcome#status',	as: 'status'
	post 'test' => 'welcome#test',	as: 'test'

	root to: 'dashboards#index'

end
