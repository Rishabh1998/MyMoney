$investments = []
$weights = {}
$sip = {
    equity: 0,
    debt: 0,
    gold: 0
}
$month = {"january": 0, "february": 1, "march": 2, "april": 3, "may": 4, "june": 5, "july": 6,
            "august": 7, "september": 8, "october": 9, "november": 10, "december": 11}

def allocate(equity, debt, gold)
    total = equity + debt + gold
    $investments = [{
            equity: equity,
            debt: debt,
            gold: gold,
            total: total
    }]
    $weights = {
        equity: equity*100.0/total,
        debt: debt*100.0/total,
        gold: gold*100.0/total
    }
end

def initialize_sip(equity, debt, gold)
    $sip[:equity] = equity
    $sip[:debt] = debt
    $sip[:gold] = gold
end

def change(equity_perc, debt_perc, gold_perc, month_number) 
    if month_number != 0
        $investments[month_number] = {}
        $investments[month_number][:equity] = $investments[month_number - 1][:equity] + $sip[:equity]
        $investments[month_number][:debt] = $investments[month_number - 1][:debt] + $sip[:debt]
        $investments[month_number][:gold] = $investments[month_number - 1][:gold] + $sip[:gold]
    end
    $investments[month_number][:equity] += ($investments[month_number][:equity]*equity_perc/100.0)
    $investments[month_number][:debt] += ($investments[month_number][:debt]*debt_perc/100.0)
    $investments[month_number][:gold] += ($investments[month_number][:gold]*gold_perc/100.0)
end

def balance(month_number)
    data = $investments[month_number]
    puts("#{data[:equity].to_i} #{data[:debt].to_i} #{data[:gold].to_i}")
end

def rebalance(equity, debt, gold)
    total = equity + debt + gold
    equity = total*$weights[:equity]/100
    debt = total*$weights[:debt]/100
    gold = total*$weights[:gold]/100
    puts "#{equity.to_i} #{debt.to_i} #{gold.to_i}"
end

def check_if_rebalnce_is_possible
    if !$investments[$month[:december]].nil?
        rebalance($investments[$month[:december]][:equity], $investments[$month[:december]][:debt], $investments[$month[:december]][:gold])
    elsif !$investments[$month[:june]].nil?
        rebalance($investments[$month[:june]][:equity], $investments[$month[:june]][:debt], $investments[$month[:june]][:gold])
    else
        puts "CANNOT_REBALANCE"
    end
end

def main
    input = File.open(ARGV[0], "r")

    input.each do |line|
        data = line.split(" ")
        case data[0]
        when "ALLOCATE"
            allocate(data[1].to_f, data[2].to_f, data[3].to_f)
        when "SIP"
            initialize_sip(data[1].to_f, data[2].to_f, data[3].to_f)
        when "CHANGE"
            change(data[1].to_f, data[2].to_f, data[3].to_f, $month[data[4].downcase.to_sym])
        when "BALANCE"
            balance($month[data[1].downcase.to_sym])
        when "REBALANCE"
            check_if_rebalnce_is_possible
        end
    end
    input.close
end

main
