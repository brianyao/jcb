class Word < ActiveRecord::Base
	belongs_to :user
	validates :title, :presence => true
	validate :counts_verify

	def counts_verify
		if self.attempt_count < self.failed_count
			errors.add(:attempt_count, 'must be larger than failed_count')
		end
	end
end