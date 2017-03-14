module UnitsHelper
  PALETTE = ['#7dd1e9', '#662d91', '#77C699', '#e94959', '#ffbe19'].freeze

  def palette(i)
    PALETTE[i % PALETTE.size]
  end
end
