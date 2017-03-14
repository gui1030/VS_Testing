module SessionHelper
  def referer=(path)
    session[:referer] = path
  end

  def referer
    session[:referer] || :back
  end
end
