module Tool::Money
  include ActionView::Helpers::NumberHelper
  
  def to_round(total_amount)
    if total_amount > 0.01
      number_with_delimiter(total_amount.round(2))
    else
      total_amount
    end
  end
  
end