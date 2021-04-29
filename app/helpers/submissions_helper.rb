module SubmissionsHelper
  def preview_class(local_index, form_index)
    return_class = 'preview'
    if form_index == -1 
      return ''
    elsif local_index == form_index
      return_class << ' active'
    elsif local_index < form_index
      return_class << ' done'
    else
      return_class << ' todo'  
    end
    return_class
  end

end
