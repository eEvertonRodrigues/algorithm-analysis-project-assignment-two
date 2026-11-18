
def ferry_problem_memoization_mapping_solution(ferry_length, cars)
    cars_quantity = cars.length
    memoization = {}
    allocations = {}

    solve = lambda do |index, left_ferry, right_ferry|
        if index == cars_quantity
            return 0
        end

        state = [index, left_ferry, right_ferry]

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

        if put_car_in_left_ferry_shot == -1 &&
           put_car_in_right_ferry_shot == -1
            result = 0
        elsif put_car_in_left_ferry_shot >= put_car_in_right_ferry_shot
            result = put_car_in_left_ferry_shot
            allocations[state] = :left
        else
            result = put_car_in_right_ferry_shot
            allocations[state] = :right
        end

        memoization[state] = result
    end

    max_cars = solve.call(0, ferry_length, ferry_length)

    mapping = []
    index = 0
    left_ferry = ferry_length
    right_ferry = ferry_length

    while index < max_cars
        state = [index, left_ferry, right_ferry]
        side = allocations[state]

        break if side.nil?

        mapping << { car: index, side: side }

        if side == :left
            left_ferry -= cars[index]
        else
            right_ferry -= cars[index]
        end

        index += 1
    end

    {
        max_cars: max_cars,
        mapping: mapping
    }
end

l = 100
carros = [40, 30, 50, 50, 90]

result = ferry_problem_memoization_mapping_solution(l, carros)

puts "Máximo de carros embarcados: #{result[:max_cars]}"
puts "Alocação: #{result[:mapping]}"
