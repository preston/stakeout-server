Stakeout::Application.routes.draw do

	resources :dashboards do
		resources :services
	end
	
	# get "welcome/index",	as: 'home'
	get 'legal' => 'welcome#legal',	as: 'legal'
	get 'about' => 'welcome#about',	as: 'about'
	get 'status' => 'welcome#status',	as: 'status'

	root to: 'dashboards#index'

end
