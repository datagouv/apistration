namespace :v2, constraints: APIParticulierDomainConstraint.new do
  get 'dummy' => '/api_particulier/v2/dummy#show'
end
