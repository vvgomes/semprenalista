FactoryGirl.define do
  factory :user do
    name 'Dude'
    email 'dude@gmail.com'
    image 'image.jpg'
    provider 'facebook'
    uid '123456'
    access_token 'AAbbCC'
  end
end

