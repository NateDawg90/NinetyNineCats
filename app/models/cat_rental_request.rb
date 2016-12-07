class CatRentalRequest < ActiveRecord::Base
  validates :status, inclusion: { in: %w(PENDING DENIED APPROVED),
      message: "%{value} is not a valid status" }
  validates :cat_id, :start_date, :end_date, presence: true
  validate :overlapping_approved_requests

  belongs_to :cat,
    foreign_key: :cat_id,
    class_name: :Cat

  def overlapping_requests?(other_request)
    other_start = other_request.start_date
    other_end = other_request.end_date
    return false if self.id == other_request.id

    other_start.between?(self.start_date, self.end_date) ||
    other_end.between?(self.start_date, self.end_date)
  end

  def overlapping_approved_requests
    CatRentalRequest.where(status: "APPROVED", cat_id: self.cat_id).each do |request|
      if self.overlapping_requests?(request)
        self.errors.add(:start_date, "or end date overlaps with existing request")
        return
      end
    end
  end

  def deny_conflicting_requests
    CatRentalRequest.where(status: "PENDING", cat_id: self.cat_id).each do |request|
      if self.overlapping_requests?(request)
        request.deny!
      end
    end
  end

  def approve!
    CatRentalRequest.transaction do
      self.status = 'APPROVED'
      self.save
      deny_conflicting_requests
    end

  end

  def deny!
    self.status = 'DENIED'
    self.save(validate: false)
  end

end
