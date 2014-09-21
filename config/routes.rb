OhlifeExport::Application.routes.draw do
  root 'welcome#index'
  match 'zip' => 'download_zip#show', via: [:post]
end
