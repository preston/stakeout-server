
namespace :stakeout do

    def update_older_than(t)
        list = Service.where('checked_at IS NULL OR checked_at <= ?', t).all
        puts "Updating #{list.length} services..."
        list.each do |s|
            puts "\t#{s.name}"
            s.check
        end
    end
    
	desc 'Serially checks all known services not updated within the last minute.'
	task check_1_minute: :environment do
        update_older_than(1.minute.ago)
    end

	desc 'Serially checks all known services not updated within the 5 minutes.'
	task check_5_minutes: :environment do
        update_older_than(5.minutes.ago)
    end
end