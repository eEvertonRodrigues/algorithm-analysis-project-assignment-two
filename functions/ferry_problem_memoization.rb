def ferry_problem_memoization(ferry_length, cars)
    cars_quantity = cars.length
    memoization = {}

    solve = lambda do |index, left_ferry, right_ferry|
        if index == cars_quantity
            return 0
        end
        
        state = [index, right_ferry, left_ferry]
        if memoization.key?(state)
            return memoization[state]
        end
        

        put_car_in_left_ferry_shot = -1
        put_car_in_right_ferry_shot = -1    

        if cars[index] <= left_ferry
            put_car_in_left_ferry_shot = 1 + solve.call(
                index + 1,
                left_ferry - cars[index],
                right_ferry
                )
        end

        if cars[index] <= right_ferry
            put_car_in_right_ferry_shot = 1 + solve.call(
                index + 1,
                left_ferry,
                right_ferry - cars[index]
            )
        end

        if put_car_in_left_ferry_shot == -1 && put_car_in_right_ferry_shot == -1
            result = 0
        else
            result = [put_car_in_left_ferry_shot, put_car_in_right_ferry_shot].max
        end
        
        memoization[state] = result
    end
    solve.call(0, ferry_length, ferry_length)
end

l = 120
carros = [40, 30, 50, 20, 50, 90]

puts "Máximo de carros embarcados: #{ferry_problem_memoization(l, carros)}"