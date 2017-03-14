module LazyHelper
  def lazy_value(path)
    content_tag(:i, nil, class: 'fa fa-spinner fa-spin', data: { replace: path })
  end
end
