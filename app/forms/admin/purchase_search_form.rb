class Admin::PurchaseSearchForm
  include ActiveModel::Model

  attr_accessor :undelivered, :email, :remarks
  attr_reader :purchased_at_from, :purchased_at_to

  def purchased_at_from=(value)
    return if value.blank?
    @purchased_at_from = Date.strptime(value, '%Y-%m-%d')
  end
  def purchased_at_to=(value)
    return if value.blank?
    @purchased_at_to = Date.strptime(value, '%Y-%m-%d')
  end

  def search(page)
    purchases = Purchase.includes(:member, details: [:item])
    purchases = purchases.where(delivered: false) if undelivered.present? && undelivered == '1'
    purchases = purchases.where(member: [email: email]) if email.present?
    purchases = purchases.where('`purchases`.`created_at` >= ?', @purchased_at_from) if purchased_at_from.present?
    purchases = purchases.where('`purchases`.`created_at` < ?', @purchased_at_to + 1.day) if purchased_at_to.present?
    purchases = purchases.where('`purchases`.`remarks` LIKE ?', "%#{remarks}%") if remarks.present?
    purchases.page(page).per(50).order(id: :desc)
  end

end