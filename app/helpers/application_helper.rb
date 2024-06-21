module ApplicationHelper
    def full_title(pagetitle='')
        basetitle='Ruby on Rails Tutorial Sample App'
        if pagetitle.empty?
            return basetitle
        else
            return pagetitle + ' | ' + basetitle
        end
    end
end
