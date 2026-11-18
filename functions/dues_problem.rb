
def dues_problem(dues, days)
    dues = dues.sort_by { |due| -due[1] }
    book = {}

    (1..days).each do |day|
        book[day] = -1
    end

    for due in dues
        [due[0], days].min.downto(1) do |day|
            if book[day] == -1
                book[day] = due
                break
            end
        end
    end

    return book
end

days = 6
dues = [[1, 5], [2, 3], [2, 8], [2, 12], [4, 1]]

puts dues_problem(dues, days)