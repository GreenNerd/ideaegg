ActsAsTaggableOn::Tag.class_eval do
  validate :check_name_size

  private

  def check_name_size
    errors.add(:name, "长度错误") if (name.size + name.scan(/\p{Han}+/u).first.to_s.size) > 20
  end
end