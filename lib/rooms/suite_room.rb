require_relative "room"

class SuiteRoom < Room
    BASE_RATE = 80
    RATE_PER_NIGHT = 40
    SUITE_FEE = 75
    
    def cost
        BASE_RATE + (nights * RATE_PER_NIGHT) + SUITE_FEE
    end
end