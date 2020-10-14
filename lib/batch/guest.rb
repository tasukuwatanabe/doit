class Batch::Guest
  def self.destroy
    if guest = User.find_by(email: 'guest@example.com')
      guest.destroy
    end
    system('rails r db/seeds/production/guest.rb')
  end
end
