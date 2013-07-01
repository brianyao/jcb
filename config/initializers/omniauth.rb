Rails.application.config.middleware.use OmniAuth::Builder do
  # provider :facebook, '623565124338631', '695218faf272810b50cfc5f3fbced335'
  # localhost:3000
  provider :facebook,   '370472209740767', 'c349de4298ca8f533c2a741662648ebc'
  provider :weibo,      '1120491544',      '3c207d5c21f7080759e15ea42dfd2332'
  provider :qq_connect, '100476877',       '7eda1ece1c68f2bc81d5add294cc4c23'
  
  # provider :twitter, '5xviWhmRAkQmGv2mT47Ygg', 'lhlCsDWq3qzPzYYthZAv0BC33SGOchufPG66mpoSbg'
end