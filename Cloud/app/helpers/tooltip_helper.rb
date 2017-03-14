module TooltipHelper
  def tooltip(message)
    content_tag :i, nil, class: 'fa fa-question-circle', data:
      { toggle: 'tooltip',
        title: message }
  end
end
