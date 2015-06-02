ActsAsTaggableOn::Tag.class_eval do
  validates_length_of :name, maximum: 10
end