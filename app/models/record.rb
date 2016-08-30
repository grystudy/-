class Record < ApplicationRecord
  belongs_to :region
  belongs_to :oiltype
  belongs_to :user
  belongs_to :revision
end
