module DashboardHelper
    def human_time(time)
        case t = Time.now - time
        when t < 1 then 'Today'
        when t < 2 then 'Yesterday'
        else time.strftime('%m/%d/%Y')
        end
    end
end
