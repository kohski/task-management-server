# frozen_string_literal: true

FactoryBot.define do
  factory :job do
    group { Group.first || FactoryBot.create(:group) }
    sequence(:title) { |n| "test title #{n}" }
    sequence(:overview) { |n| "test title #{n}" }
    image { 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAB4AAAAeCAAAAAAeW/F+AAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAAAmJLR0QA/4ePzL8AAAAHdElNRQfjBRQABBrSkbBKAAAAT0lEQVQoz2M4gxcwjEoPkPSmjau3rNoEFULmQKSPr18/59icM2e27d2J4MClTx05Mn8+SOTUIiQOQve6DRs2rwSat+XAdgRncPh7VBoNAABwbMd4Pq/U3gAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAxOS0wNS0yMFQwOTowNDoyNiswOTowMOwn1y0AAAAldEVYdGRhdGU6bW9kaWZ5ADIwMTktMDUtMjBUMDk6MDQ6MjYrMDk6MDCdem+RAAAAAElFTkSuQmCC' }
    owner_id { User.first ? User.first.id : FactoryBot.create(:user).id }
    base_date_time { DateTime.now }
    due_date_time { DateTime.now + 1 }
    frequency { 0 }
    is_done { false }
    is_approved { false }
  end
end
