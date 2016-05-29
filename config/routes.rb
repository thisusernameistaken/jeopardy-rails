Jeopardy::Application.routes.draw do
  root 'main#home'

  get '/home', to: 'main#home'

  post '/', to: 'main#upload'

  get '/play', to: 'game#play'
  post '/play', to: 'game#join'
  get '/play/:gamecode', to: 'game#show'
  post '/play/:gamecode', to: 'game#post'

  get '/load/:gamecode', to: 'game#load_players'

  get '/q/:id', to: 'question#show'


  get '/update/:gamecode', to: 'game#update'

end
