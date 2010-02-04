module ItemsHelper
  def item_model(item)
    [item.company.try(:name), item.model].compact.join(" - ").to_s
  end
end