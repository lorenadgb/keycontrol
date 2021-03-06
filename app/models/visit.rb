class Visit < ApplicationRecord
  extend EnumerateIt

  belongs_to :key
  belongs_to :building
  belongs_to :owner,   class_name: 'Person'
  belongs_to :visitor, class_name: 'Person'
  belongs_to :realtor, class_name: 'Person'

  validates :building_id, :key_id, :owner, :visitor, :realtor, :start_at, presence: true

  has_enumeration_for :visit_type

  before_create do
    self.set_status_to_borrowed
  end

  before_destroy :check_if_the_key_is_available

  default_scope { order(created_at: :desc) }

  scope :finished_at_is_nil, -> { where(finished_at: nil) }
  scope :by_key_id, ->(key) { where( key_id: key ).finished_at_is_nil.last }
  scope :by_owner_id,   ->(owner)   { where( owner_id: owner ) }
  scope :by_visitor_id, ->(visitor) { where( visitor_id: visitor ) }
  scope :by_realtor_id, ->(realtor) { where( realtor_id: realtor ) }
  scope :by_building_id, ->(building) { where( building_id: building ) }
  scope :gteq_start_at, ->(start_at) { where(arel_table[:start_at].gteq(start_at)) }
  scope :lteq_finished_at, ->(finished_at) { where(arel_table[:finished_at].lteq(finished_at))}

  scope :ordered, -> { order(created_at: :asc) }

  def set_status_to_borrowed
    self.key.update_key_status_to_borrowed
  end

  def set_status_to_available
    self.key.update_key_status_to_available
  end

  def update_finished_at
    update_column :finished_at, Time.now
  end

  def self.search(value)
    value ? joins(:key).joins(:building).joins(:realtor).where("buildings.code ILIKE :value OR keys.code ILIKE :value OR people.name ILIKE :value", value: "%#{value}%") : all
  end

  private

  def check_if_the_key_is_available
    unless self.key.status == KeyStatus::AVAILABLE
      errors.add(:base, I18n.t('models.visit.errors.has_key_not_available'))
      throw :abort
    end
  end
end
