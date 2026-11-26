FactoryBot.define do
  factory :editor_contact do
    editor
    role { 'technical' }
    full_name { 'Camille Technique' }
    email { 'contact@editor.com' }
    phone { '0123456789' }
  end
end
