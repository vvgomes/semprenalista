FactoryGirl.define do
  factory :user do
    name 'Dude'
    email 'dude@gmail.com'
    uid '666'
    provider 'facebook'
  end

  factory :club do
    name 'Beco'
  end

  factory :subscription do
    user
    club
  end
end

