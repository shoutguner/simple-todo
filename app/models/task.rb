class Task < ActiveRecord::Base
  belongs_to :project
  has_many :comments, dependent: :destroy

  after_create do |record|
    record.update_column :priority, record.id
  end

  validates :text, presence: true, uniqueness: { scope: :project_id }, length: { in: 1..140 }
  validates_datetime :deadline, allow_blank: true

  def self.change_priority(project_id, id, current_priority, direction)
    direction = case direction
                  when 'down' then '<'
                  when 'up' then '>'
                  else 'unresolved'
                end
    return false if direction == 'unresolved'
    order_dir = direction == '<' ? 'DESC' : 'ASC'
    next_task = where(project_id: project_id)
                    .where("priority #{direction} ?", "#{current_priority}")
                    .order(priority: "#{order_dir}").limit(1).first
    if next_task
      query_params = "(#{next_task.priority}, #{id}), (#{current_priority}, #{next_task.id})"
      query = "UPDATE tasks AS t SET
                priority = c.column_a
                from (values#{query_params}) AS c (column_a, column_b)
                WHERE c.column_b = id"
      ActiveRecord::Base.connection.execute(query)
    end
    return true
  end
end