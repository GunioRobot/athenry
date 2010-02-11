#@see http://ozmm.org/posts/try.html
class Object
  ##
  #   @person ? @person.name : nil
  # vs
  #   @person.try(:name)
  def try(method)
    send method if respond_to? method
  end


  #   if !foo.nil? && !foo.empty?
  # vs
  #   foo.blank?
  # @see http://apidock.com/rails/Object/blank%3F
  def blank?
    respond_to?(:empty?) ? empty? : !self
  end

end
