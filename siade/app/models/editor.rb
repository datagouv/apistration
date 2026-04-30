class Editor < ApplicationRecord
  has_many :editor_delegations, dependent: :destroy
  has_many :tokens, class_name: 'EditorToken', dependent: :destroy
end
