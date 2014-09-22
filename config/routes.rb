OhlifeExport::Application.routes.draw do
  root  'welcome#index'
  match 'zip' => 'download_zip#show', via: [:post]
  match 'export' => 'welcome#export_text', via: [:post]
end