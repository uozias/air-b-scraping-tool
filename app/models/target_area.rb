class TargetArea < ActiveRecord::Base

  has_many :children, foreign_key: :target_area_id, class_name: 'TargetArea'
  belongs_to :parent, foreign_key: :target_area_id, class_name: 'TargetArea'
end
