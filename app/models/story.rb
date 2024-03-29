include ApplicationHelper

class Story < ActiveRecord::Base
  def set_control(user)
    self.current_editor = user
    self.last_editor = user 
    self.control_time = Time.zone.now.strftime('%s')
    self.save

    Thread.new do
      curr_rev = self.revnum
      sleep edittime
      self.reload
      if self.revnum == curr_rev
        self.release_control
        self.save
      end
    end
  end

  def release_control
    self.current_editor = nil
    self.save
    Thread.new do
      UserMailer.fanfic_open(self).deliver
    end
  end

  def pretty_date
    return self.updated_at.month.to_s + '/' + self.updated_at.day.to_s + '/' + self.updated_at.year.to_s
  end

  def deactivate
    self.is_active = false;
    self.save
  end

  def setActive
    Story.all.each {|s| s.deactivate; s.save}
    self.is_active = true
    self.last_editor = nil
    self.save
  end

  def get_editing_time
    if self.control_time == nil
      return edittime
    end
    return (Time.at(edittime) - (Time.now - Time.at(self.control_time.to_i))).strftime('%s')
  end
end
